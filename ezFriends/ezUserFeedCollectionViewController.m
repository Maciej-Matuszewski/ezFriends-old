//
//  ezUserFeedCollectionViewController.m
//  ezFriends
//
//  Created by Maciej Matuszewski on 27.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "ezUserFeedCollectionViewController.h"
#import "AppDelegate.h"

@interface ezUserFeedCollectionViewController ()

@property (nonatomic, retain) NSArray *users;

@end

@implementation ezUserFeedCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUsers:[[NSArray alloc] init]];
    [self.view setBackgroundColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
    [self.collectionView setBackgroundColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
    [self.collectionView setPagingEnabled:YES];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ezUserFeedProfileCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    PFQuery *query = [PFUser query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.users = objects;
            [self.collectionView reloadData];
        }
    }];
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
    return self.users.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block ezUserFeedProfileCollectionViewCell *cell = (ezUserFeedProfileCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell = [cell initWithUser:[self.users objectAtIndex:indexPath.row]];
    
    [cell.chatButton addTarget:self action:@selector(chatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)chatButtonAction:(UIButton *)sender{
    ezUserFeedProfileCollectionViewCell *cell = (ezUserFeedProfileCollectionViewCell *)[sender superview];
    ezChatViewController *chatView = [[ezChatViewController alloc] init];
    [chatView setUser:cell.pfUser];
    [self.navigationController pushViewController:chatView animated:YES];
}

#pragma mark <UICollectionViewDelegate>

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
