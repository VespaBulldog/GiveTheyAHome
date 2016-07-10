//
//  DetailVC.m
//  GiveThemAHome
//
//  Created by Yan on 2016/7/10.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "DetailVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLGeocoder.h> 
#import "TransData.h"
#import "TitleView.h"

@interface DetailVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *str_ID;
@property (weak, nonatomic) IBOutlet UILabel *str_Shelter_Name;
@property (weak, nonatomic) IBOutlet UILabel *str_Shelter_Address;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Tel;
@property (weak, nonatomic) IBOutlet UILabel *Lab_Animal_Area;
@property (weak, nonatomic) IBOutlet UILabel *Lab_animal_foundplace;
@property (weak, nonatomic) IBOutlet UILabel *Lab_animal_place;
@property (weak, nonatomic) IBOutlet UILabel *Lab_animal_kind;
@property (weak, nonatomic) IBOutlet UILabel *Lab_animal_sex;
@property (weak, nonatomic) IBOutlet UILabel *Lab_animal_bodytype;
@property (weak, nonatomic) IBOutlet UILabel *Lab_animal_colour;
@property (weak, nonatomic) IBOutlet UILabel *Lab_animal_age;
@property (weak, nonatomic) IBOutlet UILabel *Lab_animal_sterilization;
@property (weak, nonatomic) IBOutlet UILabel *Lab_animal_bacterin;
@property (weak, nonatomic) IBOutlet UILabel *Lab_animal_opendate;
@property (weak, nonatomic) IBOutlet UILabel *Lab_animal_remark;

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI
{
    [self initTitleView];
    [self initImage];
    [self initMapView];
    [self initLabel];
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

-(void)initImage
{
    _imageView.image = _img;
    CGSize mainSize = [[UIScreen mainScreen] bounds].size;
    CGRect frame = [self getFrameSizeForImage:_img inImageView:_imageView];
    CGFloat width;
    if (frame.size.width > mainSize.width)
    {
        width = mainSize.width - 60;
    }
    else
    {
        width = frame.size.width;
    }
    _imgWidth.constant = width;
    _imgHeight.constant = frame.size.height;
    _imageView.layer.borderWidth = 8;
    _imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
}

//計算image的大小 去調整邊界
- (CGRect)getFrameSizeForImage:(UIImage *)image inImageView:(UIImageView *)imageView {
    
    float hfactor = image.size.width / imageView.frame.size.width;
    float vfactor = image.size.height / imageView.frame.size.height;
    
    float factor = fmax(hfactor, vfactor);
    
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    float newWidth = image.size.width / factor;
    float newHeight = image.size.height / factor;
    
    // Then figure out if you need to offset it to center vertically or horizontally
    float leftOffset = (imageView.frame.size.width - newWidth) / 2;
    float topOffset = (imageView.frame.size.height - newHeight) / 2;
    
    return CGRectMake(leftOffset, topOffset, newWidth, newHeight);
}

-(void)initMapView
{
    //建立MKPointAnnotation物件
    //設定title，以設定選取後顯示的字樣
    //設定coordinate，指出所在的經緯度
    //在此建立台北的位置
    MKPointAnnotation * point1;
    point1 = [[MKPointAnnotation alloc] init];
    NSString *oreillyAddress =@"臺南市善化區東昌里東勢寮1之19號";
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray*placemarks, NSError *error) {
        
        if ([placemarks count] > 0 && error == nil){
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            point1.coordinate = CLLocationCoordinate2DMake(firstPlacemark.location.coordinate.latitude, firstPlacemark.location.coordinate.longitude);
        }
        else if ([placemarks count] == 0 &&
                 error == nil){
            NSLog(@"Found no placemarks.");
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
    point1.title = @"臺南市善化區東昌里東勢寮1之19號";
    
    //透過addAnnotation訊息，
    //實際將大頭針釘在地圖上，
    //以標出位置
    self.mapView.showsUserLocation = YES;
    [self.mapView addAnnotation:point1];
//    MKCoordinateRegion theRegion = self.mapView.region;
//    
//    // 放大
//    theRegion.span.longitudeDelta *= 2.0;
//    theRegion.span.latitudeDelta *= 2.0;
//    [self.mapView setRegion:theRegion animated:YES];
//    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    
}

-(void)initLabel
{
    _str_ID.text = [NSString stringWithFormat:@"動物編號： %@",_model.animal_id];
    _str_Shelter_Name.text = [NSString stringWithFormat:@"收容所名稱： %@",_model.shelter_name];
    _str_Shelter_Address.text = [NSString stringWithFormat:@"收容所地址： %@",_model.shelter_address.length > 0?_model.shelter_address:@"不詳"];
    _Lab_Tel.text = [NSString stringWithFormat:@"收容所電話： %@",_model.shelter_tel.length > 0?_model.shelter_tel:@"不詳"];
    _Lab_Animal_Area.text = [NSString stringWithFormat:@"動物所屬縣市： %@",[TransData getAnimal_Area:_model.animal_area_pkid].length > 0?[TransData getAnimal_Area:_model.animal_area_pkid]:@"不詳"];
    _Lab_animal_foundplace.text = [NSString stringWithFormat:@"動物尋獲地： %@",_model.animal_foundplace.length > 0?_model.animal_foundplace:@"不詳"];
    _Lab_animal_place.text = [NSString stringWithFormat:@"動物實際所在地： %@",_model.animal_place.length > 0?_model.animal_place:@"不詳"];
    _Lab_animal_kind.text = [NSString stringWithFormat:@"動物種類： %@",_model.animal_kind.length > 0?_model.animal_kind:@"不詳"];
    _Lab_animal_sex.text = [NSString stringWithFormat:@"動物性別： %@",[TransData getAnimal_Sex:_model.animal_sex]];
    _Lab_animal_bodytype.text = [NSString stringWithFormat:@"動物體型： %@",[TransData getBodytype:_model.animal_bodytype]];
    _Lab_animal_colour.text = [NSString stringWithFormat:@"動物毛色： %@",_model.animal_colour.length > 0?_model.animal_colour:@"不詳"];
    _Lab_animal_age.text = [NSString stringWithFormat:@"動物體型： %@",[TransData getAnimal_age:_model.animal_age]];
    _Lab_animal_sterilization.text = [NSString stringWithFormat:@"是否節育： %@",[TransData getAnimal_sterilization:_model.animal_sterilization]];
    _Lab_animal_bacterin.text = [NSString stringWithFormat:@"是否施打狂犬病疫苗： %@",[TransData getAnimal_bacterin:_model.animal_bacterin]];
    _Lab_animal_opendate.text = [NSString stringWithFormat:@"開放認養時間： %@",_model.animal_opendate.length > 0?_model.animal_opendate:@"不詳"];
    _Lab_animal_remark.text = [NSString stringWithFormat:@"備註： %@",_model.animal_remark];
}

@end
