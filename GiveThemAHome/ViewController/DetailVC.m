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
#import "ImageCache.h"
#import "CoreDataManager.h"

@interface DetailVC ()<NSURLSessionDelegate,MKMapViewDelegate>
{
    NSURLSessionConfiguration *defaultConfigObject;
    NSURLSession *defaultSession;
    MKPointAnnotation * point1;
}
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
@property (weak, nonatomic) IBOutlet UIImageView *btn_Favorite;
@property (nonatomic, strong) NSOperationQueue *imageQueue;
@property (nonatomic, strong) ImageCache *cache;

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self initUI];
    _mapView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    UINavigationItem *i = [UINavigationItem new];
//    i.title = @"xx";
////    [self.navigationController.navigationBar add]
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
    //如果進來時 img還沒抓到 就去download
    if (!_img)
    {
        [self downLoadImage];
        return;
    }
    
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

-(void)downLoadImage
{
    defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.timeoutIntervalForResource = 6;
    defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: _imageQueue];
    NSURL * url = [NSURL URLWithString:_model.album_file];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionDownloadTask * downloadImageTask = [defaultSession downloadTaskWithURL:url];
        [downloadImageTask resume];
    });
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSString *url = downloadTask.originalRequest.URL.absoluteString;
    
    UIImage *downLoadImage = [UIImage imageWithData:data];
    _cache = [ImageCache sharedImageCache];
    [_cache.allImageCache setObject:downLoadImage forKey:url];
    [session invalidateAndCancel];
    //将下载操作从操作缓存池删除(下载操作已经完成)
    [self.cache.allDownloadOperationCache removeObjectForKey:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        _img = downLoadImage;
        [self initImage];
    });
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
    //在此建立 shelter_address 的位置
    
    point1 = [[MKPointAnnotation alloc] init];
    NSString *oreillyAddress =_model.shelter_address;
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray*placemarks, NSError *error)
    {
        if ([placemarks count] > 0 && error == nil)
        {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            point1.coordinate = CLLocationCoordinate2DMake(firstPlacemark.location.coordinate.latitude, firstPlacemark.location.coordinate.longitude);
            //CLLocationCoordinate2D 的 struct “myLocation"，然後設定他的緯度 (latitude) 以及經度 (longitude) 作為地圖中心的經緯座標
            CLLocationCoordinate2D myLocation;
            myLocation.latitude = firstPlacemark.location.coordinate.latitude;
            myLocation.longitude = firstPlacemark.location.coordinate.longitude;
            //地圖可涵蓋的範圍有多大，這包括其中心點位置以及所展開的範圍
            MKCoordinateRegion myRegion;
            myRegion.center = myLocation;
            myRegion.span.latitudeDelta = 0.015;
            myRegion.span.longitudeDelta = 0.015;
            [_mapView setRegion:myRegion];
            
        }
        else if ([placemarks count] == 0 && error == nil)
        {
            NSLog(@"Found no placemarks.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
    point1.title = _model.shelter_address;
    
    //透過addAnnotation訊息，
    //實際將大頭針釘在地圖上，
    //以標出位置
    self.mapView.showsUserLocation = YES;
    self.mapView.scrollEnabled = NO;
    [self.mapView addAnnotation:point1];
    
//    NSArray *arr = [[NSArray alloc] initWithObjects:point1, nil];
//    [self.mapView setSelectedAnnotations:arr];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        pinView.canShowCallout = YES;
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [rightButton setImage:[UIImage imageNamed:@"icon_right_arrows"] forState:UIControlStateNormal];
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(15,15,15,15);
        rightButton.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:52.0/255.0f blue:93.0/255.0f alpha:1];
        [rightButton setTitle:@"" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(openMap:) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
        pinView.image = [UIImage imageNamed:@"location"];    //as suggested by Squatch
        pinView.annotation = annotation;
    }
    else
    {
//        [mapView.userLocation setTitle:@"I am here"];
    }
    
    return pinView;
}

//when pinView add then open bubbel
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    [self performSelector:@selector(selectInitialAnnotation) withObject:nil afterDelay:0.5];
}

//讓 大頭針被 selected
-(void)selectInitialAnnotation
{
    [self.mapView selectAnnotation:point1 animated:YES];
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
    _Lab_animal_sex.text = [NSString stringWithFormat:@"動物性別： %@",[TransData getAnimal_SexName:_model.animal_sex]];
    _Lab_animal_bodytype.text = [NSString stringWithFormat:@"動物體型： %@",[TransData getBodytypeName:_model.animal_bodytype]];
    _Lab_animal_colour.text = [NSString stringWithFormat:@"動物毛色： %@",_model.animal_colour.length > 0?_model.animal_colour:@"不詳"];
    _Lab_animal_age.text = [NSString stringWithFormat:@"動物體型： %@",[TransData getAnimal_ageName:_model.animal_age]];
    _Lab_animal_sterilization.text = [NSString stringWithFormat:@"是否節育： %@",[TransData getAnimal_sterilization:_model.animal_sterilization]];
    _Lab_animal_bacterin.text = [NSString stringWithFormat:@"是否施打狂犬病疫苗： %@",[TransData getAnimal_bacterin:_model.animal_bacterin]];
    _Lab_animal_opendate.text = [NSString stringWithFormat:@"開放認養時間： %@",_model.animal_opendate.length > 0?_model.animal_opendate:@"不詳"];
    _Lab_animal_remark.text = [NSString stringWithFormat:@"備註： %@",_model.animal_remark];
}
- (IBAction)openMap:(id)sender
{
    if (_model.shelter_address.length > 0)
    {
        NSString *addressString = [[NSString stringWithFormat:@"https://maps.apple.com/maps?q=%@",_model.shelter_address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:addressString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(IBAction)callPhone:(id)sender
{

    UIAlertView *alert;
    if (_model.shelter_tel.length > 0)
    {
        alert = [[UIAlertView alloc]initWithTitle: @"是否要撥打電話"
                                                       message: [NSString stringWithFormat:@"%@%@",@"tel:",_model.shelter_tel]
                                                      delegate: self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"確定",nil];
    }
    else
    {
        alert = [[UIAlertView alloc]initWithTitle: @"電話號碼不詳"
                                          message: @""
                                         delegate: self
                                cancelButtonTitle:@"取消"
                                otherButtonTitles:nil,nil];
    }
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"tel:",_model.shelter_tel]]];
    }
}

- (IBAction)like_Act:(id)sender
{
    [CoreDataManager saveOrDelete:_model];
//    _btn_Favorite.image = [UIImage imageNamed:@"heart-1"];
}

@end
