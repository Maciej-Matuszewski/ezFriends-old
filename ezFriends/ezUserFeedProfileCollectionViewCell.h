//
//  ezUserFeedProfileCollectionViewCell.h
//  ezFriends
//
//  Created by Maciej Matuszewski on 27.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ezUserFeedProfileCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView * scrollView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UIButton *chatButton;
@property (nonatomic, retain) UIButton *dismissButton;

@property (nonatomic, retain) NSArray *photosArray;

@property (nonatomic, retain) NSMutableArray *imageViewsArray;

@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) PFUser* pfUser;

@property BOOL imagesLoaded;

- (instancetype)initWithUser:(PFUser *)user;

@end
