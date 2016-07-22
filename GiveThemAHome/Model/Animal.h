//
//  Animal.h
//  GiveThemAHome
//
//  Created by Evan on 2016/7/22.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//typedef NS_ENUM(NSInteger, AnimalKind)
//{
//    dog = 0,
//    cat = 1,
//    other = 2
//};
NS_ASSUME_NONNULL_BEGIN

@interface Animal : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

//- (instancetype)initWithDic:(NSDictionary *)dic;
//+ (instancetype)modelDataWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END

#import "Animal+CoreDataProperties.h"
