//
//  Photographers.h
//  TopRegions
//
//  Created by Jianbin Lei on 7/9/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Regions;

@interface Photographers : NSManagedObject

@property (nonatomic, retain) NSString * photographerId;
@property (nonatomic, retain) NSString * photographerName;
@property (nonatomic, retain) NSString * regionId;
@property (nonatomic, retain) Regions *locateTo;

@end
