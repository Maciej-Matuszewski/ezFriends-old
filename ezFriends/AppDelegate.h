//
//  AppDelegate.h
//  ezFriends
//
//  Created by Maciej Matuszewski on 24.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import <SWRevealViewController/SWRevealViewController.h>
#import <Parse/Parse.h>
#import <Sinch/Sinch.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <TTTAttributedLabel.h>
#import <NMRangeSlider/NMRangeSlider.h>

#import "ezLoginViewController.h"
#import "ezButtonViewController.h"
#import "ezMenuViewController.h"
#import "ezRegisterWomenOrMenViewController.h"
#import "ezRegisterSelectMinMaxAgeViewController.h"
#import "ezOnlineNavigationController.h"

#import "NavigationControllerDelegate.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate,SWRevealViewControllerDelegate, SINClientDelegate, SINMessageClientDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIColor *ezColor;

@property (strong, nonatomic) SWRevealViewController *revealVC;

@property (nonatomic, retain) UINavigationController *navCon;

@property (nonatomic, retain) CLLocationManager *locationManager;

-(void)startUpdateLocation;

-(void)stopUpdateLocation;

- (void)sendTextMessage:(NSString *)messageText toRecipient:(NSString *)recipientId;

@end

