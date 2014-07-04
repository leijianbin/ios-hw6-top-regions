//
//  Photographers+Flickr.h
//  TopRegions
//
//  Created by Jianbin Lei on 7/3/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import "Photographers.h"

@interface Photographers (Flickr)

+ (Photographers *)photographersWithFlickrInfo:(NSDictionary *)photoDictionary
                        inManagedObjectContect:(NSManagedObjectContext *)context;


+ (void)loadPhotographersWithFlickrArray:(NSArray *)photos // of Flickr NSDirctionary
                        inManagedObjectContect:(NSManagedObjectContext *)context;

@end
