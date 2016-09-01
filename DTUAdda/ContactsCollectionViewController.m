//
//  ContactsCollectionViewController.m
//  DTUAdda
//
//  Created by Ravin Kohli on 02/05/16.
//  Copyright © 2016 Ravin Kohli. All rights reserved.
//

#import "ContactsCollectionViewController.h"
#import "Contacts.h"
#import "ContactsCollectionViewCell.h"
#import "ContactDetailViewController.h"

@interface ContactsCollectionViewController ()

@end

@implementation ContactsCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
-(instancetype)init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(124.0f, 124.0f);
    layout.minimumInteritemSpacing = 1.0f;
    layout.minimumLineSpacing = 10.0f;
    
    return (self = [super initWithCollectionViewLayout:layout]);
    
}
-(void) contactsLoad{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dtuguide" ofType:@"json"];
    
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:0 error:nil];
    
    NSError *error;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"%@",error.localizedDescription);
    
    self.contacts = [[NSMutableArray alloc] init];
    
    NSArray *contactArray = [jsonObject objectForKey:@"contact"];
    
    for (NSDictionary *cDictionary in contactArray) {
        Contacts *contactObject =[Contacts contactWithTitle:[cDictionary objectForKey:@"title"]];
        contactObject.descriptions = [cDictionary objectForKey:@"description"];
        contactObject.image = [cDictionary objectForKey:@"images"];
        contactObject.contact = [cDictionary objectForKey:@"contacts"];
//        NSLog(@"%@", contactObject);
        [self.contacts addObject:contactObject];
        
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Societies";
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.933 green:0.729 blue:0.490 alpha:1.00];
    //[UIColor colorWithRed:0.647 green:0.486 blue:0.361 alpha:1.00];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    [self contactsLoad];
    // Register cell classes
    [self.collectionView registerClass:[ContactsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ContactsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Contacts *contact = self.contacts[indexPath.row];
    cell.photoURL = contact.image;
    cell.nameString = contact.title;
    // Configure the cell
    cell.layer.shouldRasterize = YES;           //quickens up the cell load in uicollection view - do check it out later
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    return cell;
}

#pragma mark <UICollectionViewDelegate>


//
//-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath =[self.collectionView indexPathForSelectedRow];
//        ContactDetailViewController *cdvc = (ContactDetailViewController *)segue.destinationViewController;
//        cdvc.contacts = self.contacts[indexPath.row];
//    }
//    
//}
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ContactDetailViewController *cdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    cdvc.contacts = self.contacts[indexPath.row];
    [self.navigationController pushViewController:cdvc animated:YES];
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
