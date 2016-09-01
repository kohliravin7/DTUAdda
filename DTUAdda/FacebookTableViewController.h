//
//  FacebookTableViewController.h
//  DTUAdda
//
//  Created by Ravin Kohli on 29/04/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDetailViewController.h"


@class Reachability;

Reachability* internetReachable;

@interface FacebookTableViewController : UITableViewController

@property (nonatomic) NSMutableArray *feedArray;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSURL *feedURL;
@property (nonatomic) UIActivityIndicatorView *indicator;
@property (nonatomic) BOOL internetActive;
@property (nonatomic) NSMutableArray *sizeArray;
@property (nonatomic) CellDetailViewController *cdvc;
@end
