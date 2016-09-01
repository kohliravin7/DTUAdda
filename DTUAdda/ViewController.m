//
//  ViewController.m
//  FBSDKDemo
//
//  Created by Ravin Kohli on 27/02/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKProfile.h>

@interface ViewController ()

@property (nonatomic) UIButton *myLoginButton;
@property (nonatomic) FBSDKProfile *profile;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add a custom login button to your app
    self.myLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.myLoginButton.backgroundColor=[UIColor darkGrayColor];
    self.myLoginButton.frame=CGRectMake(0,0,180,40);
    self.myLoginButton.center = self.view.center;
    [self.myLoginButton setTitle: @"My Login Button" forState: UIControlStateNormal];
    // Handle clicks on the button
    [self.myLoginButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the button to the view
    [self.view addSubview:self.myLoginButton];
}
-(void)loginButtonClicked
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
             
         } else {
             NSLog(@"Logged in");
             self.profile = [FBSDKProfile currentProfile];
             NSLog(@"%@",self.profile);
             [self.myLoginButton removeFromSuperview];
             [self loginButtonDidClick];
             if ([FBSDKAccessToken currentAccessToken]) {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/382057938566656/feed" parameters:[NSDictionary dictionaryWithObjects:@[[FBSDKAccessToken currentAccessToken]] forKeys:@[@"access_token"]]]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          NSLog(@"fetched user:%@", result);
                          self.postArray = [result objectForKey:@"data"];
                        //  [self loadDCESpeaksUp];

                      }
                  }];
             }
         }
     }];
}

-(void)loginButtonDidClick{
//    [[NSNotificationCenter defaultCenter] addObserverForName:FBSDKProfileDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//        //do whatever you want
//            }];
    for (int i=0; i<13020349; i++) {
    //
    }
    UILabel *firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 35, 250, 25)];
    firstNameLabel.text = self.profile.firstName;
    NSLog(@"profile name:%@",self.profile.firstName);
    firstNameLabel.backgroundColor = [UIColor blackColor];
    firstNameLabel.textColor = [UIColor redColor];
    firstNameLabel.tintColor = [UIColor blueColor];

    [self.view addSubview:firstNameLabel];

}

-(void)loadDCESpeaksUp{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@/posts",[self.postArray objectForKey:@"id"]] parameters:[NSDictionary dictionaryWithObjects:@[@"posts",[FBSDKAccessToken currentAccessToken]] forKeys:@[@"fields",@"access_token"]]]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
             }
         }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
