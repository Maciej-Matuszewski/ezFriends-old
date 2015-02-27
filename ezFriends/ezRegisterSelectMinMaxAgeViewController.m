//
//  ezRegisterSelectMinMaxAgeViewController.m
//  ezFriends
//
//  Created by Maciej Matuszewski on 26.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "ezRegisterSelectMinMaxAgeViewController.h"
#import "AppDelegate.h"

@interface ezRegisterSelectMinMaxAgeViewController ()

@property (nonatomic, retain) NMRangeSlider *slider;
@property (nonatomic, retain) UILabel *status;

@end

@implementation ezRegisterSelectMinMaxAgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *question = [[ UILabel alloc] init];
    [question setTranslatesAutoresizingMaskIntoConstraints:NO];
    [question setText:NSLocalizedString(@"Specify the age\nof new friends:", @"question_age")];
    [question setTextColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
    [question setFont:[UIFont italicSystemFontOfSize:30]];
    [question setLineBreakMode:NSLineBreakByWordWrapping];
    [question setNumberOfLines:0];
    [question setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:question];
    
    self.status = [[ UILabel alloc] init];
    [self.status setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.status setText:@"minimum: 18\nmaximum: 80"];
    [self.status setTextColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
    [self.status setFont:[UIFont systemFontOfSize:20]];
    [self.status setLineBreakMode:NSLineBreakByWordWrapping];
    [self.status setNumberOfLines:0];
    [self.status setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.status];

    
    self.slider = [[NMRangeSlider alloc] init];
    [self.slider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.slider setMaximumValue:62];
    [self.slider setTintColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];
    [self.slider setLowerHandleImageNormal:[UIImage imageNamed:@"sliderCircle"]];
    [self.slider setLowerHandleImageHighlighted:[UIImage imageNamed:@"sliderCircle"]];
    [self.slider setUpperHandleImageNormal:[UIImage imageNamed:@"sliderCircle"]];
    [self.slider setUpperHandleImageHighlighted:[UIImage imageNamed:@"sliderCircle"]];
    [self.view addSubview:self.slider];
    [self.slider setMinimumRange:5];
    [self.slider setUpperValue:62];
    [self.slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"purpleButton"] forState:UIControlStateNormal];
    [nextBtn setTitle:NSLocalizedString(@"Next", @"Register_view_button_next" ) forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:nextBtn];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:nextBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==80)-[question]-(>=10)-[status]-[slider]-(==70)-[nextBtn]-(==10)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"nextBtn" : nextBtn, @"question" : question, @"slider" : self.slider, @"status" : self.status}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[slider]-|" options:0 metrics:nil views:@{@"slider" : self.slider}]];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextBtnAction{
    
    
    [[PFUser currentUser] setObject:[NSNumber numberWithInt:(int)self.slider.lowerValue+18] forKey:@"minAge"];
    [[PFUser currentUser] setObject:[NSNumber numberWithInt:(int)self.slider.upperValue+18] forKey:@"maxAge"];
    
    [[PFUser currentUser] saveInBackground];
    
    
    [self.navigationController pushViewController:[[ezRegisterWomenOrMenViewController alloc] init] animated:YES];

}

- (void)sliderValueChanged{
    
    
    [self.status setText:[NSString stringWithFormat:@"minimum: %d\nmaximum: %d",(int)self.slider.lowerValue+18,(int)self.slider.upperValue+18]];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
