//
//  ezRegisterWomenOrMenViewController.m
//  ezFriends
//
//  Created by Maciej Matuszewski on 26.02.2015.
//  Copyright (c) 2015 Maciej Matuszewski. All rights reserved.
//

#import "ezRegisterWomenOrMenViewController.h"
#import "AppDelegate.h"

@interface ezRegisterWomenOrMenViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) UIPickerView *picker;

@end

@implementation ezRegisterWomenOrMenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor]];

    UILabel *question = [[ UILabel alloc] init];
    [question setTranslatesAutoresizingMaskIntoConstraints:NO];
    [question setText:NSLocalizedString(@"Do You prefer\nwomen or men?", @"question_women_or_men")];
    [question setTextColor:[UIColor whiteColor]];
    [question setFont:[UIFont italicSystemFontOfSize:30]];
    [question setLineBreakMode:NSLineBreakByWordWrapping];
    [question setNumberOfLines:0];
    [question setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:question];
    
    self.picker= [[UIPickerView alloc] init];
    [self.picker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.picker setDelegate:self];
    [self.picker setDataSource:self];
    [self.view addSubview:self.picker];
    
    if([[[PFUser currentUser] objectForKey:@"gender"] isEqualToString:@"female"])[self.picker selectRow:1 inComponent:0 animated:NO];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"whiteButton"] forState:UIControlStateNormal];
    [nextBtn setTitle:NSLocalizedString(@"Next", @"Register_view_button_next" ) forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [nextBtn setTitleColor:[(AppDelegate *)[[UIApplication sharedApplication] delegate] ezColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:nextBtn];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:nextBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==80)-[question]-(>=10)-[picker]-(==30)-[nextBtn]-(==10)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"nextBtn" : nextBtn, @"question" : question, @"picker" : self.picker}]];
    
}

- (void)nextBtnAction{
    switch ([self.picker selectedRowInComponent:0]) {
        case 0:
            [[PFUser currentUser] setObject:[NSNumber numberWithBool:YES] forKey:@"women"];
            [[PFUser currentUser] setObject:[NSNumber numberWithBool:NO] forKey:@"men"];
            break;
            
        case 1:
            [[PFUser currentUser] setObject:[NSNumber numberWithBool:NO] forKey:@"women"];
            [[PFUser currentUser] setObject:[NSNumber numberWithBool:YES] forKey:@"men"];
            break;
            
        case 2:
            [[PFUser currentUser] setObject:[NSNumber numberWithBool:YES] forKey:@"women"];
            [[PFUser currentUser] setObject:[NSNumber numberWithBool:YES] forKey:@"men"];
            break;
            
        default:
            break;
    }
    [[PFUser currentUser] saveInBackground];
    
    AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.revealVC = [[SWRevealViewController alloc] initWithRearViewController:[[ezMenuViewController alloc] init] frontViewController:[[ezButtonViewController alloc] init]];
    ad.revealVC.delegate = ad;
    ad.revealVC.bounceBackOnOverdraw=NO;
    ad.revealVC.stableDragOnOverdraw=NO;
    [ad.revealVC setRearViewRevealOverdraw:5];
    [self.navigationController pushViewController:ad.revealVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *title;
    switch (row) {
        case 0:
            title = NSLocalizedString(@"Women", @"Register_women");
            break;
        case 1:
            title = NSLocalizedString(@"Men", @"Register_men");
            break;
        case 2:
            title = NSLocalizedString(@"Both", @"Register_both");
            break;
            
        default:
            break;
    }
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

@end
