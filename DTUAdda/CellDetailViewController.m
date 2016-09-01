//
//  CellDetailViewController.m
//  DTU Guide
//
//  Created by Ravin Kohli on 15/06/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import "CellDetailViewController.h"

@interface CellDetailViewController ()

@end

@implementation CellDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1];
    
    self.messageLabel = [[UITextView alloc] init];
    self.imageView = [[UIImageView alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.dateLabel = [[UILabel alloc] init];
    self.cardView = [[UIView alloc] init];
    
    self.nameLabel.text = @"DCE Speaks Up";
    self.nameLabel.textColor = [UIColor colorWithRed:0.235 green:0.353 blue:0.588 alpha:1.00];
    
    self.messageLabel.font = [UIFont fontWithName:@"Droid Sans" size:15];
    self.messageLabel.editable = NO;
    self.messageLabel.dataDetectorTypes = UIDataDetectorTypeAll;
    self.messageLabel.scrollEnabled = true;
    self.messageLabel.userInteractionEnabled = true;
    self.messageLabel.backgroundColor = [UIColor whiteColor];
    self.messageLabel.textColor = [UIColor colorWithRed:0.078 green:0.094 blue:0.137 alpha:1.00];

    self.dateLabel.textColor = [UIColor colorWithRed:0.569 green:0.592 blue:0.639 alpha:1.00];
    self.dateLabel.font = [UIFont fontWithName:@"ArialMT" size:10];
    
    self.cardView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];


    // Do any additional setup after loading the view.
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1];
//    self.sizeDictionary = [[NSDictionary alloc] init];
       if(self.feed.message){
        self.messageLabel.text = self.feed.message;
    }else if (self.feed.story){
        self.messageLabel.text = self.feed.story;
    }
    
    if (self.feed.imageURL) {
        self.imageView.image = [UIImage imageNamed:@"black.png"];
//        UIActivityIndicatorView *activityIndicator;
//        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        activityIndicator.frame = CGRectMake((10 +  self.view.bounds.size.width -20),( [self.sizeDictionary[@"nameHeight"] floatValue] + [self.sizeDictionary[@"messageHeight"] floatValue] + 25 +[self.sizeDictionary[@"imageHeight"] floatValue])/2, 40.0, 40.0);
//        [self.imageView addSubview: activityIndicator];
//            
//            // This line starts the activity indicator in the status bar
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//            
//            // This line starts the activity indicator on the view
//        [activityIndicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
            NSData *data= [NSData dataWithContentsOfURL:self.feed.imageURL];
            self.image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image= self.image ;
                //[activityIndicator stopAnimating];
            });
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        });
    }
    self.dateLabel.text = [self differenceStringFromDate:self.feed.date];
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:false];
    self.cardView.frame = CGRectMake(5, 5 + self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width - 10, [self.sizeDictionary[@"imageHeight"] floatValue]+ [self.sizeDictionary[@"messageHeight"] floatValue] + [self.sizeDictionary[@"nameHeight"] floatValue] + 20);
    self.cardView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.cardView];
    self.nameLabel.frame = CGRectMake(10, 15+ self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, 51);
    
    self.dateLabel.frame = CGRectMake(15, 45+ self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, 25);
    self.messageLabel.frame = CGRectMake(10, [self.sizeDictionary[@"nameHeight"] floatValue]  + 20 + self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width - 20, MIN([self.sizeDictionary[@"messageHeight"] floatValue], self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height-[self.sizeDictionary[@"imageHeight"] floatValue]));
    //NSLog(@"%f",self.messageLabel.frame.size.height);
    [self.view addSubview:self.messageLabel];
    [self.view addSubview:self.dateLabel];
    [self.view addSubview:self.nameLabel];
    if (self.feed.imageURL) {
        self.imageView.frame = CGRectMake(10, [self.sizeDictionary[@"nameHeight"] floatValue]  + 35 + self.navigationController.navigationBar.frame.size.height + MIN([self.sizeDictionary[@"messageHeight"] floatValue], self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height-[self.sizeDictionary[@"imageHeight"] floatValue]) , self.view.bounds.size.width - 20, [self.sizeDictionary[@"imageHeight"] floatValue]);
        
        [self.view addSubview:self.imageView];
        NSLog(@"%f",self.imageView.frame.size.height);
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Memory Warning");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
