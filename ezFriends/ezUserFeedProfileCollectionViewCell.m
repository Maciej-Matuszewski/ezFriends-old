//
//  ezUserFeedProfileCollectionViewCell.m
//  ezFriends
//
//  Created by Maciej Matuszewski on 27.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "ezUserFeedProfileCollectionViewCell.h"

@implementation ezUserFeedProfileCollectionViewCell


- (instancetype)initWithUser:(PFUser *)user{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.pfUser = user;
        self.scrollView = [[ UIScrollView alloc] init];
        [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"userDefault"]]];
        [self.scrollView setDelegate:self];
        [self addSubview:self.scrollView];
        
        self.nameLabel = [[UILabel alloc] init];
        [self.nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.nameLabel setFont:[UIFont systemFontOfSize:36]];
        [self.nameLabel setTextColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setText:[NSString stringWithFormat:@"  %@  ",user[@"name"]]];
        [self.nameLabel.layer setCornerRadius:20];
        [self.nameLabel setClipsToBounds:YES];
        [self.nameLabel setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.nameLabel];
        
        
        self.chatButton = [[UIButton alloc] init];
        [self.chatButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.chatButton setImage:[UIImage imageNamed:@"chatCircle"] forState:UIControlStateNormal];
        [self addSubview:self.chatButton];
        self.dismissButton = [[UIButton alloc] init];
        [self.dismissButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.dismissButton setImage:[UIImage imageNamed:@"dismissCircle"] forState:UIControlStateNormal];
        [self addSubview:self.dismissButton];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView(width)]|" options:0 metrics:@{@"width":[NSNumber numberWithFloat:self.bounds.size.width]} views:@{@"scrollView" : self.scrollView}]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView(width)]-(>=10)-[chatButton]-(==40)-|" options:0 metrics:@{@"width":[NSNumber numberWithFloat:self.bounds.size.width]} views:@{@"scrollView" : self.scrollView, @"chatButton" : self.dismissButton}]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==50)-[dismissButton]-(>=10)-[chatButton]-(==50)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"chatButton" : self.chatButton, @"dismissButton" : self.dismissButton}]];
        
        self.imageView = [[ UIImageView alloc] init];
        [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.scrollView addSubview:self.imageView];
        
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(width)]" options:0 metrics:@{@"width":[NSNumber numberWithFloat:self.bounds.size.width]} views:@{@"imageView" : self.imageView}]];
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView(width)]" options:0 metrics:@{@"width":[NSNumber numberWithFloat:self.bounds.size.width]} views:@{@"imageView" : self.imageView}]];
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:((PFFile *)user[@"photo"]).url]];
        
        
        PFQuery *query = [PFQuery queryWithClassName:@"Photos"];
        [query whereKey:@"user" equalTo:user];
        [self setImagesLoaded:NO];
        
        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            
            [self.scrollView setContentSize:CGSizeMake(self.bounds.size.width*(number+1), self.bounds.size.width)];
            [self.scrollView setScrollEnabled:YES];
            [self.scrollView setPagingEnabled:YES];
 
        }];
        
        
        
        
        
    }
    return self;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    
    if (!self.imagesLoaded) {
        [self setImagesLoaded:YES];
        PFQuery *query = [PFQuery queryWithClassName:@"Photos"];
        [query whereKey:@"user" equalTo:self.pfUser];
        [query orderByDescending:@"createdAt"];
        [query setLimit:20];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [scrollView setContentSize:CGSizeMake(self.bounds.size.width*(objects.count+1), self.bounds.size.width)];
                [scrollView setScrollEnabled:YES];
                [scrollView setPagingEnabled:YES];
                @autoreleasepool {
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    
                    [self setImageViewsArray:[[NSMutableArray alloc] init]];
                    
                    for (PFObject *object in objects) {
                        UIImageView *imageView = [[ UIImageView alloc] init];
                        [array addObject:imageView];
                        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
                        [scrollView addSubview:imageView];
                        
                        [imageView sd_setImageWithURL:[NSURL URLWithString:((PFFile *)object[@"photo"]).url]];
                        
                    }
                    
                    int i = 0;
                    for (UIImageView *imageView in array){
                        [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(width)]" options:0 metrics:@{@"width":[NSNumber numberWithFloat:self.bounds.size.width]} views:@{@"imageView" : imageView}]];
                        
                        [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lastImageView][imageView(width)]" options:0 metrics:@{@"width":[NSNumber numberWithFloat:self.bounds.size.width]} views:@{@"lastImageView" : i==0?self.imageView : [array objectAtIndex:i-1], @"imageView" : imageView}]];
                        
                        i++;
                    }
                }
                
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];

    }
    
    
}

@end
