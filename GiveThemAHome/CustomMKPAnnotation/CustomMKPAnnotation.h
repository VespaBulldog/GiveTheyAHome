//
//  CustomMKPAnnotation.h
//  GiveThemAHome
//
//  Created by Evan on 2016/7/20.
//  Copyright © 2016年 Evan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomMKPAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}

@property (readonly, nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)coord;
@end
