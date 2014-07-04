//
//  Regions+Create.m
//  TopRegions
//
//  Created by Jianbin Lei on 7/3/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import "Regions+Create.h"

@implementation Regions (Create)

+ (Regions *)regionsWithFlickrInfo:(NSDictionary *)placeInfo
                        inManagedObjectContect:(NSManagedObjectContext *)context
{
    Regions *regions = nil;

    NSString *placeUnique = placeInfo[@"place_id"];
    NSString *placeLatitude = placeInfo[@"latitude"];
    NSString *placeLongitude = placeInfo[@"longitude"];

    
    //database query
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Regions"];
    request.predicate = [NSPredicate predicateWithFormat:@"regionId = %@",placeUnique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    //
    if (!matches || error || [matches count] > 1) {
        //error
        //handle exception
    } else if([matches count])
    {
        regions = [matches firstObject];
    } else
    {
        regions = [NSEntityDescription insertNewObjectForEntityForName:@"Regions" inManagedObjectContext: context];
        regions.regionId = placeUnique;
        regions.regionLatitude = placeLatitude;
        regions.regionLongitude = placeLongitude;
        
#warning - need get the place name with the place_id;
        regions.regionName = @"Unkonw";
    }
    
    return regions;
}


@end
