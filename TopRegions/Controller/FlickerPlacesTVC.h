//
//  FlickerPlacesTVC.h
//  TopPlace
//
//  Created by Jianbin Lei on 5/31/14.
//  Copyright (c) 2014 ou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface FlickerPlacesTVC : CoreDataTableViewController

@property (nonatomic,strong) NSArray *topPlaces; // of the Flikr Top Places Dictionary
@property (nonatomic,strong,readonly) NSArray *countries;// of the Flikr Countries
@property (nonatomic,strong,readonly) NSDictionary *placesByCountry; //

- (NSDictionary *)placeForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
