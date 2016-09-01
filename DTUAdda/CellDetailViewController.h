//
//  CellDetailViewController.h
//  DTU Guide
//
//  Created by Ravin Kohli on 15/06/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookFeed.h"
@interface CellDetailViewController : UIViewController

@property (nonatomic) FacebookFeed *feed;
//@property (nonatomic) NSDictionary *size;

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *dateLabel;
@property (nonatomic) UITextView *messageLabel;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSDictionary *sizeDictionary;
@property (nonatomic) UIView *cardView;
@property (nonatomic) NSInteger row;

@end
