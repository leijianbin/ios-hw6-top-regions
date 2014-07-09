//
//  Photos+Flickr.m
//  TopRegions
//
//  Created by Jianbin Lei on 7/9/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import "Photos+Flickr.h"
#import "FlickrFetcher.h"
#import "Regions.h"
#import "Regions+Create.h"

@implementation Photos (Flickr)

#define TITLE @"title"
#define OWNER_NAME @"ownername"
#define PLACE_ID @"place_id"

+ (Photos *)photosWithFlickrInfo:(NSDictionary *)photoDictionary
                        inManagedObjectContect:(NSManagedObjectContext *)context
{
    Photos *photos = nil;
    
    NSString *title = photoDictionary[TITLE];
    NSString *regionId = photoDictionary[PLACE_ID];
    NSURL *url = [FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatOriginal];
    NSString *photoURL = [url absoluteString];
    
    //database query
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photos"];
    request.predicate = [NSPredicate predicateWithFormat:@"photoURL = %@",photoURL];
    
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    //
    if (!matches || error || [matches count] > 1) {
        //error
        //handle exception
    } else if([matches count])
    {
        photos = [matches firstObject];
    } else
    {
        photos = [NSEntityDescription insertNewObjectForEntityForName:@"Photos" inManagedObjectContext: context];
        photos.photoName = title;
        photos.regionId = regionId;
        photos.photoURL = photoURL;
        photos.photoThumbnailURL = @"unknow"; //
        photos.whereTook = [Regions searchRegionsWithFlickrInfo:photoDictionary
                                         inManagedObjectContect:context];
    }
    return photos;
}


+ (void)loadPhotosWithFlickrArray:(NSArray *)photos // of Flickr NSDirctionary
                  inManagedObjectContect:(NSManagedObjectContext *)context
{
    for (NSDictionary *photo in photos) {
        [self photosWithFlickrInfo:photo inManagedObjectContect:context];
        NSLog(@"photo is %@",photo);
    }
}


@end
