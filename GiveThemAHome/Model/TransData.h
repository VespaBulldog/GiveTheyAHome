//
//  TransData.h
//  GiveThemAHome
//
//  Created by Yan on 2016/7/10.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransData : NSObject
+(NSString *)getAnimal_Area:(NSString *)Animal_Area_PkID;
+(NSString *)getAnimal_Sex:(NSString *)animal_Sex;
+(NSString *)getBodytype:(NSString *)animal_bodytype;
+(NSString *)getAnimal_age:(NSString *)animal_age;
+(NSString *)getAnimal_sterilization:(NSString *)animal_sterilization;
+(NSString *)getAnimal_bacterin:(NSString *)animal_bacterin;
+(NSString *)getAnimal_Area_DicKeyWithArea:(NSString *)area;
+(NSArray *)getAnimal_Area_Arr;
@end
