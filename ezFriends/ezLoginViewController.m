//
//  ezLoginViewController.m
//  ezFriends
//
//  Created by Maciej Matuszewski on 26.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "ezLoginViewController.h"
#import "AppDelegate.h"

@interface ezLoginViewController ()<TTTAttributedLabelDelegate>

#define termsLink @"http://files.parsetfss.com/419f1201-a444-42a8-8a8f-4515af0387c1/tfss-a1786b3a-7603-49f9-a5e9-e9a66c789e7e-Terms.pdf"
#define privacyLink @"http://fotolab.co/politykaprywatnosci.pdf"

@end

@implementation ezLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"loginBackground"]]];

    
    UIImageView *logotype = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainLogo"]];
    [logotype setContentMode:UIViewContentModeCenter];
    logotype.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:logotype];
    
    NSTextAttachment *facebookLogo = [[NSTextAttachment alloc] init];
    facebookLogo.image = [UIImage imageNamed:@"facebookLogo"];
    NSMutableAttributedString *loginFacebookString= [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Log in via ", @"Welcome_view_button_log_in_via_facebook")];
    [loginFacebookString appendAttributedString:[NSAttributedString attributedStringWithAttachment:facebookLogo]];
    [loginFacebookString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [loginFacebookString length])];
    
    UIButton *facebookBtn = [[UIButton alloc] init];
    [facebookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [facebookBtn setAttributedTitle:loginFacebookString forState:UIControlStateNormal];
    [facebookBtn setBackgroundImage:[UIImage imageNamed:@"facebookButton"] forState:UIControlStateNormal];
    [facebookBtn addTarget:self action:@selector(facebookBtnAction) forControlEvents:UIControlEventTouchUpInside];
    facebookBtn.translatesAutoresizingMaskIntoConstraints = NO;
    facebookBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:facebookBtn];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"purpleButton"] forState:UIControlStateNormal];
    [loginBtn setTitle:NSLocalizedString(@"Log in", @"Welcome_view_button_log_in" ) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:loginBtn];
    
    UIButton *signinBtn = [[UIButton alloc] init];
    [signinBtn setBackgroundImage:[UIImage imageNamed:@"purpleButton"] forState:UIControlStateNormal];
    [signinBtn setTitle:NSLocalizedString(@"Sign in", @"Welcome_view_button_sign_in" ) forState:UIControlStateNormal];
    signinBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [signinBtn addTarget:self action:@selector(signinBtnAction) forControlEvents:UIControlEventTouchUpInside];
    signinBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:signinBtn];
    
    TTTAttributedLabel *bottomInfo = [[TTTAttributedLabel alloc] init];
    bottomInfo.font = [UIFont systemFontOfSize:10];
    bottomInfo.textColor = [UIColor whiteColor];
    bottomInfo.lineBreakMode = NSLineBreakByWordWrapping;
    bottomInfo.numberOfLines = 0;
    bottomInfo.textAlignment = NSTextAlignmentCenter;
    bottomInfo.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    bottomInfo.delegate = self;
    [bottomInfo setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    bottomInfo.linkAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                   NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleNone],NSFontAttributeName: [UIFont boldSystemFontOfSize:12] };
    bottomInfo.text = NSLocalizedString(@"Registration and use of the application is tantamount to\nacceptance of the terms and conditions and privacy policy", @"welcome_view_bottom_info");
    
    [bottomInfo addLinkToURL:[NSURL URLWithString:termsLink] withRange:[bottomInfo.text rangeOfString:NSLocalizedString(@"terms and conditions", @"welcome_view_bottom_info_terms_and_conditions")]];
    
    [bottomInfo addLinkToURL:[NSURL URLWithString:privacyLink] withRange:[bottomInfo.text rangeOfString:NSLocalizedString(@"privacy policy", @"welcome_view_bottom_info_privacy_policy")]];
    
    [self.view addSubview:bottomInfo];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:logotype attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=25)-[logotype]-(>=10)-[facebookBtn]-[loginBtn]-[signinBtn]-(==15)-[bottomInfo]-(==10)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"logotype" : logotype, @"facebookBtn" : facebookBtn, @"loginBtn" : loginBtn, @"signinBtn" : signinBtn, @"bottomInfo" : bottomInfo}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomInfo]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"bottomInfo" : bottomInfo}]];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    
    [[UIApplication sharedApplication] openURL:url];
}

- (void)facebookBtnAction{
    [PFFacebookUtils logInWithPermissions:@[@"public_profile"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            
            if (FBSession.activeSession.isOpen) {
                [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *userFB, NSError *error) {
                    if (!error) {
                        [[PFUser currentUser] setObject:[userFB objectForKey:@"email"] forKey:@"email"];
                        
                        [[PFUser currentUser] setObject:[userFB objectForKey:@"first_name"] forKey:@"name"];
                        [[PFUser currentUser] setObject:[userFB objectForKey:@"gender"] forKey:@"gender"];
                        
                        NSDateFormatter* myFormatter = [[NSDateFormatter alloc] init];
                        [myFormatter setDateFormat:@"MM/dd/yyyy"];
                        
                        [[PFUser currentUser] setObject:[NSNumber numberWithInt:(int)[[[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[myFormatter dateFromString:[userFB objectForKey:@"birthday"]]] year]] forKey:@"birthday"];
                        [[PFUser currentUser] saveInBackground];
                    }
                }];
            }

            
            [self.navigationController pushViewController:[[ezRegisterSelectMinMaxAgeViewController alloc] init] animated:YES];
            
        } else {
            
            
            AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            ad.revealVC = [[SWRevealViewController alloc] initWithRearViewController:[[ezMenuViewController alloc] init] frontViewController:[[ezButtonViewController alloc] init]];
            ad.revealVC.delegate = ad;
            ad.revealVC.bounceBackOnOverdraw=NO;
            ad.revealVC.stableDragOnOverdraw=NO;
            [ad.revealVC setRearViewRevealOverdraw:5];
            [self.navigationController pushViewController:ad.revealVC animated:YES];


        }
    }];
}


- (void)loginBtnAction{
    
    [self.navigationController pushViewController:[[ezLoginWithFieldsViewController alloc] init] animated:YES];
    
}

- (void)signinBtnAction{
}


@end
