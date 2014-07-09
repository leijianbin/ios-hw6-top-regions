//
//  Regions+Create.m
//  TopRegions
//
//  Created by Jianbin Lei on 7/3/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import "Regions+Create.h"
#import "FlickrFetcher.h"

@implementation Regions (Create)


+ (NSString *)fetchPlaceInfo:(NSString *)placeID;
{
    NSURL *url = [FlickrFetcher URLforInformationAboutPlace:placeID];
    //muti-thread
    //dispatch_queue_t fetchQ = dispatch_queue_create("flickr place info fetcher", NULL);

    NSData *jsonResult = [NSData dataWithContentsOfURL:url];
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                            options:0
                                                                              error:NULL];
    NSLog(@"Flikr Place information Result = %@", propertyListResults);
    //NSString *placeName = [propertyListResults valueForKeyPath:@"place.name"];
    //placeName = [[placeName componentsSeparatedByString:@","] firstObject];
    
    NSString *placeName = [FlickrFetcher extractRegionNameFromPlaceInformation:propertyListResults];
    return placeName;
}

+ (Regions *)searchRegionsWithFlickrInfo:(NSDictionary *)placeInfo
            inManagedObjectContect:(NSManagedObjectContext *)context
{
    Regions *regions = nil;
    
    NSString *placeUnique = placeInfo[@"place_id"];
    NSString *placeLatitude;
    NSString *placeLongitude;
    
    if ([placeInfo[@"latitude"] isKindOfClass:[NSNumber class]]) {
        placeLatitude = [placeInfo[@"latitude"] stringValue];
    } else {
        placeLatitude = placeInfo[@"latitude"];
    }
    
    if ([placeInfo[@"longitude"] isKindOfClass:[NSNumber class]]) {
        placeLongitude = [placeInfo[@"longitude"] stringValue];
    } else {
        placeLongitude = placeInfo[@"longitude"];
    }
    
    NSString *regionName = [self fetchPlaceInfo:placeUnique];
    
    
    //database query
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Regions"];
    request.predicate = [NSPredicate predicateWithFormat:@"regionName = %@",regionName];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    //
    if (!matches || error || [matches count] > 1) {
        //error
        //handle exception
    } else if([matches count])
    {
        regions = [matches firstObject]; //
    } else
    {
        regions = [NSEntityDescription insertNewObjectForEntityForName:@"Regions" inManagedObjectContext: context];
        regions.regionId = placeUnique;
        regions.regionLatitude = placeLatitude;
        regions.regionLongitude = placeLongitude;
        regions.regionName = regionName;
        regions.numberOfPhotographer = @1;
    }
    return regions;
}


+ (Regions *)regionsWithFlickrInfo:(NSDictionary *)placeInfo
                        inManagedObjectContect:(NSManagedObjectContext *)context
{
    Regions *regions = nil;

    NSString *placeUnique = placeInfo[@"place_id"];
    NSString *placeLatitude;
    NSString *placeLongitude;
    
    if ([placeInfo[@"latitude"] isKindOfClass:[NSNumber class]]) {
        placeLatitude = [placeInfo[@"latitude"] stringValue];
    } else {
        placeLatitude = placeInfo[@"latitude"];
    }
    
    if ([placeInfo[@"longitude"] isKindOfClass:[NSNumber class]]) {
        placeLongitude = [placeInfo[@"longitude"] stringValue];
    } else {
        placeLongitude = placeInfo[@"longitude"];
    }

    NSString *regionName = [self fetchPlaceInfo:placeUnique];

    
    //database query
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Regions"];
    request.predicate = [NSPredicate predicateWithFormat:@"regionName = %@",regionName];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    //
    if (!matches || error || [matches count] > 1) {
        //error
        //handle exception
    } else if([matches count])
    {
        regions = [matches firstObject];
        regions.numberOfPhotographer = @([regions.numberOfPhotographer integerValue]+ 1);
        if (![context save:&error]) {
            NSLog(@"Whoops");
        }
    } else
    {
        regions = [NSEntityDescription insertNewObjectForEntityForName:@"Regions" inManagedObjectContext: context];
        regions.regionId = placeUnique;
        regions.regionLatitude = placeLatitude;
        regions.regionLongitude = placeLongitude;
        regions.regionName = regionName;
        regions.numberOfPhotographer = @1;
    }    
    return regions;
}


@end
