//
//  MSSidebarControllerEventHideViewController.m
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEventHideViewController.h"
#import "MSSidebarControllerEvent+Protected.h"

#import "MSSidebarControllerEventDisplayViewController.h"

@interface MSSidebarControllerEventHideViewController ()

@property (nonatomic) id<MSSidebarControllerAnimatorFactory> animatorFactory;

@end

@implementation MSSidebarControllerEventHideViewController

+ (instancetype)eventWithSidebarController:(MSSidebarController *)sidebarController
                                 menuState:(TKState *)menuState
                 hidingViewControllerState:(TKState *)hidingVCState
                           animatorFactory:(id<MSSidebarControllerAnimatorFactory>)animatorFactory {
    NSParameterAssert(menuState);
    NSParameterAssert(hidingVCState);
    NSParameterAssert(animatorFactory);
    
    MSSidebarControllerEventHideViewController *event = [self eventWithSidebarController:sidebarController
                                                                 transitioningFromStates:@[menuState]
                                                                                 toState:hidingVCState];
    event.animatorFactory = animatorFactory;
    
    return event;
}

+ (NSString *)eventName {
    return @"hide_vc";
}

#pragma mark -

- (void)eventWillFireWithTransition:(TKTransition *)transition
                  sidebarController:(MSSidebarController *)sidebarController {
    [sidebarController.currentViewController willMoveToParentViewController:nil];
}

- (void)eventDidFireWithTransition:(TKTransition *)transition
                 sidebarController:(MSSidebarController *)sidebarController {
    UIViewController *currentVC = sidebarController.currentViewController,
                     *newVC = transition.userInfoViewController;
    
    [[self.animatorFactory createHideViewControllerAnimatorForSidebarController:sidebarController] sidebarController:sidebarController
                                                                                              willHideViewController:currentVC
                                                                                             toShowNewViewController:newVC
                                                                                                     completionBlock:^
     {
         [currentVC.view removeFromSuperview];
         [currentVC removeFromParentViewController];
         
         [sidebarController addChildViewController:newVC];
         [sidebarController.view addSubview:newVC.view];
         
         [sidebarController fireEvent:MSSidebarControllerEventDisplayViewController.eventName
                   withViewController:newVC
                  viewControllerIsNew:transition.viewControllerIsNew];
     }];
}

@end
