//
//  RecentGeoPhotosCDTVC.m
//  TopRegions
//
//  Created by Jianbin Lei on 7/4/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import "RecentGeoPhotosCDTVC.h"
#import "TopRegionDatabaseAvailabilty.h"
#import "Photographers.h"
#import "Photographers+Flickr.h"

@interface RecentGeoPhotosCDTVC ()

@end

@implementation RecentGeoPhotosCDTVC

- (void)awakeFromNib
{
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
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographers"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"photographerName"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Photographer Cell"];
    
    Photographers *photographer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Name is %@, Id is %@", photographer.photographerName, photographer.photographerId];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"Region Id is %@", photographer.regionId];
    
    return cell;
}

#pragma mark - Navigation
//???

@end
