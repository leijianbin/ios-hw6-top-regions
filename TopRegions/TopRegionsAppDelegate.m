//
//  TopRegionsAppDelegate.m
//  TopRegions
//
//  Created by Jianbin Lei on 6/25/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import "TopRegionsAppDelegate.h"
#import "FlickrFetcher.h"
#import "Photographers+Flickr.h"
#import "Photographers.h"
#import "Photos+Flickr.h"
#import "Photos.h"
#import "TopRegionDatabaseAvailabilty.h"


@interface TopRegionsAppDelegate() <NSURLSessionDataDelegate>

@property (strong,nonatomic) NSManagedObjectContext *topregionDatabaseContext;
@property (strong,nonatomic) UIManagedDocument *document;
@property (strong,nonatomic) NSArray *photos; //of Flickr Dictionary
@property (strong,nonatomic) NSString *placeName; 


@end


@implementation TopRegionsAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self createManagedObjectContext];
    [self startFetchPhoto];
    return YES;
}


- (void)startFetchPhoto
{
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    
    //muti-thread
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr photos fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResult = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                            options:0
                                                                              error:NULL];
        //NSLog(@"Flikr Photo Result = %@", propertyListResults);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
            self.photos = photos;
            //NSLog(@"%@",photos);
        });
    });
}

- (void)setPhotos:(NSArray *)photos
{
    //insert to the database;
    if (!_photos) {
        _photos = photos;
    }
    
    if (self.topregionDatabaseContext) {
        NSManagedObjectContext *context = self.topregionDatabaseContext;
        [context performBlock:^{
            [Photographers loadPhotographersWithFlickrArray:self.photos inManagedObjectContect:context];
            [Photos loadPhotosWithFlickrArray:self.photos inManagedObjectContect:context];
            [context save:NULL];
        }];
    }
}

- (void)createManagedObjectContext
{
    //create UIManagedDocument
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"topRegionsDatabase";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    //This creates the UIManagedDocument instance, but does not open nor create the underlying file.
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    if (fileExists) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            /* block to execute when open */
            if (success) [self documentIsReady];
            if (!success) NSLog(@"couldn’t open document at %@", url);
        }];
        //?
    } else
    {
        //if it does not, create the document using ...
        [self.document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success){
              /* block to execute when create is done */
              if (success) [self documentIsReady];
              if (!success) NSLog(@"couldn’t open document at %@", url);
          }];
    }
}

- (void)documentIsReady
{
    if (self.document.documentState == UIDocumentStateNormal) {
        // start using document
        self.topregionDatabaseContext = self.document.managedObjectContext;
        //continue to deal with the database...
    }
}

-(void)setTopregionDatabaseContext:(NSManagedObjectContext *)topregionDatabaseContext
{
    _topregionDatabaseContext = topregionDatabaseContext;
    //notification
    NSDictionary *userInfo = self.topregionDatabaseContext ? @{ TopRegionDatabaseAvailabiltyContext: self.topregionDatabaseContext } : nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:TopRegionDatabaseAvailabiltyNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
