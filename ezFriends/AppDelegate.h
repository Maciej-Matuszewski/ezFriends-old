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
#import <ParseCrashReporting/ParseCrashReporting.h>
#import <Sinch/Sinch.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <TTTAttributedLabel.h>
#import <NMRangeSlider/NMRangeSlider.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <FPPopover/FPPopoverController.h>

#import "ezLoginViewController.h"
#import "ezButtonViewController.h"
#import "ezMenuViewController.h"
#import "ezRegisterWomenOrMenViewController.h"
#import "ezRegisterSelectMinMaxAgeViewController.h"
#import "ezOnlineNavigationController.h"
#import "ezUserFeedCollectionViewController.h"
#import "ezUserFeedProfileCollectionViewCell.h"
#import "ezChatViewController.h"
#import "ezStickersCollectionViewController.h"

#import "NavigationControllerDelegate.h"


#define SINCH_MESSAGE_RECIEVED @"SINCH_MESSAGE_RECIEVED"
#define SINCH_MESSAGE_SENT @"SINCH_MESSAGE_SENT"
#define SINCH_MESSAGE_DELIVERED @"SINCH_MESSAGE_DELIVERED"
#define SINCH_MESSAGE_FAILED @"SINCH_MESSAGE_DELIVERED"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate,SWRevealViewControllerDelegate, SINClientDelegate, SINMessageClientDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIColor *ezColor;

@property (strong, nonatomic) SWRevealViewController *revealVC;

@property (nonatomic, retain) UINavigationController *navCon;

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) NSMutableDictionary *messagesDatabase;

-(void)startUpdateLocation;

-(void)stopUpdateLocation;

- (void)sendTextMessage:(NSString *)messageText toRecipient:(NSString *)recipientId;

-(void)registerPush;

- (void)initSinchClient:(NSString*)userId;

-(void)loadMessages;

-(NSArray *)reciveMessagesForUser:(NSString *)userID;

-(void)saveNewMessagesWithUser:(NSString *)userID withText:(NSString *)text withDate:(NSDate *)date incoming:(BOOL)incoming;

- (int)hoursBetween:(NSDate *)firstDate and:(NSDate *)secondDate;

@end

