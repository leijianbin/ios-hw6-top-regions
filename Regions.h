//
//  Regions.h
//  TopRegions
//
//  Created by Jianbin Lei on 7/3/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographers;

@interface Regions : NSManagedObject

@property (nonatomic, retain) NSString * regionId;
@property (nonatomic, retain) NSNumber * regionLatitude;
@property (nonatomic, retain) NSNumber * regionLongitude;
@property (nonatomic, retain) NSString * regionName;
@property (nonatomic, retain) NSSet *whoTakeHere;
@end

@interface Regions (CoreDataGeneratedAccessors)

- (void)addWhoTakeHereObject:(Photographers *)value;
- (void)removeWhoTakeHereObject:(Photographers *)value;
- (void)addWhoTakeHere:(NSSet *)values;
- (void)removeWhoTakeHere:(NSSet *)values;

@end
