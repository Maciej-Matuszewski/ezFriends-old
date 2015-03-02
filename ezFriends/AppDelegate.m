//
//  AppDelegate.m
//  ezFriends
//
//  Created by Maciej Matuszewski on 24.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@property (strong, nonatomic) id<SINClient> sinchClient;
@property (strong, nonatomic) id<SINMessageClient> sinchMessageClient;

@property (nonatomic, readwrite) NavigationControllerDelegate *navconDelegate;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [ParseCrashReporting enable];
    [Parse setApplicationId:@"KPVyoSoqflNJcwYQdGKfw7L2BZmEMNURiqNarauQ"
                  clientKey:@"jOeRqjS6irCw8xcMLsdwjtXZcOicMl3odmDCngBv"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebook];
    
    [[PFInstallation currentInstallation] saveInBackground];
    
    
    [self setEzColor:[UIColor colorWithRed:0.384 green:0.118 blue:0.541 alpha:1]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //*
    if ([PFUser currentUser]) {
        self.revealVC = [[SWRevealViewController alloc] initWithRearViewController:[[ezMenuViewController alloc] init] frontViewController:[[ezButtonViewController alloc] init]];
        self.revealVC.delegate = self;
        self.revealVC.bounceBackOnOverdraw=NO;
        self.revealVC.stableDragOnOverdraw=NO;
        [self.revealVC setRearViewRevealOverdraw:5];
        self.window.rootViewController = self.revealVC;
    }else{
        self.navconDelegate = [[NavigationControllerDelegate alloc] init];
        self.navCon = [[UINavigationController alloc] initWithRootViewController:[[ezLoginViewController alloc] init]];
        self.navCon.navigationBar.barTintColor = [UIColor darkGrayColor];
        self.navCon.navigationBar.translucent = NO;
        self.navCon.navigationBarHidden = YES;
        [self.navCon setDelegate:self.navconDelegate];
        [self.navconDelegate awakeFromNib];
        self.window.rootViewController = self.navCon;
    }
    //*/
    
    //self.window.rootViewController = [[ezChatViewController alloc] init];
    
    [self.window makeKeyAndVisible];

    self.locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    

    
    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

#pragma mark Functional methods

// Initialize the Sinch client
- (void)initSinchClient:(NSString*)userId {
    self.sinchClient = [Sinch clientWithApplicationKey:@"afcb4ea9-6a44-4f91-b764-821460493ff0"
                                     applicationSecret:@"/ES1zu3zRU64Zj9bpiUQaQ=="
                                       environmentHost:@"sandbox.sinch.com"
                                                userId:userId];
    
    
    
    self.sinchClient.delegate = self;
    
    NSLog(@"Sinch version: %@, userId: %@", [Sinch version], [self.sinchClient userId]);
    
    [self.sinchClient setSupportMessaging:YES];
    [self.sinchClient setSupportPushNotifications:YES];
    [self.sinchClient start];
    [self.sinchClient startListeningOnActiveConnection];
    [self.sinchClient setSupportActiveConnectionInBackground:NO];
}

#pragma mark SINClientDelegate methods

- (void)clientDidStart:(id<SINClient>)client {
    NSLog(@"Start SINClient successful!");
    self.sinchMessageClient = [self.sinchClient messageClient];
    self.sinchMessageClient.delegate =  self;
}

- (void)clientDidFail:(id<SINClient>)client error:(NSError *)error {
    NSLog(@"Start SINClient failed. Description: %@. Reason: %@.", error.localizedDescription, error.localizedFailureReason);
}

#pragma mark SINMessageClientDelegate methods
// Receiving an incoming message.
- (void)messageClient:(id<SINMessageClient>)messageClient didReceiveIncomingMessage:(id<SINMessage>)message {
    
    [self saveNewMessagesWithUser:[message senderId] withText:[message text] withDate:[message timestamp] incoming:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SINCH_MESSAGE_RECIEVED object:self userInfo:@{@"message" : message}];
}

// Finish sending a message
- (void)messageSent:(id<SINMessage>)message recipientId:(NSString *)recipientId {
    [[NSNotificationCenter defaultCenter] postNotificationName:SINCH_MESSAGE_SENT object:self userInfo:@{@"message" : message}];
}

// Failed to send a message
- (void)messageFailed:(id<SINMessage>)message info:(id<SINMessageFailureInfo>)messageFailureInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:SINCH_MESSAGE_FAILED object:self userInfo:@{@"message" : message}];
    NSLog(@"MessageBoard: message to %@ failed. Description: %@. Reason: %@.", messageFailureInfo.recipientId, messageFailureInfo.error.localizedDescription, messageFailureInfo.error.localizedFailureReason);
}

-(void)messageDelivered:(id<SINMessageDeliveryInfo>)info
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SINCH_MESSAGE_FAILED object:info];
}

#pragma mark Functional methods

// Send a text message
- (void)sendTextMessage:(NSString *)messageText toRecipient:(NSString *)recipientId {
    SINOutgoingMessage *outgoingMessage = [SINOutgoingMessage messageWithRecipient:recipientId text:messageText];
    [self.sinchClient.messageClient sendMessage:outgoingMessage];
    [self saveNewMessagesWithUser:recipientId withText:messageText  withDate:[NSDate date] incoming:NO];
}

-(void)message:(id<SINMessage>)message shouldSendPushNotifications:(NSArray *)pushPairs{
    for(NSString *stringId in [message recipientIds] ){
        [PFPush sendPushMessageToChannel:[NSString stringWithFormat:@"u_%@",stringId] withMessage:[message text] error:nil];
    }

}

#pragma mark - notifications

-(void)registerPush{
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation addUniqueObject:[NSString stringWithFormat:@"u_%@",[[PFUser currentUser] objectId]] forKey:@"channels"];
    [currentInstallation saveInBackground];
    
    
    id<SINClient> client = [self sinchClient];
    [client registerPushNotificationData:deviceToken];
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"notification");
}

#pragma mark - location

-(void)startUpdateLocation{

    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        [_locationManager requestAlwaysAuthorization];
    } else {
        [_locationManager startUpdatingLocation];
    }
 
}

- (void)stopUpdateLocation{
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
    [[PFUser currentUser] setObject:point forKey:@"location"];
    [[PFUser currentUser] saveInBackground];
    
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [_locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}

#pragma mark - revealController
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        revealController.frontViewController.view.userInteractionEnabled = YES;
    } else {
        revealController.frontViewController.view.userInteractionEnabled = NO;
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        revealController.frontViewController.view.userInteractionEnabled = YES;
    } else {
        revealController.frontViewController.view.userInteractionEnabled = NO;
    }
}

#pragma mark - messages database

-(void)loadMessages{
    NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[[PFUser currentUser] objectId]]];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self setMessagesDatabase:[NSMutableDictionary dictionaryWithContentsOfFile:filePath]];
    }else{
        [self setMessagesDatabase:[[NSMutableDictionary alloc] init]];
    }
}

-(NSArray *)reciveMessagesForUser:(NSString *)userID{
    NSArray *messages;
    if ([self.messagesDatabase objectForKey:userID]){
        messages = [self.messagesDatabase objectForKey:userID];
        if(messages.count>20)messages = [messages subarrayWithRange:NSMakeRange(messages.count-20, 20)];
        
    }else messages  = [[NSArray alloc] init];
    return messages;
}

-(void)saveNewMessagesWithUser:(NSString *)userID withText:(NSString *)text withDate:(NSDate *)date incoming:(BOOL)incoming{
    
    NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[[PFUser currentUser] objectId]]];
    NSArray *messages;
    if ([self.messagesDatabase objectForKey:userID])messages = [self.messagesDatabase objectForKey:userID];
    else messages  = [[NSMutableArray alloc] init];
    
    NSDictionary *message = [[NSDictionary alloc] initWithObjects:@[incoming?userID:[[PFUser currentUser] objectId], text, date] forKeys:@[@"senderID", @"text", @"date"]];
    messages = [messages arrayByAddingObject:message];
    
    [self.messagesDatabase setObject:messages forKey:userID];
    [self.messagesDatabase writeToFile:filePath atomically:NO];

}

#pragma mark - dateAction
- (int)hoursBetween:(NSDate *)firstDate and:(NSDate *)secondDate {
    NSUInteger unitFlags = NSHourCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:firstDate toDate:secondDate options:0];
    return [components hour]+1;
}

#pragma mark - applicationEvents
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
