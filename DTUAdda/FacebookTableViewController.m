//
//  FacebookTableViewController.m
//  DTUAdda
//
//  Created by Ravin Kohli on 29/04/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import "FacebookTableViewController.h"
#import "FacebookFeed.h"
#import "FacebookTableViewCell.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "MapsViewController.h"
#import "CellDetailViewController.h"

@interface FacebookTableViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation FacebookTableViewController

@synthesize refreshControl = _refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    internetReachable = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [internetReachable currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        self.internetActive = NO;
    } else {
        NSLog(@"There IS internet connection");
        self.internetActive = YES;
    }
    
    self.sizeArray = [[NSMutableArray alloc] init];
    self.tableView.allowsSelection = NO;
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.title = @"DCE Speaks Up";
    self.navigationController.navigationBar.backgroundColor = [UIColor brownColor];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.feedArray = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = YES;
    

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    self.indicator.center = self.view.center;
    [self.view addSubview:self.indicator];
    NSLog(@"%d",self.internetActive);
    [self.indicator bringSubviewToFront:self.view];
    [self.indicator startAnimating];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.internetActive) {
        [self createView];
        [self.tableView reloadData];
        [self.indicator stopAnimating];
    }else{
        [self.indicator stopAnimating];
//        MapsViewController *viewController = [MapsViewController new];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Internet Connection" message:@"GO TO SETTINGS" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[self.tabBarController presentViewController:[MapsViewController new] animated:YES completion:^{NSLog(@"completed transition");}];}];
        UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];}];
        
        [alert addAction:defaultAction];
        [alert addAction:settingsAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
-(void) createView{
    
    
    if (self.internetActive) {
        NSError *error= nil;
        
        self.feedURL = [NSURL URLWithString:@"https://graph.facebook.com/382057938566656/feed?fields=id,full_picture,message,story,created_time,link&access_token=1750413825187852%7CkUl9nlZFPvdGxGZX4WYabKKG2G4"];
        
        NSData *jsonData = [NSData dataWithContentsOfURL:self.feedURL];
        
        NSDictionary *dataDictionary= [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        NSArray *feedTempArray = [dataDictionary objectForKey:@"data"];        //feedTempArray just used for parsing
        for (NSDictionary *feedDictionary in feedTempArray) {
            FacebookFeed *fbFeed =[FacebookFeed facebookFeedWithMessage:[feedDictionary objectForKey:@"message"]];
            fbFeed.story = [feedDictionary objectForKey:@"story"];
            fbFeed.imageURL = [NSURL URLWithString:[feedDictionary objectForKey:@"full_picture"]];
            fbFeed.date = [feedDictionary objectForKey:@"created_time"];
            fbFeed.sharedLink = [NSURL URLWithString:[feedDictionary objectForKey:@"link"]];
            [self.feedArray addObject:fbFeed];
        }
    }else{
        FacebookFeed *fbFeed = [FacebookFeed facebookFeedWithMessage:@"No Internet Available"];
        fbFeed.imageURL = nil;
        fbFeed.date = nil;
        fbFeed.sharedLink = nil;
        [self.feedArray addObject:fbFeed];
    }
    
    [self refreshTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTable {
    //TODO: refresh your data
    self.feedURL = [NSURL URLWithString:@"https://graph.facebook.com/382057938566656/feed?fields=id,full_picture,message,story,created_time,link&access_token=1750413825187852%7CkUl9nlZFPvdGxGZX4WYabKKG2G4"];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedArray.count;
}
- (NSDictionary *) sizeForLabelAtIndexPath:(NSUInteger)indexPath tableView:(UITableView *)tableView andFeed:(FacebookFeed *)feed{
    float height1 = 30;
    NSString *string1 = @"DCE Speaks Up";
    if (string1) {
        NSDictionary *attributes = @{
                                     NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
                                     };
        CGRect bodyFrame =
        [string1 boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.bounds),
                                                CGFLOAT_MAX)
                             options:(NSStringDrawingUsesLineFragmentOrigin)
                          attributes:attributes
                             context:nil];
        
        height1 += ceilf(CGRectGetHeight(bodyFrame));
    }
    
    CGSize imageSize = CGSizeMake(0, 0);
    if (feed.imageURL) {
        imageSize = CGSizeMake(self.view.frame.size.width, 394);
    }
    float height = 80;
    NSString *string = @"";
    if (feed.message) {
        string = [feed.message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }else if (feed.story){
        string = [feed.story stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (string) {
        NSDictionary *attributes = @{
                                     NSFontAttributeName : [UIFont fontWithName:@"Droid Sans" size:15]
                                     };
        CGRect bodyFrame =
        [string boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.bounds),
                                                CGFLOAT_MAX)
                             options:(NSStringDrawingUsesLineFragmentOrigin)
                          attributes:attributes
                             context:nil];
        
        height += ceilf(CGRectGetHeight(bodyFrame));
    }
    return @{ @"imageHeight" : @(imageSize.height) , @"messageHeight" : @(height) , @"nameHeight" : @(height1) , @"indexPath": @(indexPath)};
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FacebookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...

    [cell configureCellForFeed:self.feedArray[indexPath.row]];
   
    cell.sizeDictionary = [self sizeForLabelAtIndexPath:indexPath.row tableView:tableView andFeed:self.feedArray[indexPath.row]];
    cell.row = indexPath.row;
    cell.clipsToBounds = YES;
    for (id object in cell.contentView.subviews) {
        [object removeFromSuperview];
    }
    cell.layer.shouldRasterize = YES;           //quickens up the cell load in uicollection view - do check it out later
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
   
    
    return cell;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *size = [[NSDictionary alloc] init];
    size = [self sizeForLabelAtIndexPath:indexPath.row tableView:tableView andFeed:self.feedArray[indexPath.row]];
    
    
    CGFloat sizes = ([size[@"messageHeight"] floatValue] + [size[@"nameHeight"] floatValue] + [size[@"imageHeight"] floatValue]);
    sizes *= 1.05;
    

    if (sizes>327) {
        return 327;
    }
    return sizes;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected");
    [self refreshTable];
    NSDictionary *size = [[NSDictionary alloc] init];
    size = [self sizeForLabelAtIndexPath:indexPath.row tableView:tableView andFeed:self.feedArray[indexPath.row]];
    
    
    CGFloat sizes = ([size[@"messageHeight"] floatValue] + [size[@"nameHeight"] floatValue] + [size[@"imageHeight"] floatValue]);
    sizes *= 1.05;
    self.cdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FacebookDetail"];
    self.cdvc.sizeDictionary = [self sizeForLabelAtIndexPath:indexPath.row tableView:tableView andFeed:self.feedArray[indexPath.row]];
    self.cdvc.feed = self.feedArray[indexPath.row];
    [self.navigationController pushViewController:self.cdvc animated:YES];
    
}

//
//-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"showCellDetail"]) {
//        NSIndexPath *indexPath =[self.tableView indexPathForSelectedRow];
//        NSDictionary *size = [self sizeForLabelAtIndexPath:indexPath.row tableView:self.tableView andFeed:self.feedArray[indexPath.row]];
//        
//        
//            CGFloat sizes = ([size[@"messageHeight"] floatValue] + [size[@"nameHeight"] floatValue] + [size[@"imageHeight"] floatValue]);
//            sizes *= 1.05;
//        
//        
//            if (sizes>327) {
//                self.cdvc.sizeDictionary = size;
//        CellDetailViewController *cdvc = (CellDetailViewController *)segue.destinationViewController;
//        cdvc.feed = self.feedArray[indexPath.row];
//        cdvc.sizeDictionary = [self sizeForLabelAtIndexPath:indexPath.row tableView:self.tableView andFeed:self.feedArray[indexPath.row]];
//
//            }else{
//                [self refreshTable];
//            }
//    
//    }
//}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
