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
        UIScrollView * scrollView = [[ UIScrollView alloc] init];
        [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"userDefault"]]];
        [scrollView setDelegate:self];
        [self addSubview:scrollView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView(width)]|" options:0 metrics:@{@"width":[NSNumber numberWithFloat:self.bounds.size.width]} views:@{@"scrollView" : scrollView}]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView(width)]" options:NSLayoutFormatAlignAllCenterX metrics:@{@"width":[NSNumber numberWithFloat:self.bounds.size.width]} views:@{@"scrollView" : scrollView}]];
        
        self.imageView = [[ UIImageView alloc] init];
        [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [scrollView addSubview:self.imageView];
        
        [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(width)]" options:0 metrics:@{@"width":[NSNumber numberWithFloat:self.bounds.size.width]} views:@{@"imageView" : self.imageView}]];
        [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView(width)]" options:0 metrics:@{@"width":[NSNumber numberWithFloat:self.bounds.size.width]} views:@{@"imageView" : self.imageView}]];
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:((PFFile *)user[@"photo"]).url]];
        
        
        PFQuery *query = [PFQuery queryWithClassName:@"Photos"];
        [query whereKey:@"user" equalTo:user];
        [self setImagesLoaded:NO];
        
        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            
            [scrollView setContentSize:CGSizeMake(self.bounds.size.width*(number+1), self.bounds.size.width)];
            [scrollView setScrollEnabled:YES];
            [scrollView setPagingEnabled:YES];
 
        }];
        
        
        
        
        
    }
    return self;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    
    if (!self.imagesLoaded) {
        [self setImagesLoaded:YES];
        PFQuery *query = [PFQuery queryWithClassName:@"Photos"];
        [query whereKey:@"user" equalTo:self.pfUser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [scrollView setContentSize:CGSizeMake(self.bounds.size.width*(objects.count+1), self.bounds.size.width)];
                [scrollView setScrollEnabled:YES];
                [scrollView setPagingEnabled:YES];
                
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
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];

    }
    
    
}

@end
