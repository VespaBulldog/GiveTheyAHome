//
//  Cell.h
//  GiveThemAHome
//
//  Created by Evan on 2016/6/30.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *discriptionLab;
@property (weak, nonatomic) IBOutlet UILabel *sexAndAgeLab;
@property (weak, nonatomic) IBOutlet UIImageView *kindImage;
@property (weak, nonatomic) IBOutlet UILabel *IDLab;
@property (weak, nonatomic) IBOutlet UILabel *locationLab;
@property (weak, nonatomic) IBOutlet UILabel *openDateLab;
@property (weak, nonatomic) IBOutlet UIButton *btn_Like;
@property (weak, nonatomic) IBOutlet UIButton *btn_Push;
@property (weak, nonatomic) IBOutlet UIImageView *img_Favorite;

@end
