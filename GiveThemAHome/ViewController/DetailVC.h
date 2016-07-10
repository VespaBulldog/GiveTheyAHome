//
//  DetailVC.h
//  GiveThemAHome
//
//  Created by Yan on 2016/7/10.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface DetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *img;
@property (strong, nonatomic) DataModel *model;
@end
