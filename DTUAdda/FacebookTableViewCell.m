//
//  FacebookTableViewself.m
//  DTUAdda
//
//  Created by Ravin Kohli on 29/04/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import "FacebookTableViewCell.h"

@class FacebookFeed;

@implementation FacebookTableViewCell

@synthesize imageView  = _imageView;


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSString *)differenceStringFromDate:(NSString *)dateString{
    //2010-12-01T21:35:43+0000
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //2010-12-01T21:35:43+0000
    dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"+" withString:@" +"];
    //NSLog(@"%@", dateString);
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss +zzzz"];
    //NSLog(@"%@",df.dateFormat);
    NSDate *date = [df dateFromString:dateString];
   
    //NSLog(@"%@ date",date);
    NSDate *now = [NSDate date];
    //NSLog(@"%@ NOW",now);
    double time = [date timeIntervalSinceDate:now];
    time *= -1;
    if (time < 60) {
        int diff = round(time);
        if (diff == 1)
            return @"1 second ago";
        return [NSString stringWithFormat:@"%d seconds ago", diff];
    } else if (time < 3600) {
        int diff = round(time / 60);
        if (diff == 1)
            return @"1 minute ago";
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (time < 86400) {
        int diff = round(time / 60 / 60);
        if (diff == 1)
            return @"1 hour ago";
        return [NSString stringWithFormat:@"%d hours ago", diff];
    } else if (time < 604800) {
        int diff = round(time / 60 / 60 / 24);
        if (diff == 1)
            return @"yesterday";
        if (diff == 7)
            return @"a week ago";
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
        int diff = round(time / 60 / 60 / 24 / 7);
        if (diff == 1)
            return @"a week ago";
        return [NSString stringWithFormat:@"%d weeks ago", diff];
    }
}

-(void) configureCellForFeed:(FacebookFeed *)feed{
    self.sizeDictionary = [[NSDictionary alloc] init];
    self.messageLabel = [[UITextView alloc] init];
    self.imageView = [[UIImageView alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"DCE Speaks Up";
    self.nameLabel.textColor = [UIColor colorWithRed:0.235 green:0.353 blue:0.588 alpha:1.00];
    
    self.contentView.userInteractionEnabled = YES;
    self.messageLabel.userInteractionEnabled = NO;
    self.dateLabel.userInteractionEnabled = NO;
    self.imageView.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;


    self.dateLabel = [[UILabel alloc] init];
    if(feed.message){
        self.messageLabel.text = feed.message;
    }else if (feed.story){
        self.messageLabel.text = feed.story;
    }
    self.messageLabel.font = [UIFont fontWithName:@"Droid Sans" size:15];
    self.messageLabel.editable = NO;
    self.messageLabel.dataDetectorTypes = UIDataDetectorTypeAll;
    self.messageLabel.scrollEnabled = false;
    
    self.messageLabel.textColor = [UIColor colorWithRed:0.078 green:0.094 blue:0.137 alpha:1.00];
    if (feed.imageURL) {
        self.imageView.image = [UIImage imageNamed:@"black.png"];
        UIActivityIndicatorView *activityIndicator;
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake((10 +  self.contentView.bounds.size.width -20)/2,( [self.sizeDictionary[@"nameHeight"] floatValue] + [self.sizeDictionary[@"messageHeight"] floatValue] + 25 +[self.sizeDictionary[@"imageHeight"] floatValue])/2, 40.0, 40.0);
        [self.imageView addSubview: activityIndicator];
        
        
        // This line starts the activity indicator in the status bar
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        // This line starts the activity indicator on the view
        [activityIndicator startAnimating];        

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
            NSData *data= [NSData dataWithContentsOfURL:feed.imageURL];
            self.image=[UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image= self.image ;
                [activityIndicator stopAnimating];
            });
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        });
    }
    self.dateLabel.text = [self differenceStringFromDate:feed.date];
    self.dateLabel.textColor = [UIColor colorWithRed:0.569 green:0.592 blue:0.639 alpha:1.00];
    self.dateLabel.font = [UIFont fontWithName:@"ArialMT" size:10];
    self.view = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:false];
    self.clipsToBounds = YES;
}
-(void) layoutSubviews{
    self.view.frame = CGRectMake(5, 5, self.contentView.bounds.size.width - 10, self.contentView.bounds.size.height);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.view];
    self.nameLabel.frame = CGRectMake(10, 15, self.contentView.bounds.size.width, 51);
    
    self.dateLabel.frame = CGRectMake(15, 45, self.contentView.bounds.size.width, 25);
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.nameLabel];
    if (self.image) {
        self.imageView.frame = CGRectMake(10, [self.sizeDictionary[@"nameHeight"] floatValue] + [self.sizeDictionary[@"messageHeight"] floatValue] + 25 , self.contentView.bounds.size.width - 20, [self.sizeDictionary[@"imageHeight"] floatValue]);
        [self.contentView addSubview:self.imageView];
           }
    
    self.messageLabel.frame = CGRectMake(10, [self.sizeDictionary[@"nameHeight"] floatValue]  + 20 , self.contentView.bounds.size.width - 20, [self.sizeDictionary[@"messageHeight"] floatValue]);
   // NSLog(@"%f",self.contentView.bounds.size.height);
    [self.contentView addSubview:self.messageLabel];
}

@end