//
//  SearchViewController.m
//  GiveThemAHome
//
//  Created by Yan on 2016/7/9.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "SearchViewController.h"
#import "TitleView.h"

@interface SearchViewController ()<UIPickerViewDelegate>
{
    int labelNumber;
    NSArray *arr_PickerView;
}
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;
@property (weak, nonatomic) IBOutlet UILabel *lab6;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargine;
@property (weak, nonatomic) IBOutlet UILabel *pickViewTitle;
@property (weak, nonatomic) IBOutlet UIView *darkView;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initPickView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView
{
    [self initTitleView];
}

-(void)initPickView
{
    labelNumber = 0;
    _darkView.hidden = YES;
    _bottomMargine.constant = -400;
    _pickView.delegate = self;
//    _darkView.hidden = YES;
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
- (IBAction)btn1Act:(id)sender
{
    labelNumber = 0;
    _pickViewTitle.text = @"縣市區域";
    arr_PickerView = [[NSArray alloc] initWithObjects:@"不限",@"臺北市",@"新北市",@"基隆市",@"宜蘭縣",@"桃園縣",@"新竹縣",@"新竹市",@"苗栗縣",@"臺中市",@"彰化縣",@"南投縣",@"雲林縣",@"嘉義縣",@"嘉義市",@"臺南市",@"高雄市",@"屏東縣",@"花蓮縣",@"臺東縣",@"澎湖縣",@"金門縣",@"連江縣", nil];
    [self.pickView reloadAllComponents];
    [self doAnimation];
    
}
- (IBAction)btn2Act:(id)sender
{
    labelNumber = 1;
    _pickViewTitle.text = @"類型";
    arr_PickerView = [[NSArray alloc] initWithObjects:@"不限",@"狗",@"貓", nil];
    [self.pickView reloadAllComponents];
    [self doAnimation];
}
- (IBAction)btn3Act:(id)sender
{
    labelNumber = 2;
    _pickViewTitle.text = @"體型";
    arr_PickerView = [[NSArray alloc] initWithObjects:@"不限",@"迷你",@"小型",@"中型",@"大型", nil];
    [self.pickView reloadAllComponents];
    [self doAnimation];
}
- (IBAction)btn4Act:(id)sender
{
    labelNumber = 3;
    _pickViewTitle.text = @"年齡";
    arr_PickerView = [[NSArray alloc] initWithObjects:@"不限",@"幼年",@"成年", nil];
    [self.pickView reloadAllComponents];
    [self doAnimation];
}
- (IBAction)btn5Act:(id)sender
{
    labelNumber = 4;
    _pickViewTitle.text = @"性別";
    arr_PickerView = [[NSArray alloc] initWithObjects:@"不限",@"白",@"黒",@"棕",@"黃",@"虎斑", nil];
    [self.pickView reloadAllComponents];
    [self doAnimation];
}
- (IBAction)btn6Act:(id)sender
{
    labelNumber = 5;
    _pickViewTitle.text = @"縣市區域";
    arr_PickerView = [[NSArray alloc] initWithObjects:@"不限",@"公",@"母", nil];
    [self.pickView reloadAllComponents];
    [self doAnimation];
}

- (IBAction)btnConfirmAction:(id)sender
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         _darkView.alpha = 0;
                         _bottomMargine.constant = -400;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         _darkView.hidden = YES;
                     }];
}

-(void)doAnimation
{
    _darkView.hidden = NO;
    [UIView animateWithDuration:1.0
                     animations:^{
                         _darkView.alpha = 0.5;
                         _bottomMargine.constant = 0;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         
                     }];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (labelNumber)
    {
        case 0:
        {
            _lab1.text = [arr_PickerView objectAtIndex:row];
        }
            break;
        case 1:
        {
            _lab2.text = [arr_PickerView objectAtIndex:row];
        }
            break;
        case 2:
        {
            _lab3.text = [arr_PickerView objectAtIndex:row];
        }
            break;
        case 3:
        {
            _lab4.text = [arr_PickerView objectAtIndex:row];
        }
            break;
        case 4:
        {
            _lab5.text = [arr_PickerView objectAtIndex:row];
        }
            break;
        case 5:
        {
            _lab6.text = [arr_PickerView objectAtIndex:row];
        }
            break;
        default:
            break;
    }
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Helvetica" size:17]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines=1;
    }
    // Fill the label text here
    tView.text=[arr_PickerView objectAtIndex:row];
    return tView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 36;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [arr_PickerView objectAtIndex:row];
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return arr_PickerView.count;
}


@end
