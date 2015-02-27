//
//  Animator.m
//  NavigationTransitionTest
//
//  Created by Maciej Matuszewski on 13.11.2014.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

#import "Animator.h"

@implementation Animator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.transform = CGAffineTransformMakeTranslation(toViewController.view.frame.size.width, 0);
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
        
        fromViewController.view.transform = CGAffineTransformMakeTranslation(-toViewController.view.frame.size.width, 0);
        
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        fromViewController.view.alpha = 1;
        
    }];
}

@end
