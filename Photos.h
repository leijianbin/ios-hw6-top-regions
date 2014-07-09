//
//  Photos.h
//  TopRegions
//
//  Created by Jianbin Lei on 7/9/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Regions;

@interface Photos : NSManagedObject

@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSString * photoThumbnailURL;
@property (nonatomic, retain) NSString * photoName;
@property (nonatomic, retain) NSString * regionId;
@property (nonatomic, retain) Regions *whereTook;

@end
