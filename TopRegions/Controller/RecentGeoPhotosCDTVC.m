//
//  RecentGeoPhotosCDTVC.m
//  TopRegions
//
//  Created by Jianbin Lei on 7/4/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import "RecentGeoPhotosCDTVC.h"
#import "TopRegionDatabaseAvailabilty.h"
#import "Photos.h"
#import "Photos+Flickr.h"
#import "Regions.h"

@interface RecentGeoPhotosCDTVC ()

@end

@implementation RecentGeoPhotosCDTVC


- (void)awakeFromNib
{
    self.regionId = @"OvdT5fNTVrIncC2N"; //test
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:TopRegionDatabaseAvailabiltyNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = note.userInfo[TopRegionDatabaseAvailabiltyContext];
                                                  }];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photos"];
    request.predicate = [NSPredicate predicateWithFormat:@"regionId = %@",self.regionId];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"photoName"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Photos Cell"];
    
    Photos *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Name is %@", photo.photoName];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", photo.whereTook.regionName];
    
    return cell;
}

#pragma mark - Navigation
//???

@end
