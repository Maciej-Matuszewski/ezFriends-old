//
//  ezStickersCollectionViewController.h
//  ezFriends
//
//  Created by Maciej Matuszewski on 28.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ezStickersCollectionViewController : UICollectionViewController<FPPopoverControllerDelegate>

@property (nonatomic, strong) void(^returnSticker)(NSString *);

@end
