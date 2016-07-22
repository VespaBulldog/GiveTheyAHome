//
//  Animal+CoreDataProperties.h
//  GiveThemAHome
//
//  Created by Evan on 2016/7/22.
//  Copyright © 2016年 Evan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Animal.h"

NS_ASSUME_NONNULL_BEGIN

@interface Animal (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *album_base64;
@property (nullable, nonatomic, retain) NSString *album_file;
@property (nullable, nonatomic, retain) NSString *animal_age;
@property (nullable, nonatomic, retain) NSString *album_update;
@property (nullable, nonatomic, retain) NSString *album_name;
@property (nullable, nonatomic, retain) NSString *animal_area_pkid;
@property (nullable, nonatomic, retain) NSString *animal_bacterin;
@property (nullable, nonatomic, retain) NSString *animal_bodytype;
@property (nullable, nonatomic, retain) NSString *animal_caption;
@property (nullable, nonatomic, retain) NSString *animal_closeddate;
@property (nullable, nonatomic, retain) NSString *animal_colour;
@property (nullable, nonatomic, retain) NSString *animal_createtime;
@property (nullable, nonatomic, retain) NSString *animal_place;
@property (nullable, nonatomic, retain) NSString *animal_remark;
@property (nullable, nonatomic, retain) NSString *animal_foundplace;
@property (nullable, nonatomic, retain) NSString *animal_id;
@property (nullable, nonatomic, retain) NSString *animal_kind;
@property (nullable, nonatomic, retain) NSString *animal_opendate;
@property (nullable, nonatomic, retain) NSString *animal_sex;
@property (nullable, nonatomic, retain) NSString *animal_shelter_pkid;
@property (nullable, nonatomic, retain) NSString *animal_status;
@property (nullable, nonatomic, retain) NSString *animal_sterilization;
@property (nullable, nonatomic, retain) NSString *animal_subid;
@property (nullable, nonatomic, retain) NSString *animal_title;
@property (nullable, nonatomic, retain) NSString *animal_update;
@property (nullable, nonatomic, retain) NSString *cDate;
@property (nullable, nonatomic, retain) NSString *shelter_address;
@property (nullable, nonatomic, retain) NSString *shelter_name;
@property (nullable, nonatomic, retain) NSString *shelter_tel;

@end

NS_ASSUME_NONNULL_END
