//
//  ezOnlineNavigationController.m
//  ezFriends
//
//  Created by Maciej Matuszewski on 27.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "ezOnlineNavigationController.h"
#import "AppDelegate.h"

@interface ezOnlineNavigationController ()

@property (nonatomic, readwrite) NavigationControllerDelegate *navconDelegate;

@end

@implementation ezOnlineNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navconDelegate = [[NavigationControllerDelegate alloc] init];
    self.navigationBar.barTintColor = [(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor];
    self.navigationBar.translucent = NO;
    self.navigationBarHidden = NO;
    [self setDelegate:self.navconDelegate];
    [self.navconDelegate awakeFromNib];
    
    UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [aFlowLayout setItemSize:CGSizeMake([[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height-self.navigationBar.frame.size.height)];
    [aFlowLayout setMinimumInteritemSpacing:0];
    [aFlowLayout setMinimumLineSpacing:0];
    [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self setViewControllers:@[[[ezUserFeedCollectionViewController alloc]initWithCollectionViewLayout:aFlowLayout]]];
    
    [self.navigationBar setTintColor:[UIColor whiteColor]];
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

@end
