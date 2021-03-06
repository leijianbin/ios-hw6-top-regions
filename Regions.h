//
//  Regions.h
//  TopRegions
//
//  Created by Jianbin Lei on 7/9/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographers, Photos;

@interface Regions : NSManagedObject

@property (nonatomic, retain) NSString * regionId;
@property (nonatomic, retain) NSString * regionLatitude;
@property (nonatomic, retain) NSString * regionLongitude;
@property (nonatomic, retain) NSString * regionName;
@property (nonatomic, retain) NSNumber * numberOfPhotographer;
@property (nonatomic, retain) NSSet *whoTakeHere;
@property (nonatomic, retain) NSSet *whatTakeHere;
@end

@interface Regions (CoreDataGeneratedAccessors)

- (void)addWhoTakeHereObject:(Photographers *)value;
- (void)removeWhoTakeHereObject:(Photographers *)value;
- (void)addWhoTakeHere:(NSSet *)values;
- (void)removeWhoTakeHere:(NSSet *)values;

- (void)addWhatTakeHereObject:(Photos *)value;
- (void)removeWhatTakeHereObject:(Photos *)value;
- (void)addWhatTakeHere:(NSSet *)values;
- (void)removeWhatTakeHere:(NSSet *)values;

@end
