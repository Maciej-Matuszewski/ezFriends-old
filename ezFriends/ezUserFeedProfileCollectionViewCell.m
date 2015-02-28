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
        
        UILabel *nameLabel = [[UILabel alloc] init];
        [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [nameLabel setFont:[UIFont systemFontOfSize:36]];
        [nameLabel setTextColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setText:[NSString stringWithFormat:@"  %@  ",user[@"name"]]];
        [nameLabel.layer setCornerRadius:20];
        [nameLabel setClipsToBounds:YES];
        [nameLabel setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:nameLabel];
        /*
        UILabel *ageLabel = [[UILabel alloc] init];
        [ageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [ageLabel setFont:[UIFont boldSystemFontOfSize:60]];
        [ageLabel setTextColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
        [ageLabel setTextAlignment:NSTextAlignmentCenter];
        [ageLabel setText:@"20"];
        [self addSubview:ageLabel];
         //*/
        
        UIButton *chatButton = [[UIButton alloc] init];
        [chatButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [chatButton setImage:[UIImage imageNamed:@"chatCircle"] forState:UIControlStateNormal];
        [self addSubview:chatButton];
        UIButton *dismissButton = [[UIButton alloc] init];
        [dismissButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [dismissButton setImage:[UIImage imageNamed:@"dismissCircle"] forState:UIControlStateNormal];
        [self addSubview:dismissButton];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView(width)]|" options:0 metrics:@{@"width":[NSNumber numberWithFloat:self.bounds.size.width]} views:@{@"scrollView" : scrollView}]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView(width)]-(>=10)-[chatButton]-(==40)-|" options:0 metrics:@{@"width":[NSNumber numberWithFloat:self.bounds.size.width]} views:@{@"scrollView" : scrollView, @"chatButton" : dismissButton}]];
        
        //[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==20)-[ageLabel]-[nameLabel]" options:NSLayoutFormatAlignAllTop metrics:nil views:@{@"ageLabel" : ageLabel, @"nameLabel" : nameLabel}]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==50)-[dismissButton]-(>=10)-[chatButton]-(==50)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"chatButton" : chatButton, @"dismissButton" : dismissButton}]];
        
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
        [query orderByDescending:@"createdAt"];
        [query setLimit:20];
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
