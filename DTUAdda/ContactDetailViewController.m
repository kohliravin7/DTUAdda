//
//  ContactDetailViewController.m
//  DTUAdda
//
//  Created by Ravin Kohli on 02/05/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import "ContactDetailViewController.h"

@interface ContactDetailViewController ()

@end

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 5, self.view.bounds.size.width, 150)];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,150 + 5 + self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, 25)];
    self.descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(10, 250 , self.view.bounds.size.width - 20,500)];

    
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.lineBreakMode = 0;
    self.nameLabel.numberOfLines = 1;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    
    self.descriptionView.backgroundColor = [UIColor colorWithRed:0.933 green:0.729 blue:0.490 alpha:1.00];
    self.descriptionView.editable = NO;
    self.descriptionView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.descriptionView.tintColor = [UIColor colorWithWhite:0.97 alpha:1];
    self.descriptionView.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
   
    
    self.view.backgroundColor = [UIColor colorWithRed:0.933 green:0.729 blue:0.490 alpha:1.00];
    //[UIColor colorWithRed:0.647 green:0.486 blue:0.361 alpha:1.00];
    
    self.descriptionView.textColor = [UIColor colorWithWhite:0.96 alpha:1];
    
    
        // Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //CGFloat height = [self sizeForString:self.contacts.description];
    NSDictionary *contact = self.contacts.contact;
    NSString *string = [[NSString alloc] init];
    if (contact[@"SECOND"] == contact[@"THIRD"]) {
        string = [NSString stringWithFormat:@"%@\n %@\n", contact[@"Name"] , contact[@"No"]];
    } else {
        string = [NSString stringWithFormat:@"%@\n %@\n %@\n %@\n", contact[@"Name"], contact[@"SECOND"],contact[@"THIRD"] , contact[@"No"]];
    }
    //NSLog(@"%@", contact[@"Name"]);
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];

    self.nameLabel.text = self.contacts.title;
    self.descriptionView.text = [NSString stringWithFormat:@"%@\n%@",self.contacts.descriptions,string];

    NSURL *imageURL = [NSURL URLWithString:self.contacts.image];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
        NSData *data= [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image ;
        });
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        
    });
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.descriptionView];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat) sizeForString:(NSString *)string{
    float height = 80;
        if (string) {
        NSDictionary *attributes = @{
                                     NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
                                     };
        CGRect bodyFrame =
        [string boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds),
                                                CGFLOAT_MAX)
                             options:(NSStringDrawingUsesLineFragmentOrigin)
                          attributes:attributes
                             context:nil];
        
        height += ceilf(CGRectGetHeight(bodyFrame));
    }
    return height;
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
