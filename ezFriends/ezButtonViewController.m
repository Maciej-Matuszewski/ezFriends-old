//
//  ezButtonViewController.m
//  ezFriends
//
//  Created by Maciej Matuszewski on 24.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "ezButtonViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import "PBJVision.h"

#import "UIViewController+DBPrivacyHelper.h"

#import <CoreLocation/CoreLocation.h>

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface ezButtonViewController () <PBJVisionDelegate>

@property(nonatomic, retain) IBOutlet UIButton *buttonView;

@property(nonatomic, retain) IBOutlet UIButton *takePhotoButton;

@property(nonatomic, retain) IBOutlet UISlider *proximitySlider;

@property(nonatomic, retain) IBOutlet UILabel *sliderValueBig;

@property(nonatomic, retain) IBOutlet UIView *previewView;
@property(nonatomic, retain) IBOutlet AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ezButtonViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] registerPush];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] initSinchClient:[[PFUser currentUser] objectId]];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBackground"]]];
    
    [[PFUser currentUser] fetchInBackground];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIButton *menuButton =[[UIButton alloc]init];
    [menuButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
    [self setSliderValueBig:[[UILabel alloc] init]];
    [self.sliderValueBig setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.sliderValueBig];
    [self.sliderValueBig setText:@"25 km"];
    [self.sliderValueBig setFont:[UIFont boldSystemFontOfSize:90]];
    [self.sliderValueBig setTextColor:[(AppDelegate*)[[UIApplication sharedApplication] delegate] ezColor]];
    [self.sliderValueBig setAlpha:0];
    
    
    [self setButtonView:[[UIButton alloc] init]];
    [self.buttonView setImage:[UIImage imageNamed:@"mainButton"] forState:UIControlStateNormal];
    [self.buttonView setImage:[UIImage imageNamed:@"mainButtonWhite"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.buttonView];
    [self.buttonView.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.buttonView setTranslatesAutoresizingMaskIntoConstraints:NO];
    

    self.buttonView.layer.cornerRadius =self.view.bounds.size.width*0.4;
    self.buttonView.layer.masksToBounds = YES;
    [self.buttonView setClipsToBounds:YES];
    [self.buttonView addTarget:self action:@selector(prepareForPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    [self setTakePhotoButton:[[UIButton alloc] init]];
    [self.takePhotoButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.takePhotoButton setImage:[UIImage imageNamed:@"cameraCircle"] forState:UIControlStateNormal];
    [self.takePhotoButton addTarget:self action:@selector(takePhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.takePhotoButton];
    [self.takePhotoButton setHidden:YES];
    
    [self setProximitySlider:[[UISlider alloc] init]];
    [self.proximitySlider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.proximitySlider setTintColor:[(AppDelegate*)[[UIApplication sharedApplication] delegate] ezColor]];
    [self.proximitySlider setThumbImage:[UIImage imageNamed:@"sliderCircle"] forState:UIControlStateNormal];
    [self.proximitySlider setMaximumValue:100];
    [self.proximitySlider setMinimumValue:10];
    [self.proximitySlider setValue:25];
    
    [self.view addSubview:self.proximitySlider];
    
    [self.proximitySlider addTarget:self action:@selector(sliderStart) forControlEvents:UIControlEventTouchDown];
    [self.proximitySlider addTarget:self action:@selector(sliderStop) forControlEvents:UIControlEventTouchUpInside];
    [self.proximitySlider addTarget:self action:@selector(sliderStop) forControlEvents:UIControlEventTouchUpOutside];
    [self.proximitySlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoTextColor"]];
    [logo setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:logo];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.sliderValueBig attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.sliderValueBig attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.sliderValueBig attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.sliderValueBig attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.proximitySlider attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.takePhotoButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.proximitySlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.takePhotoButton attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==30)-[logo]-(>=20)-[button(width)]-(>=20)-[photoButton]-(==10)-|" options:NSLayoutFormatAlignAllCenterX metrics:@{@"width":[NSNumber numberWithFloat:self.view.bounds.size.width*0.8]} views:@{@"button" : self.buttonView, @"photoButton" : self.takePhotoButton, @"logo" : logo}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(width)]" options:0 metrics:@{@"width":[NSNumber numberWithFloat:self.view.bounds.size.width*0.8]} views:@{@"button" : self.buttonView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[menuButton]-(>=1)-[logo]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"logo" : logo, @"menuButton" : menuButton}]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[item(width)]" options:0 metrics:@{@"width":[NSNumber numberWithFloat:self.view.bounds.size.width*0.8]} views:@{@"item" : self.proximitySlider}]];
    
    [self.buttonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[item]|" options:0 metrics:nil views:@{@"item":self.buttonView.imageView}]];
    [self.buttonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[item]|" options:0 metrics:nil views:@{@"item":self.buttonView.imageView}]];

    [self performSelector:@selector(pushToUserFeed) withObject:nil];
    
}

-(void)pushToUserFeed{
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] revealVC] setFrontViewController:[[ezOnlineNavigationController alloc] init]];
}


-(void)menuButtonAction{
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] revealVC] revealToggleAnimated:YES];
}

- (void)sliderStart{
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.buttonView setAlpha:0];
        [self.sliderValueBig setAlpha:1];
    } completion:nil];

}

- (void)sliderStop{
    [UIView animateWithDuration:0.5 animations:^{
        [self.buttonView setAlpha:1];
        [self.sliderValueBig setAlpha:0];
    } completion:nil];

    
}

- (void)sliderValueChanged{
    [self.sliderValueBig setText:[NSString stringWithFormat:@"%d km",(int)[self.proximitySlider value]]];
}

- (BOOL)checkPermission:(NSString*)mediaType{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    } else if(authStatus == AVAuthorizationStatusDenied){
        return NO;
    } else if(authStatus == AVAuthorizationStatusRestricted){
        return NO;
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:nil];
        return NO;
    } else {
        return NO;
    }
    return NO;
}

- (void)prepareForPhoto{
    
    if ([self checkPermission:AVMediaTypeVideo]) {
        [[PBJVision sharedInstance] previewLayer];
        
        
        _previewView = [[UIView alloc] initWithFrame:CGRectZero];
        _previewView.backgroundColor = [UIColor clearColor];
        CGRect previewFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)*0.8, CGRectGetWidth(self.view.frame)*0.8);
        _previewView.frame = previewFrame;
        
        _previewLayer = [[PBJVision sharedInstance] previewLayer];
        _previewLayer.frame = _previewView.bounds;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [_previewView.layer addSublayer:_previewLayer];
        
        PBJVision *vision = [PBJVision sharedInstance];
        vision.delegate = self;
        vision.cameraDevice = PBJCameraDeviceFront;
        vision.cameraMode = PBJCameraModePhoto;
        vision.cameraOrientation = PBJCameraOrientationPortrait;
        vision.focusMode = PBJFocusModeContinuousAutoFocus;
        vision.outputFormat = PBJOutputFormatSquare;
        
        [vision startPreview];
        
        
        [self.takePhotoButton setAlpha:0];
        [self.takePhotoButton setHidden:NO];
        [self.previewView setAlpha:0];
        [self.buttonView addSubview:_previewView];
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.takePhotoButton setAlpha:1];
            [self.previewView setAlpha:1];
            [self.proximitySlider setAlpha:0];
        } completion:^(BOOL finished) {
            [self.proximitySlider setHidden:YES];
        }];
    }else{
        [self showPrivacyHelperForType:DBPrivacyTypeCamera controller:^(DBPrivateHelperController *vc) {
        } didPresent:^{
        } didDismiss:^{
            if([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)[self showPrivacyHelperForType:DBPrivacyTypeCamera];
        } useDefaultSettingPane:NO];

    }
}

- (void)takePhotoAction{
    [[PBJVision sharedInstance] capturePhoto];
}

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error{
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] startUpdateLocation];
    }else{
    
        [self showPrivacyHelperForType:DBPrivacyTypeLocation controller:^(DBPrivateHelperController *vc) {
        } didPresent:^{
        } didDismiss:^{
            if([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)[self showPrivacyHelperForType:DBPrivacyTypeLocation];
        } useDefaultSettingPane:NO];

    }
    
    UIImage *image = [UIImage imageWithData:[photoDict objectForKey:@"PBJVisionPhotoJPEGKey"]];
    image = [self squareImageWithImage:image scaledToSize:image.size.height>image.size.width?CGSizeMake(image.size.width, image.size.width):CGSizeMake(image.size.height, image.size.height)];
    
    NSData* data = UIImageJPEGRepresentation(image, 0.2f);
    
    if ([PFUser currentUser][@"photo"]) {
        PFObject *photo = [PFObject objectWithClassName:@"Photos"];
        photo[@"user"] = [PFUser currentUser];
        photo[@"photo"] = [PFUser currentUser][@"photo"];
        [photo saveInBackground];
    }
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
    
    [[PFUser currentUser]setObject:imageFile forKey:@"photo"];
    [[PFUser currentUser] saveInBackground];
    
    
    
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] revealVC] setFrontViewController:[[ezOnlineNavigationController alloc] init]];
}

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
