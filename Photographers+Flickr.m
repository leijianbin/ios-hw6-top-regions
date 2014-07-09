//
//  Photographers+Flickr.m
//  TopRegions
//
//  Created by Jianbin Lei on 7/3/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import "Photographers+Flickr.h"
#import "FlickrFetcher.h"
#import "Regions+Create.h"

@implementation Photographers (Flickr)

#define OWNER @"owner"
#define OWNER_NAME @"ownername"
#define PLACE_ID @"place_id"

+ (Photographers *)photographersWithFlickrInfo:(NSDictionary *)photoDictionary
                        inManagedObjectContect:(NSManagedObjectContext *)context
{
    Photographers *photographers = nil;
    
    NSString *ownerUnique = photoDictionary[OWNER];
    NSString *placeUnique = photoDictionary[PLACE_ID];
    
    //database query
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographers"];
    request.predicate = [NSPredicate predicateWithFormat:@"(regionId = %@) AND (photographerId = %@)",placeUnique, ownerUnique];
    
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    //
    if (!matches || error || [matches count] > 1) {
        //error
        //handle exception
    } else if([matches count])
    {
        photographers = [matches firstObject];
//        photographers.locateTo.numberOfPhotographer = @([photographers.locateTo.numberOfPhotographer integerValue] + 1);
//        if (![context save:&error]) {
//            NSLog(@"Whoops");
//        }
    } else
    {
        photographers = [NSEntityDescription insertNewObjectForEntityForName:@"Photographers" inManagedObjectContext: context];
        photographers.photographerId = ownerUnique;
        photographers.regionId = placeUnique;
        photographers.photographerName = photoDictionary[OWNER_NAME];
        photographers.locateTo = [Regions regionsWithFlickrInfo:photoDictionary
                                         inManagedObjectContect:context];
    }

    return photographers;
}


+ (void)loadPhotographersWithFlickrArray:(NSArray *)photos // of Flickr NSDirctionary
                             inManagedObjectContect:(NSManagedObjectContext *)context
{
    for (NSDictionary *photo in photos) {
        [self photographersWithFlickrInfo:photo inManagedObjectContect:context];
        NSLog(@"photo is %@",photo);
    }
}

@end
