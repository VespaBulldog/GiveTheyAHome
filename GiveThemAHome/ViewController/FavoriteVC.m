//
//  FavoriteVC.m
//  GiveThemAHome
//
//  Created by Evan on 2016/7/26.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "FavoriteVC.h"
#import "TitleView.h"
#import "CoreDataManager.h"
#import "ListCell.h"
#import "DetailVC.h"
#import "Animal.h"

@interface FavoriteVC ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate>
{
    NSURLSessionConfiguration *defaultConfigObject;
    NSURLSession *defaultSession;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSOperationQueue *favoriteImageQueue;
//存取core data 撈到的資料
@property (nonatomic, strong) NSMutableArray *arr_Favorite;
//存取core data 轉換成DataModel的資料
@property (nonatomic, strong) NSMutableArray *arr_Result;
@property (nonatomic, strong) NSMutableArray *arr_ImgURL;
@property (nonatomic, strong) NSMutableDictionary *dic_Image;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@end

@implementation FavoriteVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initProperty];
    [self initTitleView];
    [self initTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getFavorite];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initProperty
{
    _dic_Image = [NSMutableDictionary new];
    _favoriteImageQueue.maxConcurrentOperationCount = 3;
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
    [_tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];
    [self.tableView setSeparatorColor:[UIColor whiteColor]];
    _tableView.estimatedRowHeight = 270.f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
}

//取得最愛浪浪清單
-(void)getFavorite
{
    _arr_Favorite = [[NSMutableArray alloc] init];
    _arr_Result = [[NSMutableArray alloc] init];
    _arr_ImgURL = [NSMutableArray new];
    
    _arr_Favorite = [CoreDataManager getAllResult];
    if (_arr_Favorite.count > 0)
    {
        [self showEmptyView:NO];
    }
    else
    {
        [self showEmptyView:YES];
    }
    for (int j = (int)_arr_Favorite.count -1; j >= 0; j--)
    {
        Animal *animal = [_arr_Favorite objectAtIndex:j];
        //取到core data的 參數
        NSMutableArray *animalKeys = [NSMutableArray arrayWithObjects:
                           @"album_base64",@"album_file",@"animal_age",@"album_update",@"album_name",
                           @"animal_area_pkid",@"animal_bacterin",@"animal_bodytype",@"animal_caption",@"animal_closeddate",
                           @"animal_colour",@"animal_createtime",@"animal_foundplace",@"animal_id",@"animal_shelter_pkid",
                           @"animal_opendate",@"animal_place",@"animal_remark",@"animal_sex",@"album_name",
                           @"animal_status",@"animal_sterilization",@"animal_subid",@"animal_title",@"animal_update",
                           @"cDate",@"shelter_address",@"shelter_name",@"shelter_tel"
                           , nil];
        NSDictionary *animalValues =[animal dictionaryWithValuesForKeys:animalKeys];
        NSMutableDictionary *dataModelValues = [[NSMutableDictionary alloc] initWithDictionary:animalValues];
        [dataModelValues setValue:@(1) forKey:@"is_favorite"];
        DataModel * m= [[DataModel alloc] initWithDic:dataModelValues];
        [_arr_Result addObject:m];
        m.album_file = animal.album_file;
        [_arr_ImgURL addObject:m.album_file];
    }
    
    [self.tableView reloadData];
}
-(void)showEmptyView:(BOOL)bShowEmptyView
{
    if (bShowEmptyView)
    {
        _emptyView.hidden = NO;
        _tableView.hidden = YES;
    }
    else
    {
        _emptyView.hidden = YES;
        _tableView.hidden = NO;
    }
}



#pragma mark 下載照片
- (void)downloadImage:(NSString *)str_ImgURL
{
    defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.timeoutIntervalForResource = 6;
    defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: _favoriteImageQueue];
    
    NSURL * url = [NSURL URLWithString:str_ImgURL];
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSURLSessionDownloadTask * downloadImageTask = [defaultSession downloadTaskWithURL:url];
    [downloadImageTask resume];
    
    //    });
}

//下載完成
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSString *url = downloadTask.originalRequest.URL.absoluteString;
    NSIndexPath *index = [self getIndexPathWithURL:url];
    UIImage *image = [UIImage imageWithData:data];
    [_dic_Image setValue:image forKey:url];
    [session invalidateAndCancel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    });
}

//取得第幾筆資料的index
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
    
    [cell.img_Favorite setImage:[UIImage imageNamed:@"heart-2"]];
    
    [cell.btn_Like addTarget:self action:@selector(likeAct:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_Push.tag = indexPath.row;
    cell.btn_Like.tag = indexPath.row;
    [cell.btn_Push addTarget:self action:@selector(pushAct:) forControlEvents:UIControlEventTouchUpInside];
    //照片
    NSString *str_ImgURL = model.album_file;
    
    if ([_dic_Image objectForKey:str_ImgURL])
    {
        cell.image.image = [_dic_Image objectForKey:str_ImgURL];
    }
    else
    {
        cell.image.image = [UIImage imageNamed:@"picture"];
        [self downloadImage:str_ImgURL];
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
}

//進入detail 頁面
-(IBAction) pushAct:(id)sender
{
    NSString *url = ((DataModel *)[_arr_Result objectAtIndex:((UIButton *)sender).tag]).album_file;
    UIImage *img = [_dic_Image objectForKey:url];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailVC *detailVC = [storyBoard instantiateViewControllerWithIdentifier:@"DetailVC"];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.img = img;
    DataModel *model = [_arr_Result objectAtIndex:((UIButton *)sender).tag];
    
    model.is_favorite = YES;
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 加入最愛項目
//加入最愛項目
-(IBAction)likeAct:(id)sender
{
    DataModel *m = [_arr_Result objectAtIndex:((UIButton *)sender).tag];
    [CoreDataManager saveOrDelete:m];
    [_arr_Result removeObjectAtIndex:((UIButton *)sender).tag];
    if (_arr_Result.count > 0)
    {
        [self.tableView reloadData];
    }
    else
    {
        [self showEmptyView:YES];
    }
    
}
@end
