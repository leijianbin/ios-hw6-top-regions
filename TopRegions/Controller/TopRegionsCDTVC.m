//
//  TopRegionsCDTVC.m
//  TopRegions
//
//  Created by Jianbin Lei on 7/9/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import "TopRegionsCDTVC.h"
#import "TopRegionDatabaseAvailabilty.h"
#import "Regions.h"
#import "Regions+Create.h"

@interface TopRegionsCDTVC ()

@end

@implementation TopRegionsCDTVC

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
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Regions"];
    request.predicate = nil;
    
    NSSortDescriptor *sortNumber = [[NSSortDescriptor alloc] initWithKey:@"numberOfPhotographer"
                                                               ascending:NO];
    NSSortDescriptor *sortName = [[NSSortDescriptor alloc] initWithKey:@"regionName"
                                                             ascending:YES
                                                              selector:@selector(localizedStandardCompare:)];
    
    request.sortDescriptors = @[sortNumber, sortName];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Top Region Cell"];
    
    Regions *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", region.regionName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of Photographer is %@", region.numberOfPhotographer];
    return cell;
}


@end
