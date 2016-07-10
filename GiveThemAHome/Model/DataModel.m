//
//  ImageModel.m
//  GiveThemAHome
//
//  Created by Yan on 2016/7/8.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        //會自動把dic裡每個值塞到對應的property內
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (instancetype)modelDataWithDic:(NSDictionary *)dic
{
    return  [[self alloc]initWithDic:dic];
}

@end