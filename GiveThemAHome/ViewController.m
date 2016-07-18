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

@interface ViewController ()<NSURLSessionDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int currentPage;
    NSURLSessionConfiguration *defaultConfigObject;
    NSURLSession *defaultSession;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arr_ImgURL;
@property (nonatomic, strong) NSMutableArray *arr_Result;
@property (nonatomic, strong) NSOperationQueue *imageQueue;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *acView;
@property (nonatomic, strong) ImageCache *cache;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initProperty];
    [self initView];
    [self addACView];
    [self getResultData];
    
    //註冊通知中心 當按下搜尋要重新撈資料
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchAction:)
                                                 name:@"searchAction"
                                               object:nil];
}

//重新撈資料
- (void) searchAction:(NSNotification*) notification
{
    NSDictionary* userInfo = notification.userInfo;
    [self addACView];
    _tableView.hidden = YES;
    [self initProperty];
    [_cache.allDownloadOperationCache removeAllObjects];
    [_cache.allImageCache removeAllObjects];
    [self getResultData];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)initProperty
{
    currentPage = 0;
    _arr_ImgURL = [[NSMutableArray alloc] init];
    _imageQueue = [[NSOperationQueue alloc] init];
    _imageQueue.maxConcurrentOperationCount = 3;
    _arr_Result = [[NSMutableArray alloc] init];
    _cache = [ImageCache sharedImageCache];
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
    UIImageView *ac = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,16,16)];
    
    ac.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"ac-1"],[UIImage imageNamed:@"ac-2"],[UIImage imageNamed:@"ac-3"],nil];
    ac.animationDuration = 1.0; // in seconds
    ac.animationRepeatCount = 0; // sets to loop
    [ac startAnimating];
    ac.center = view.center;
    [ac startAnimating];
    [view addSubview:ac]; // <-- Your UIActivityIndicatorView
    
    return view;
}

-(void)addACView
{
    _acView.hidden = NO;
    _acView.layer.cornerRadius = 10;
    [_acView startAnimating];
}

#pragma mark 抓取資料
-(void)getResultData
{
    NSString *urlString = [NSString stringWithFormat:
     @"http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx?$top=3&$skip=%i&$filter=animal_area_pkid+like+%i"
     ,currentPage,0];
//    NSString *urlString = [NSString stringWithFormat:
//                           @"http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx?$top=3&$skip=%i&$filter=animal_area_pkid+like+%i+and+animal_kind+like+狗+and+animal_colour+like+虎斑"
//                           ,currentPage,0];

//    NSString *urlString = @"http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx?$top=10&$skip=0&$filter=animal_colour+like+%E8%99%8E%E6%96%91+and+animal_kind+like+%E7%8B%97+and+animal_area_pkid+like+2";
    
    
//    "http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx?$top=1000&$skip=0&$filter=animal_colour+like+虎斑+and+animal_kind+like+狗+and+animal_area_pkid+like+2"
//    NSString *urlString = [NSString stringWithFormat:@"http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx?$top=3&$skip=%i&$filter=animal_area_pkid+like+%i",currentPage,0];
    //    NSString *urlString = @"http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx?$top=1000";
    NSURL * url = [NSURL URLWithString:urlString];
    
    defaultConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
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
//    [_arr_Result addObjectsFromArray:arrTemp];
    for (int i = 0; i < arrTemp.count ; i++)
    {
        NSDictionary * dic = [arrTemp objectAtIndex:i];
        DataModel *m = [DataModel modelDataWithDic:dic];
        [_arr_Result addObject:m];
        [_arr_ImgURL addObject:m.album_file];
    }
    
    [_tableView reloadData];
}

//載入下一夜
-(void)loadNextPage
{
    currentPage = currentPage +3;
    [self getResultData];
}

#pragma mark Like
//加入最愛項目
-(void)likeAct
{
    NSLog(@"Like");
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
    [cell.btn_Like addTarget:self action:@selector(likeAct) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_Push.tag = indexPath.row;
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

//進入detail 頁面
-(IBAction) pushAct:(id)sender
{
    UIImage *img = [_cache.allImageCache objectForKey:[_arr_ImgURL objectAtIndex:((UIButton *)sender).tag]];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailVC *detailVC = [storyBoard instantiateViewControllerWithIdentifier:@"DetailVC"];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.img = img;
    detailVC.model = [_arr_Result objectAtIndex:((UIButton *)sender).tag];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
