//
//  Photos+Flickr.h
//  TopRegions
//
//  Created by Jianbin Lei on 7/9/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import "Photos.h"

@interface Photos (Flickr)

+ (Photos *)photosWithFlickrInfo:(NSDictionary *)photoDictionary
                        inManagedObjectContect:(NSManagedObjectContext *)context;


+ (void)loadPhotosWithFlickrArray:(NSArray *)photos // of Flickr NSDirctionary
                  inManagedObjectContect:(NSManagedObjectContext *)context;


@end
