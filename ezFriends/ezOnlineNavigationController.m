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
    [self setViewControllers:@[[[UIViewController alloc] init]]];
    
    self.navconDelegate = [[NavigationControllerDelegate alloc] init];
    self.navigationBar.barTintColor = [(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor];
    self.navigationBar.translucent = NO;
    self.navigationBarHidden = YES;
    [self setDelegate:self.navconDelegate];
    [self.navconDelegate awakeFromNib];
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
