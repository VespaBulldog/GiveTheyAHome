//
//  CoreDataManager.h
//  GiveThemAHome
//
//  Created by Evan on 2016/7/22.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataModel.h"

@interface CoreDataManager : NSObject
+ (void)saveOrDelete:(DataModel *)model;
+ (NSMutableArray *)getAllResult;
+(BOOL)checkExistByAnimal_id:(NSString *)animal_id;
@end
