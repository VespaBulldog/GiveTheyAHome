//
//  ImageModel.h
//  GiveThemAHome
//
//  Created by Yan on 2016/7/8.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, AnimalKind)
{
    dog = 0,
    cat = 1,
    other = 2
};
@interface DataModel : NSObject
@property (nonatomic, copy) NSString *album_base64;
@property (nonatomic, copy) NSString *album_file;
@property (nonatomic, copy) NSString *animal_age;
@property (nonatomic, copy) NSString *album_update;
@property (nonatomic, copy) NSString *album_name;
@property (nonatomic, copy) NSString *animal_area_pkid;
@property (nonatomic, copy) NSString *animal_bacterin;
@property (nonatomic, copy) NSString *animal_bodytype;
@property (nonatomic, copy) NSString *animal_caption;
@property (nonatomic, copy) NSString *animal_closeddate; //10
@property (nonatomic, copy) NSString *animal_colour;
@property (nonatomic, copy) NSString *animal_createtime;
@property (nonatomic, copy) NSString *animal_foundplace;
@property (nonatomic, copy) NSString *animal_id;
@property (nonatomic, copy) NSString *animal_kind;
@property (nonatomic, copy) NSString *animal_opendate;
@property (nonatomic, copy) NSString *animal_place;
@property (nonatomic, copy) NSString *animal_remark;
@property (nonatomic, copy) NSString *animal_sex;
@property (nonatomic, copy) NSString *animal_shelter_pkid; //20
@property (nonatomic, copy) NSString *animal_status;
@property (nonatomic, copy) NSString *animal_sterilization;
@property (nonatomic, copy) NSString *animal_subid;
@property (nonatomic, copy) NSString *animal_title;
@property (nonatomic, copy) NSString *animal_update;
@property (nonatomic, copy) NSString *cDate;
@property (nonatomic, copy) NSString *shelter_address;
@property (nonatomic, copy) NSString *shelter_name;
@property (nonatomic, copy) NSString *shelter_tel;  //29
@property (nonatomic, assign) BOOL is_favorite;
- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)modelDataWithDic:(NSDictionary *)dic;
@end
