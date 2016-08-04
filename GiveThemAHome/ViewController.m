//
//  ViewController.m
//  GiveThemAHome
//
//  Created by Evan on 2016/7/4.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "ViewController.h"
#import "TitleView.h"
#import "DataModel.h"
#import "ListCell.h"
#import "ImageCache.h"
#import "SearchViewController.h"
#import "DetailVC.h"
#import "TransData.h"
#import "Animal.h"
#import "CoreDataManager.h"

@interface ViewController ()<NSURLSessionDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int currentPage;
    NSURLSessionConfiguration *defaultConfigObject;
    NSURLSession *defaultSession;
    NSString *mainURL;
    BOOL isLast;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arr_ImgURL;
@property (nonatomic, strong) NSMutableArray *arr_Result;
@property (nonatomic, strong) NSMutableArray *arr_Favorite;
@property (nonatomic, strong) NSOperationQueue *imageQueue;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *acView;
@property (nonatomic, strong) UIImageView *ac;
@property (nonatomic, strong) ImageCache *cache;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserDefaults];
    [self initProperty];
    [self initView];
    [self addACView];
    [self getResultData];
    [self setNotificationCenter];
    
}

//判斷有無搜尋條件
-(void) initUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"haveSearch"])
    {
        return;
    }
    [defaults setBool:YES forKey:@"haveSearch"];
    [defaults setObject:@"不限" forKey:@"search_Area"];
    [defaults setObject:@"不限" forKey:@"search_KindType"];
    [defaults setObject:@"不限" forKey:@"search_BodyType"];
    [defaults setObject:@"不限" forKey:@"search_Age"];
    [defaults setObject:@"不限" forKey:@"search_Color"];
    [defaults setObject:@"不限" forKey:@"search_Sex"];
    [defaults synchronize];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [_cache.allDownloadOperationCache removeAllObjects];
    [_cache.allImageCache removeAllObjects];
    [self getResultData];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getFavorite];
    [self checkFavorite];
    [self.tableView reloadData];
}

-(void)initProperty
{
    currentPage = 0;
    _arr_ImgURL = [[NSMutableArray alloc] init];
    _imageQueue = [[NSOperationQueue alloc] init];
    _imageQueue.maxConcurrentOperationCount = 3;
    _arr_Result = [[NSMutableArray alloc] init];
    _cache = [ImageCache sharedImageCache];
    isLast = NO;
}

-(void)initView
{
    [self initTitleView];
    [self initTableView];
    
}

-(void)initTitleView
{
    
    TitleView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"TitleView"
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
    titleView.frame = CGRectMake(0,0,200,44);
    self.navigationItem.titleView = titleView;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255.0f green:52.0/255.0f blue:93.0/255.0f alpha:1]];
}

-(void)initTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    _tableView.estimatedRowHeight = 270.f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [self ActivityIndicatorView];

}

-(UIView *)ActivityIndicatorView
{
    //把 UIActivityIndicatorView 加到 tableFooterView
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 36)];
    _ac = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,16,16)];
    
    _ac.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"ac-1"],[UIImage imageNamed:@"ac-2"],[UIImage imageNamed:@"ac-3"],nil];
    _ac.animationDuration = 1.0; // in seconds
    _ac.animationRepeatCount = 0; // sets to loop
    [_ac startAnimating];
    _ac.center = view.center;
    [_ac startAnimating];
    [view addSubview:_ac]; // <-- Your UIActivityIndicatorView
    
    return view;
}

-(void)addACView
{
    _acView.hidden = NO;
    _acView.layer.cornerRadius = 10;
    [_acView startAnimating];
}

-(NSString *)makeUrl
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //地區
    NSString *search_Area = [[TransData getAnimal_Area_DicKeyWithArea:[defaults objectForKey:@"search_Area"]] isEqualToString:@"不限"]?@"":[NSString stringWithFormat:@"animal_area_pkid+like+%@",[TransData getAnimal_Area_DicKeyWithArea:[defaults objectForKey:@"search_Area"]]];
    //種類
    NSString *search_KindType = [[defaults objectForKey:@"search_KindType"] isEqualToString:@"不限"]?@"":[NSString stringWithFormat:@"animal_kind+like+%@",[defaults objectForKey:@"search_KindType"]];
    //體型
    NSString *search_BodyType = [[defaults objectForKey:@"search_BodyType"] isEqualToString:@"不限"]?@""
    :[NSString stringWithFormat:@"animal_bodytype+like+%@",[TransData getBodytype:[defaults objectForKey:@"search_BodyType"]]];
    //年齡
    NSString *search_Age = [[defaults objectForKey:@"search_Age"] isEqualToString:@"不限"]?@"":[NSString stringWithFormat:@"animal_bodytype+like+%@",[TransData getAnimal_age:[defaults objectForKey:@"search_Age"]]];
    //毛色
    NSString *search_Color = [[defaults objectForKey:@"search_Color"] isEqualToString:@"不限"]?@"":[NSString stringWithFormat:@"animal_colour+like+%@",[defaults objectForKey:@"search_Color"]];
    //性別
    NSString *search_Sex = [[defaults objectForKey:@"search_Sex"] isEqualToString:@"不限"]?@"":[NSString stringWithFormat:@"animal_sex+like+%@",[TransData getAnimal_Sex:[defaults objectForKey:@"search_Sex"]]];
    
    NSString *filter = @"&$filter=";
    NSString *and = @"+and+";
    
    NSArray *arr_Temp = [[NSArray alloc] initWithObjects:search_Area,search_KindType,search_BodyType,search_Age,search_Color,search_Sex,nil];
    NSMutableArray *marr = [[NSMutableArray alloc] init];
    NSMutableString *str_Filter= [[NSMutableString alloc] init];
    for (int i = 0; i < arr_Temp.count; i++)
    {
        if (((NSString *)[arr_Temp objectAtIndex:i]).length > 0)
        {
            [marr addObject:[arr_Temp objectAtIndex:i]];
        }
    }

    if ( marr.count > 0)
    {
        for (int i = 0; i < marr.count; i++)
        {
            if (str_Filter.length > 0)
            {
                [str_Filter appendString:and];
            }
            [str_Filter appendString:((NSString *)[marr objectAtIndex:i])];
        }
    }
    
    NSString *urlWebAddress = @"http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx";
    NSString *urlPage = [NSString stringWithFormat:@"?$top=3&$skip=%i",currentPage];
    NSString *str_URL = [NSString stringWithFormat:@"%@%@%@%@",urlWebAddress,urlPage,filter,str_Filter];
    
    //filter只組一次 之後就不組 所以存在mainURL
    mainURL = [NSString stringWithFormat:@"%@%@%@%@",urlWebAddress,@"?$top=3&$skip=%i",filter,str_Filter];
    return str_URL;
}

#pragma mark 抓取我的最愛資料
-(void)getFavorite
{
    _arr_Favorite = [[NSMutableArray alloc] init];
    _arr_Favorite = [CoreDataManager getAllResult];
}

#pragma mark 搜尋條件段
//註冊通知中心 當按下搜尋要重新撈資料
-(void) setNotificationCenter
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchAction:)
                                                 name:@"searchAction"
                                               object:nil];
}

//下搜尋條件後重新撈資料
- (void) searchAction:(NSNotification*) notification
{
    mainURL = @"";
    [self addACView];
    _tableView.hidden = YES;
    [self initProperty];
    [_cache.allDownloadOperationCache removeAllObjects];
    [_cache.allImageCache removeAllObjects];
    [self getResultData];
    [self getFavorite];
}

#pragma mark 抓取資料
-(void)getResultData
{
//"http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx?$top=3&$skip=%i&$filter=animal_area_pkid+like+%i+and+animal_kind+like+狗
    NSString *urlString;
    if (mainURL.length > 0)
    {
        urlString = [NSString stringWithFormat:mainURL,currentPage];
    }
    else
    {
        urlString = [self makeUrl];
    }
    
    //邊碼 UTF-8
    NSString *encodeUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:encodeUrl];
    
    defaultConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    _ac.startAnimating;
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            [self saveResultData:data];
                                                            _acView.stopAnimating;
                                                            _acView.hidden = YES;
                                                            _tableView.hidden = NO;
                                                        }
                                                    }];
    
    [dataTask resume];
}

#pragma mark 存取資料
-(void)saveResultData:(NSData *)data
{
    NSError *error = nil;
    NSArray *arrTemp = [[NSArray alloc] init];
    
    arrTemp = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
    if (arrTemp.count < 3)
    {
        isLast = YES;
        _ac.stopAnimating;
    }
    //to do to do
    for (int i = 0; i < arrTemp.count ; i++)
    {
        NSDictionary * dic = [arrTemp objectAtIndex:i];
        DataModel *m = [DataModel modelDataWithDic:dic];
        m.is_favorite = NO;
//        Animal *m = [Animal modelDataWithDic:dic];
        for (int j = 0; j < _arr_Favorite.count; j++)
        {
            DataModel * d= [_arr_Favorite objectAtIndex:j];
            if ([m.animal_id isEqualToString:d.animal_id])
            {
                m.is_favorite = YES;
            }
        }
        [_arr_Result addObject:m];
        [_arr_ImgURL addObject:m.album_file];
    }
    
    [_tableView reloadData];
}

//重新再判斷一次Favorite
-(void)checkFavorite
{
    if (_arr_Result.count > 0)
    {
        for (int i = 0; i < _arr_Result.count ; i++)
        {
            DataModel * m= [_arr_Result objectAtIndex:i];
            m.is_favorite = NO;
            for (int j = 0; j < _arr_Favorite.count; j++)
            {
                DataModel * d= [_arr_Favorite objectAtIndex:j];
                if ([m.animal_id isEqualToString:d.animal_id])
                {
                    m.is_favorite = YES;
                }
            }
        }
    }
}

//載入下一頁
-(void)loadNextPage
{
    if (isLast)
    {
        return;
    }
    currentPage = currentPage +3;
    [self getResultData];
}

#pragma mark 下載照片
- (void)downloadImage:(NSIndexPath *)indexPath
{
    //判断下载緩衝中使否存在當前下載
    NSString *str_ImgURL = [_arr_ImgURL objectAtIndex:indexPath.row];
    if ([_cache.allDownloadOperationCache objectForKey:str_ImgURL])
    {
        NSLog(@"正在下载ing...");
        return;
    }
    
    defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.timeoutIntervalForResource = 6;
    defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: _imageQueue];
    
    NSURL * url = [NSURL URLWithString:str_ImgURL];
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSURLSessionDownloadTask * downloadImageTask = [defaultSession downloadTaskWithURL:url];
    [downloadImageTask resume];
    
    //    });
    [_cache.allDownloadOperationCache setObject:@"xx" forKey:str_ImgURL];
}

//下載完成
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSString *url = downloadTask.originalRequest.URL.absoluteString;
    NSIndexPath *index = [self getIndexPathWithURL:url];
    UIImage *image = [UIImage imageWithData:data];
    [self.cache.allImageCache setObject:image forKey:url];
    [session invalidateAndCancel];
    //将下载操作从操作缓存池删除(下载操作已经完成)
    [self.cache.allDownloadOperationCache removeObjectForKey:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    });
}

-(NSIndexPath *)getIndexPathWithURL:(NSString *)url
{
    for (int i = 0; i < _arr_ImgURL.count; i++)
    {
        if ([[_arr_ImgURL objectAtIndex:i] isEqualToString:url])
        {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
            return index;
        }
    }
    
    return nil;
}

#pragma mark TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr_Result.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 270;
}
#pragma mark TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListCell *cell = (ListCell *)[_tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    DataModel *model = [_arr_Result objectAtIndex:indexPath.row];
//    Animal *model = [_arr_Result objectAtIndex:indexPath.row];
    NSString *animal_remark = model.animal_remark;
    NSString *animal_sex;
    NSInteger animal_kind;
    if ([model.animal_sex isEqualToString:@"F"])
    {
        animal_sex = @"女生";
    }
    else if ([model.animal_sex isEqualToString:@"M"])
    {
        animal_sex = @"男生";
    }
    else
    {
        animal_sex = @"不詳";
    }
    
    if ([model.animal_kind isEqualToString:@"狗"])
    {
        animal_kind = dog;
    }
    else if ([model.animal_kind isEqualToString:@"貓"])
    {
        animal_kind = cat;
    }
    else
    {
        animal_kind = other;
    }
    
    NSString *animal_age = model.animal_age;   //CHILD ADULT
    
    if ([model.animal_age isEqualToString:@"CHILD"] && animal_kind == dog)
    {
        animal_age = @"幼犬";
    }
    else if ([model.animal_age isEqualToString:@"ADULT"] && animal_kind == dog)
    {
        animal_age = @"成犬";
    }
    else if ([model.animal_age isEqualToString:@"CHILD"] && animal_kind == cat)
    {
        animal_age = @"幼貓";
    }
    else if ([model.animal_age isEqualToString:@"ADULT"] && animal_kind == cat)
    {
        animal_age = @"成貓";
    }
    else if ([model.animal_age isEqualToString:@"CHILD"] && animal_kind == other)
    {
        animal_age = @"CHILD";
    }
    else if ([model.animal_age isEqualToString:@"ADULT"] && animal_kind == other)
    {
        animal_age = @"ADULT";
    }
    else
    {
        animal_age = @"不詳";
    }
    
    NSString *str_SexAndAge = [NSString stringWithFormat:@"%@, %@",animal_sex,animal_age];
    cell.sexAndAgeLab.text = str_SexAndAge;
    cell.discriptionLab.text = animal_remark.length > 0? animal_remark : @"無描述資料";
    if (animal_kind == cat)
    {
        cell.kindImage.image = [UIImage imageNamed:@"cat"];
    }
    else
    {
        cell.kindImage.image = [UIImage imageNamed:@"dog"];
    }
    
    cell.IDLab.text = model.animal_id;
    cell.locationLab.text = model.animal_place.length > 0? model.animal_place : @"無描述資料";
    cell.openDateLab.text = model.animal_opendate.length > 0? model.animal_opendate : @"無描述資料";
    
    //判斷我的最愛內有沒有資料
    BOOL isExistInCoreData = model.is_favorite;
    if (isExistInCoreData)
    {
        [cell.img_Favorite setImage:[UIImage imageNamed:@"heart-2"]];
    }
    else
    {
        [cell.img_Favorite setImage:[UIImage imageNamed:@"heart-1"]];
    }
    
    [cell.btn_Like addTarget:self action:@selector(likeAct:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_Push.tag = indexPath.row;
    cell.btn_Like.tag = indexPath.row;
    [cell.btn_Push addTarget:self action:@selector(pushAct:) forControlEvents:UIControlEventTouchUpInside];
    //照片
    NSString *str_ImgURL = model.album_file;
    //如果cache image 有資料
    if ([_cache.allImageCache objectForKey:str_ImgURL])
    {
        cell.image.image = [_cache.allImageCache objectForKey:str_ImgURL];
    }
    //無資料就下載
    else
    {
        cell.image.image = [UIImage imageNamed:@"picture"];
        [self downloadImage:indexPath];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:[_arr_ImgURL count]-1 inSection:0];
    
    if (indexPath == lastRow)
    {
        //載入下一夜
        [self loadNextPage];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//進入detail 頁面
-(IBAction) pushAct:(id)sender
{
    UIImage *img = [_cache.allImageCache objectForKey:[_arr_ImgURL objectAtIndex:((UIButton *)sender).tag]];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailVC *detailVC = [storyBoard instantiateViewControllerWithIdentifier:@"DetailVC"];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.img = img;
    DataModel *model = [_arr_Result objectAtIndex:((UIButton *)sender).tag];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 加入最愛項目
//加入最愛項目
-(IBAction)likeAct:(id)sender
{
    DataModel *m = [_arr_Result objectAtIndex:((UIButton *)sender).tag];
    [CoreDataManager saveOrDelete:m];
    NSIndexPath *index = [NSIndexPath indexPathForRow:((UIButton *)sender).tag inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    });
}
@end
