//
//  Regions+Create.h
//  TopRegions
//
//  Created by Jianbin Lei on 7/3/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import "Regions.h"

@interface Regions (Create)

+ (Regions *)regionsWithFlickrInfo:(NSDictionary *)placeInfo
            inManagedObjectContect:(NSManagedObjectContext *)context;

+ (Regions *)searchRegionsWithFlickrInfo:(NSDictionary *)placeInfo
                  inManagedObjectContect:(NSManagedObjectContext *)context;

+ (NSString *)fetchPlaceInfo:(NSString *)placeID;
@end
