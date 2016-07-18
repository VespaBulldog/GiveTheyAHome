//
//  TransData.m
//  GiveThemAHome
//
//  Created by Yan on 2016/7/10.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "TransData.h"

@implementation TransData
+(NSString *)getShelter_Name:(NSString *)shelter_NameID
{
    NSMutableDictionary *dic = [self getShelter_NameIDDic];
    NSString *str = [dic objectForKey:shelter_NameID];
    return str;
}

+(NSMutableDictionary *)getShelter_NameIDDic
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"基隆市政府動物保護防疫所寵物銀行" forKey:@"48"];
    [dic setObject:@"臺北市動物之家" forKey:@"49"];
    [dic setObject:@"新北市板橋動物之家" forKey:@"50"];
    [dic setObject:@"新北市新店動物之家" forKey:@"51"];
    [dic setObject:@"新北市新莊動物之家" forKey:@"52"];
    [dic setObject:@"新北市中和動物之家" forKey:@"53"];
    [dic setObject:@"新北市三峽動物之家" forKey:@"54"];
    [dic setObject:@"新北市淡水動物之家" forKey:@"55"];
    [dic setObject:@"新北市瑞芳動物之家" forKey:@"56"];
    [dic setObject:@"新北市五股動物之家" forKey:@"58"];//10
    [dic setObject:@"新北市八里動物之家" forKey:@"59"];
    [dic setObject:@"新北市三芝動物之家" forKey:@"60"];
    [dic setObject:@"桃園市動物保護教育園區" forKey:@"61"];
    [dic setObject:@"新竹市動物收容所" forKey:@"62"];
    [dic setObject:@"新竹縣動物收容所" forKey:@"63"];
    [dic setObject:@"苗栗縣北區動物收容中心(竹南鎮公所)" forKey:@"64"];
    [dic setObject:@"苗栗縣苗中區動物收容中心(苗栗市公所)" forKey:@"65"];
    [dic setObject:@"苗栗縣南區動物收容中心(苑裡鎮公所)" forKey:@"66"];
    [dic setObject:@"臺中市南屯園區動物之家" forKey:@"67"];
    [dic setObject:@"臺中市后里園區動物之家" forKey:@"68"];//20
    [dic setObject:@"彰化縣流浪狗中途之家" forKey:@"69"];
    [dic setObject:@"南投縣公立動物收容所" forKey:@"70"];
    [dic setObject:@"嘉義市流浪犬收容中心" forKey:@"71"];
    [dic setObject:@"嘉義縣流浪犬中途之家" forKey:@"72"];
    [dic setObject:@"臺南市灣裡站動物之家" forKey:@"73"];
    [dic setObject:@"臺南市善化站動物之家" forKey:@"74"];
    [dic setObject:@"高雄市壽山站動物保護教育園區" forKey:@"75"];
    [dic setObject:@"高雄市燕巢站動物保護教育園區" forKey:@"76"];
    [dic setObject:@"屏東縣流浪動物收容所" forKey:@"77"];
    [dic setObject:@"宜蘭縣流浪動物中途之家" forKey:@"78"];//30
    [dic setObject:@"花蓮縣流浪犬中途之家" forKey:@"79"];
    [dic setObject:@"臺東縣流浪動物收容中心" forKey:@"80"];
    [dic setObject:@"連江縣流浪犬收容中心" forKey:@"81"];
    [dic setObject:@"金門縣動物收容中心" forKey:@"82"];
    [dic setObject:@"澎湖縣流浪動物收容中心" forKey:@"83"];
    [dic setObject:@"雲林縣動植物防疫所" forKey:@"89"];
    [dic setObject:@"臺中市愛心小站" forKey:@"90"];
    [dic setObject:@"臺中市中途動物醫院" forKey:@"91"];
    [dic setObject:@"新北市政府動物保護防疫處" forKey:@"92"];
    [dic setObject:@"新北市金山動物之家" forKey:@"94"];//40
    
    return dic;
    
}

+(NSArray *)getAnimal_Area_Arr
{
    NSArray * array = [[NSArray alloc] initWithObjects:
                       @"不限",@"臺北市",@"新北市",@"基隆市",@"宜蘭縣",@"桃園縣",@"新竹縣",@"新竹市",
                       @"苗栗縣",@"臺中市",@"彰化縣",@"南投縣",@"雲林縣",@"嘉義縣",@"嘉義市",@"臺南市",
                       @"高雄市",@"屏東縣",@"花蓮縣",@"臺東縣",@"澎湖縣",@"金門縣",@"連江縣", nil];
    
    return array;
}

+(NSMutableDictionary *)getAnimal_Area_Dic
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"不限" forKey:@"0"];
    [dic setObject:@"臺北市" forKey:@"2"];
    [dic setObject:@"新北市" forKey:@"3"];
    [dic setObject:@"基隆市" forKey:@"4"];
    [dic setObject:@"宜蘭縣" forKey:@"5"];
    [dic setObject:@"桃園縣" forKey:@"6"];
    [dic setObject:@"新竹縣" forKey:@"7"];
    [dic setObject:@"新竹市" forKey:@"8"];
    [dic setObject:@"苗栗縣" forKey:@"9"];
    [dic setObject:@"臺中市" forKey:@"10"];//10
    [dic setObject:@"彰化縣" forKey:@"11"];
    [dic setObject:@"南投縣" forKey:@"12"];
    [dic setObject:@"雲林縣" forKey:@"13"];
    [dic setObject:@"嘉義縣" forKey:@"14"];
    [dic setObject:@"嘉義市" forKey:@"15"];
    [dic setObject:@"臺南市" forKey:@"16"];
    [dic setObject:@"高雄市" forKey:@"17"];
    [dic setObject:@"屏東縣" forKey:@"18"];
    [dic setObject:@"花蓮縣" forKey:@"19"];
    [dic setObject:@"臺東縣" forKey:@"20"];//20
    [dic setObject:@"澎湖縣" forKey:@"21"];
    [dic setObject:@"金門縣" forKey:@"22"];
    [dic setObject:@"連江縣" forKey:@"23"];
    
    return dic;
}

//得到地區的中文名稱
+(NSString *)getAnimal_Area:(NSString *)Animal_Area_PkID
{
    NSMutableDictionary *dic = [self getAnimal_Area_Dic];
    NSString *str = [dic objectForKey:Animal_Area_PkID];
    return str;
}

//得到地區的Key
+(NSString *)getAnimal_Area_DicKeyWithArea:(NSString *)area
{
    NSMutableDictionary *dic = [self getAnimal_Area_Dic];
    NSArray *temp = [dic allKeysForObject:area];
    NSString *key = [temp objectAtIndex:0];
    
    return key;
}

+(NSString *)getAnimal_Sex:(NSString *)animal_Sex
{
    
    NSString *str ;
    if ([animal_Sex isEqualToString:@"F"])
    {
        str = @"母";
    }
    else
    {
        str = @"公";
    }
    return str;
}

+(NSString *)getBodytype:(NSString *)animal_bodytype
{
    
    NSString *str ;
    if ([animal_bodytype isEqualToString:@"MINI"])
    {
        str = @"迷你型";
    }
    else if ([animal_bodytype isEqualToString:@"SMALL"])
    {
        str = @"小型";
    }
    else if ([animal_bodytype isEqualToString:@"MEDIUM"])
    {
        str = @"中型";
    }
    else if ([animal_bodytype isEqualToString:@"BIG"])
    {
        str = @"中型";
    }
    else
    {
        str = @"不詳";
    }
    return str;
}

+(NSString *)getAnimal_age:(NSString *)animal_age
{
    
    NSString *str ;
    if ([animal_age isEqualToString:@"CHILD"])
    {
        str = @"幼年";
    }
    else if ([animal_age isEqualToString:@"ADULT"])
    {
        str = @"成年";
    }
    else
    {
        str = @"不詳";
    }
    return str;
}

+(NSString *)getAnimal_sterilization:(NSString *)animal_sterilization
{
    
    NSString *str ;
    if ([animal_sterilization isEqualToString:@"T"])
    {
        str = @"已節育";
    }
    else if ([animal_sterilization isEqualToString:@"F"])
    {
        str = @"未節育";
    }
    else
    {
        str = @"不詳";
    }
    return str;
}

+(NSString *)getAnimal_bacterin:(NSString *)animal_bacterin
{
    
    NSString *str ;
    if ([animal_bacterin isEqualToString:@"T"])
    {
        str = @"已施打";
    }
    else if ([animal_bacterin isEqualToString:@"F"])
    {
        str = @"未施打";
    }
    else
    {
        str = @"不詳";
    }
    return str;
}
@end
