//
//  SearchViewController.m
//  GiveThemAHome
//
//  Created by Yan on 2016/7/9.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "SearchViewController.h"
#import "TitleView.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    [_tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    _tableView.estimatedRowHeight = 270.f;
    _tableView.backgroundColor = [UIColor colorWithRed:183.0/255.0f green:178.0/255.0f blue:178.0/255.0f alpha:1];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
}

#pragma mark TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 30;
    }
    return 30;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
//    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
//    v.backgroundView.backgroundColor = [UIColor darkGrayColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"區域";
            break;
        case 1:
            sectionName = NSLocalizedString(@"myOtherSectionName", @"myOtherSectionName");
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
#pragma mark TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}
@end
