//
//  FacebookTableViewCell.h
//  DTUAdda
//
//  Created by Ravin Kohli on 29/04/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookFeed.h"

@interface FacebookTableViewCell : UITableViewCell

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *dateLabel;
@property (nonatomic) UITextView *messageLabel;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSDictionary *sizeDictionary;
@property (nonatomic) UIView *view;
@property (nonatomic) NSInteger row;

-(void) configureCellForFeed:(FacebookFeed *)feed;
@end
