//
//  ezMenuViewController.m
//  ezFriends
//
//  Created by Maciej Matuszewski on 25.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "ezMenuViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>


@interface ezMenuViewController ()

@property (nonatomic, retain) UIImageView *avatarImageView;

@end

@implementation ezMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
    
    UIImageView *userProfileImage = [[UIImageView alloc] init];
    [userProfileImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [userProfileImage setBackgroundColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
    [userProfileImage.layer setCornerRadius:60];
    [userProfileImage.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [userProfileImage.layer setBorderWidth:5];
    userProfileImage.clipsToBounds = YES;
    [self.view addSubview:userProfileImage];
    [userProfileImage setImage:[UIImage imageNamed:@"userDefault"]];
    
    [self setAvatarImageView:userProfileImage];

    
    
    UILabel *userName = [[UILabel alloc] init];
    [userName setTranslatesAutoresizingMaskIntoConstraints:NO];
    [userName setFont:[UIFont boldSystemFontOfSize:24]];
    [userName setTextAlignment:NSTextAlignmentCenter];
    [userName setTextColor:[UIColor whiteColor]];
    [self.view addSubview:userName];
    [userName setText:[[PFUser currentUser] objectForKey:@"name"]];
    
    
    UIButton *mainButton = [[UIButton alloc] init];
    [mainButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [mainButton setImage:[UIImage imageNamed:@"iconMain"] forState:UIControlStateNormal];
    [mainButton setTitle:@"Back to game" forState:UIControlStateNormal];
    [mainButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:mainButton];
    
    
    UIButton *messagesButton = [[UIButton alloc] init];
    [messagesButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [messagesButton setImage:[UIImage imageNamed:@"iconMessages"] forState:UIControlStateNormal];
    [messagesButton setTitle:@"Messages" forState:UIControlStateNormal];
    [messagesButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:messagesButton];
    [messagesButton addTarget:self action:@selector(messageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *profileButton = [[UIButton alloc] init];
    [profileButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [profileButton setImage:[UIImage imageNamed:@"iconProfile"] forState:UIControlStateNormal];
    [profileButton setTitle:@"Profile" forState:UIControlStateNormal];
    [profileButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:profileButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:userProfileImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:userName attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:userProfileImage attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[item(==120)]" options:0 metrics:nil views:@{@"item":userProfileImage}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==35)-[userProfileImage(==120)]-[userName]-(==25)-[main]" options:0 metrics:nil views:@{@"userProfileImage":userProfileImage, @"userName" : userName, @"main":mainButton}]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[main]-[messages]-[profile]" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{@"main":mainButton, @"messages" : messagesButton, @"profile" : profileButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[item]" options:0 metrics:nil views:@{@"item":mainButton}]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PFFile *userImageFile = [[PFUser currentUser] objectForKey:@"photo"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            [self.avatarImageView setImage:[UIImage imageWithData:imageData]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)messageButtonAction{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate]sendTextMessage:@"test" toRecipient:@"bipkJon2zv"];
}

@end
