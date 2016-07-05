//
//  ViewController.m
//  GiveThemAHome
//
//  Created by Evan on 2016/7/4.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "ViewController.h"
#import "TitleView.h"

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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initProperty];
    [self initView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initProperty
{
    currentPage = 0;
    _arr_ImgURL = [[NSMutableArray alloc] init];
    _imageQueue = [[NSOperationQueue alloc] init];
    _imageQueue.maxConcurrentOperationCount = 3;
    _arr_Result = [[NSMutableArray alloc] init];
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
    [_tableView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    _tableView.estimatedRowHeight = 270.f;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    //把 UIActivityIndicatorView 加到 tableFooterView
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 36)];
    UIImageView *ac = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,16,16)];
    
    ac.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"add-1.png"],[UIImage imageNamed:@"add-2.png"],nil];
    ac.animationDuration = 1.0; // in seconds
    ac.animationRepeatCount = 0; // sets to loop
    [ac startAnimating];
    ac.center = view.center;
    [ac startAnimating];
    [view addSubview:ac]; // <-- Your UIActivityIndicatorView
    self.tableView.tableFooterView = view;

}

//抓取資料
-(void)getResultData
{
    NSString *urlString = [NSString stringWithFormat:@"http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx?$top=3&$skip=%i",currentPage];
    //    NSString *urlString = @"http://data.coa.gov.tw/Service/OpenData/AnimalOpenData.aspx?$top=1000";
    NSURL * url = [NSURL URLWithString:urlString];
    
    defaultConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            [self saveResultData:data];
                                                            _tableView.hidden = NO;
                                                        }
                                                    }];
    
    [dataTask resume];
}

-(void)saveResultData:(NSData *)data
{

}
@end
