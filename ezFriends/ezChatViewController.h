//
//  ezChatViewController.h
//  ezFriends
//
//  Created by Maciej Matuszewski on 28.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import <JSQMessagesViewController/JSQMessages.h>
#import "AppDelegate.h"

@interface ezChatViewController : JSQMessagesViewController<UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) PFUser *user;


@end
