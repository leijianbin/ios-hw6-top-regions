//
//  RecentGeoreferencedPhotosTVC.m
//  TopRegions
//
//  Created by Jianbin Lei on 6/25/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import "RecentGeoreferencedPhotosTVC.h"
#import "FlickrFetcher.h"

@interface RecentGeoreferencedPhotosTVC ()

@end

@implementation RecentGeoreferencedPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self fetchPhotos];
    [self fetchPlaceInfo:@"QWjzgjtTV7MWdsxqUg"];
}


- (void)fetchPlaceInfo:(NSString *)placeID;
{
    NSURL *url = [FlickrFetcher URLforInformationAboutPlace:placeID];
    
    //muti-thread
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr place info fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResult = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                            options:0
                                                                              error:NULL];
        NSLog(@"Flikr Place information Result = %@", propertyListResults);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
            //self.photos = photos;
        });
    });
}

- (void)fetchPhotos
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
        });
    });
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end