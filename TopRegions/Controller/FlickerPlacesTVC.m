//
//  FlickerPlacesTVC.m
//  TopPlace
//
//  Created by Jianbin Lei on 5/31/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import "FlickerPlacesTVC.h"
#import "FlickrFetcher.h"

@interface FlickerPlacesTVC ()

@end

@implementation FlickerPlacesTVC

- (void)setTopPlaces:(NSArray *)topPlaces
{
    _topPlaces = topPlaces;
    
    //countries, dictionary of the country
    
    NSMutableArray *countries = [[NSMutableArray alloc] init];
    NSMutableDictionary *placesByCountry = [[NSMutableDictionary alloc] init];
    
    //
    
    for (NSDictionary *placeX in topPlaces) {
        NSMutableDictionary *place = [placeX mutableCopy];
        NSArray *locationParts = [[place valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@","];
        NSString *country = locationParts[locationParts.count-1];
        NSString *middlePart = @"";
        if (locationParts.count == 3) {
            middlePart = locationParts[1];
        }
        place[@"title"] = locationParts[0];
        place[@"subtitle"] = middlePart;
        NSMutableArray *placesInCountry = [placesByCountry objectForKey:country];
        if (placesInCountry == nil) {
            [countries addObject:country];
            placesInCountry = [[NSMutableArray alloc] init];
        }
        [placesInCountry addObject:place];
        placesByCountry[country] = placesInCountry;
    }
    
    _countries = [countries sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    //sort places within countries
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"title"  ascending:YES];
    for (NSString *country in countries) {
        //placesByCountry[country] = [ sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray *places = placesByCountry[country];
        placesByCountry[country] = [places sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
        //recent = [stories copy];
    }
    _placesByCountry = placesByCountry;
    
    
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (NSDictionary *)placeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *country = self.countries[indexPath.section];
    NSArray *placesInCountry = self.placesByCountry[country];
    NSDictionary *place = placesInCountry[indexPath.row];
    return place;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.countries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *country = self.countries[section];
    NSArray *placesInCountry = self.placesByCountry[country];
    return placesInCountry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Top Place Cell"; //
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *place = [self placeForRowAtIndexPath:indexPath];
    
    cell.textLabel.text = [place valueForKeyPath:@"title"];
    cell.detailTextLabel.text = [place valueForKeyPath:@"subtitle"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.countries[section];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
