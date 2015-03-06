//
//  ezLoginWithFieldsViewController.m
//  ezFriends
//
//  Created by Maciej Matuszewski on 03.03.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "ezLoginWithFieldsViewController.h"
#import "AppDelegate.h"

@interface ezLoginWithFieldsViewController ()

@property (nonatomic, retain) UIButton *loginBtn;
@property (nonatomic, retain) UITextField *emailField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UIImageView *logotype;
@property (nonatomic, strong) IBOutlet UIButton *passwordRemindBtn;
@property (nonatomic, strong) IBOutlet UIButton *registerBtn;

@end

@implementation ezLoginWithFieldsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"loginBackground"]]];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [backBtn setTintColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
    [backBtn setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==20)-[arrow]" options:0 metrics:nil views:@{@"arrow":backBtn}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==10)-[arrow]" options:0 metrics:nil views:@{@"arrow":backBtn}]];
    
    
    
    self.logotype = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainLogo"]];
    [self.logotype setContentMode:UIViewContentModeCenter];
    self.logotype.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.logotype];
    
    self.loginBtn = [[UIButton alloc] init];
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"purpleButton"] forState:UIControlStateNormal];
    [self.loginBtn setTitle:NSLocalizedString(@"Log in", @"Welcome_view_button_log_in" ) forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.loginBtn];
    
    self.emailField = [[UITextField alloc] init];
    [self.emailField setBackground:[UIImage imageNamed:@"whiteButton"]];
    [self.emailField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.emailField setTextAlignment:NSTextAlignmentCenter];
    [self.emailField setKeyboardType:UIKeyboardTypeEmailAddress];
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.emailField setPlaceholder:@"email"];
    [self.emailField setTextColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
    [self.emailField setTintColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
    [self.view addSubview:self.emailField];
    [self.emailField addTarget:self action:@selector(emailFieldEnd) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.passwordField = [[UITextField alloc] init];
    [self.passwordField setBackground:[UIImage imageNamed:@"whiteButton"]];
    [self.passwordField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.passwordField setTextAlignment:NSTextAlignmentCenter];
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.passwordField setPlaceholder:@"password"];
    [self.passwordField setSecureTextEntry:YES];
    [self.passwordField setTextColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
    [self.passwordField setTintColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
    [self.view addSubview:self.passwordField];
    [self.passwordField addTarget:self action:@selector(login) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    self.passwordRemindBtn = [[UIButton alloc] init];
    self.passwordRemindBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.passwordRemindBtn setTitle:NSLocalizedString(@"Remind password", @"Login_view_button_remind_password" ) forState:UIControlStateNormal];
    self.passwordRemindBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.passwordRemindBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.passwordRemindBtn];
    [self.passwordRemindBtn addTarget:self action:@selector(remindPasswordBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.registerBtn = [[UIButton alloc] init];
    self.registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.registerBtn setTitle:NSLocalizedString(@"Register", @"Login_view_button_register" ) forState:UIControlStateNormal];
    self.registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.registerBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.registerBtn];
    [self.registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=25)-[logotype]-(>=10)-[emailField(loginBtn)]-[passwordField(loginBtn)]-(==15)-[loginBtn]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"logotype" : self.logotype, @"emailField" : self.emailField, @"passwordField" : self.passwordField, @"loginBtn" : self.loginBtn}]];[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[loginBtn]-[passwordRemindBtn]-(==10)-|" options:0 metrics:nil views:@{@"loginBtn" : self.loginBtn, @"passwordRemindBtn" : self.passwordRemindBtn}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[item(loginBtn)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"item" : self.emailField, @"loginBtn" : self.loginBtn}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[item(loginBtn)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"item" : self.passwordField, @"loginBtn" : self.loginBtn}]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[itemL]-(>=0)-[itemR]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"itemL" : self.passwordRemindBtn, @"itemR" : self.registerBtn}]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tapAction{
    [self.view endEditing:YES];
}

- (void)keyboardChange:(NSNotification *)notification {
    
    UIViewAnimationCurve animationCurve;
    NSTimeInterval animationDuration;
    [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    [UIView beginAnimations:@"animate resiz view" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGFloat keyboardHeight = self.view.frame.size.height-[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([[UIScreen mainScreen] bounds].size.height > 480.0f) {
            
            [self.emailField setTransform:CGAffineTransformMakeTranslation(0, -keyboardHeight)];
            [self.passwordField setTransform:CGAffineTransformMakeTranslation(0, -keyboardHeight)];
            [self.loginBtn setTransform:CGAffineTransformMakeTranslation(0, -keyboardHeight)];
            //[self.logotype setTransform:CGAffineTransformMakeTranslation(0, -keyboardHeight)];
            [self.passwordRemindBtn setTransform:CGAffineTransformMakeTranslation(0, -keyboardHeight)];
            [self.registerBtn setTransform:CGAffineTransformMakeTranslation(0, -keyboardHeight)];
            
            
            if ([[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y==self.view.frame.size.height) {
                
                
                [self.logotype setTransform:CGAffineTransformTranslate(CGAffineTransformMakeScale(1.0, 1.0), 0, -keyboardHeight)];
                
                //[self.logotype setAlpha:1];
                //[self.label setAlpha:1];
            }else{
                
                if ([[UIScreen mainScreen] bounds].size.height <= 568.0f)[self.logotype setTransform:CGAffineTransformScale(CGAffineTransformMakeTranslation(0, -keyboardHeight+50), 0.4, 0.4)];
                else [self.logotype setTransform:CGAffineTransformScale(CGAffineTransformMakeTranslation(0, -keyboardHeight), 1.0, 1.0)];
                //[self.logotype setTransform:CGAffineTransformMakeScale(0.3, 0.3)];
                //if ([[UIScreen mainScreen] bounds].size.height <= 568.0f)[self.logotype setAlpha:0];
                //[self.label setAlpha:0];
            }
            
        } /*else {
            
            
            
            if ([[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y==self.view.frame.size.height) {
                [self.logotype setAlpha:1];
                [self.label setAlpha:1];
                [self.emailBackground setTransform:CGAffineTransformMakeTranslation(0, -keyboardHeight)];
                [self.passwordBackground setTransform:CGAffineTransformMakeTranslation(0, -keyboardHeight)];
                [self.loginBtn setTransform:CGAffineTransformMakeTranslation(0, -keyboardHeight)];
            }else{
                [self.logotype setAlpha:0];
                [self.label setAlpha:0];
                
                [self.emailBackground setTransform:CGAffineTransformMakeTranslation(0, -keyboardHeight+73)];
                [self.passwordBackground setTransform:CGAffineTransformMakeTranslation(0, -keyboardHeight+73)];
                [self.loginBtn setTransform:CGAffineTransformMakeTranslation(0, -keyboardHeight+73)];
            }
        }//*/
    }
    
    [UIView commitAnimations];
    
}


-(void)emailFieldEnd{
    [self.passwordField becomeFirstResponder];
}

-(void)login{
    [self.view endEditing:YES];
    [PFUser logInWithUsernameInBackground:self.emailField.text password:self.passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            
                                            [(AppDelegate *)[[UIApplication sharedApplication] delegate] registerPush];
                                            
                                            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                                            [currentInstallation setChannels:@[[NSString stringWithFormat:@"u_%@",user.objectId]]];
                                            [currentInstallation setObject:[PFUser currentUser] forKey:@"User"];
                                            [currentInstallation saveInBackground];
                                            [self.navigationController setViewControllers:@[[(AppDelegate *)[[UIApplication sharedApplication] delegate] revealVC]] animated:YES];
                                        } else {
                                            
                                            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Login_view_alert_error_title") message:NSLocalizedString(@"Wrong email and/or password!", @"Login_view_alert_error_message") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                                        }
                                    }];
}

-(void)remindPasswordBtnAction{
    //[self.navigationController pushViewController:[[FotolabForgotenPassViewController alloc] init] animated:YES];
}

- (void)registerBtnAction{
    //[self.navigationController pushViewController:[[FololabRegisterViewController alloc] init] animated:YES];
}

@end
