//
//  CoreDataManager.m
//  GiveThemAHome
//
//  Created by Evan on 2016/7/22.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"
#import "Animal.h"

@implementation CoreDataManager
//取得託管本文
+ (NSManagedObjectContext *)getManagedObjectContextFromAppDelegate
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}

+ (void)save:(DataModel *)model
{
    //如果已存在就刪除
    if ([CoreDataManager checkExistByAnimal_id:model.animal_id])
    {
        NSManagedObjectContext *context = [CoreDataManager getManagedObjectContextFromAppDelegate];
        Animal *a = [CoreDataManager selectAnimalByAnimal_id:model.animal_id];
        [context deleteObject:a];
         NSError *error;
        if (![context save:&error])
        {
            NSLog(@"error");
        }
        return;
    }
    //沒存在就新增
    NSManagedObjectContext *context = [CoreDataManager getManagedObjectContextFromAppDelegate];
    //建立一個新的託管物件
    NSManagedObject *newDate = [NSEntityDescription insertNewObjectForEntityForName:@"Animal" inManagedObjectContext:context];
    
    [newDate setValue:model.album_base64.length > 0 ?model.album_base64:@"" forKey:@"album_base64"];
    [newDate setValue:model.album_file.length > 0 ?model.album_file:@"" forKey:@"album_file"];
    [newDate setValue:model.animal_age.length > 0 ?model.animal_age:@"" forKey:@"animal_age"];
    [newDate setValue:model.album_name.length > 0 ?model.album_name:@"" forKey:@"album_update"];
    [newDate setValue:model.album_name.length > 0 ?model.album_name:@"" forKey:@"album_name"];
    [newDate setValue:model.animal_area_pkid.length > 0 ?model.animal_area_pkid:@"" forKey:@"animal_area_pkid"];
    [newDate setValue:model.animal_bacterin.length > 0 ?model.animal_bacterin:@"" forKey:@"animal_bacterin"];
    [newDate setValue:model.animal_bodytype.length > 0 ?model.animal_bodytype:@"" forKey:@"animal_bodytype"];
    [newDate setValue:model.animal_caption.length > 0 ?model.animal_caption:@"" forKey:@"animal_caption"];
    [newDate setValue:model.animal_closeddate.length > 0 ?model.animal_closeddate:@"" forKey:@"animal_closeddate"];//10
    [newDate setValue:model.animal_colour.length > 0 ?model.animal_colour:@"" forKey:@"animal_colour"];
    [newDate setValue:model.animal_createtime.length > 0 ?model.animal_createtime:@"" forKey:@"animal_createtime"];
    [newDate setValue:model.animal_foundplace.length > 0 ?model.animal_foundplace:@"" forKey:@"animal_foundplace"];
    [newDate setValue:model.animal_id.length > 0 ?model.animal_id:@"" forKey:@"animal_id"];
    [newDate setValue:model.animal_kind.length > 0 ?model.animal_kind:@"" forKey:@"animal_kind"];
    [newDate setValue:model.animal_opendate.length > 0 ?model.animal_opendate:@"" forKey:@"animal_opendate"];
    [newDate setValue:model.animal_place.length > 0 ?model.animal_place:@"" forKey:@"animal_place"];
    [newDate setValue:model.animal_remark.length > 0 ?model.animal_remark:@"" forKey:@"animal_remark"];
    [newDate setValue:model.animal_sex.length > 0 ?model.animal_sex:@"" forKey:@"animal_sex"];
    [newDate setValue:model.animal_shelter_pkid.length > 0 ?model.animal_shelter_pkid:@"" forKey:@"animal_shelter_pkid"];//20
    [newDate setValue:model.animal_status.length > 0 ?model.animal_status:@"" forKey:@"animal_status"];
    [newDate setValue:model.animal_sterilization.length > 0 ?model.animal_sterilization:@"" forKey:@"animal_sterilization"];
    [newDate setValue:model.animal_subid.length > 0 ?model.animal_subid:@"" forKey:@"animal_subid"];
    [newDate setValue:model.animal_title.length > 0 ?model.animal_title:@"" forKey:@"animal_title"];
    [newDate setValue:model.animal_update.length > 0 ?model.animal_update:@"" forKey:@"animal_update"];
    [newDate setValue:model.cDate.length > 0 ?model.cDate:@"" forKey:@"cDate"];
    [newDate setValue:model.shelter_address.length > 0 ?model.shelter_address:@"" forKey:@"shelter_address"];
    [newDate setValue:model.shelter_name.length > 0 ?model.shelter_name:@"" forKey:@"shelter_name"];
    [newDate setValue:model.shelter_tel.length > 0 ?model.shelter_tel:@"" forKey:@"shelter_tel"];
    
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"error");
    }
}

+(NSMutableArray *)getAllResult
{
    NSMutableArray *results = [NSMutableArray new];
    NSManagedObjectContext *context = [CoreDataManager getManagedObjectContextFromAppDelegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Animal"];
    results = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if(results)
    {
//        NSLog(@"Entities with that name: %@", results);
//        for(DataModel *m in results)
//        {
//            NSLog(@"person = %@", m.album_file);
//        }
    }
    return results;
}

+(Animal *)selectAnimalByAnimal_id:(NSString *)animal_id
{
    NSManagedObjectContext *context = [CoreDataManager getManagedObjectContextFromAppDelegate];
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Animal"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"animal_id = %@", animal_id];
    [fetch setPredicate:predicate];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetch error:&error];
    if(results.count > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

+(BOOL)checkExistByAnimal_id:(NSString *)animal_id
{
    NSManagedObjectContext *context = [CoreDataManager getManagedObjectContextFromAppDelegate];
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Animal"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"animal_id = %@", animal_id];
    [fetch setPredicate:predicate];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetch error:&error];
    if(results.count > 0)
    {
        return YES;
//        NSLog(@"Entities with that name: %@", results);
//        for(Recipe *r in results) {
//            NSLog(@"person = %@", r.name);
//        }
    }
    else
    {
        return NO;
    }

}
@end
