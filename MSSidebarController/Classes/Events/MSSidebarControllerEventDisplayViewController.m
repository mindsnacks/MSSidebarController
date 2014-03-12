//
//  MSSidebarControllerEventDisplayViewController.m
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEventDisplayViewController.h"
#import "MSSidebarControllerEvent+Protected.h"

#import "UIViewController+MSSidebarController.h"

#import "MSSidebarControllerEventViewControllerDisplayed.h"

@interface MSSidebarControllerEventDisplayViewController ()

@property (nonatomic) id<MSSidebarDisplayViewControllerAnimator> animator;

@end

@implementation MSSidebarControllerEventDisplayViewController

+ (instancetype)eventWithSidebarController:(MSSidebarController *)sidebarController
                                 menuState:(TKState *)menuState
                 hidingViewControllerState:(TKState *)hidingViewControllerState
             displayingViewControllerState:(TKState *)displayingViewControllerState
                                  animator:(id<MSSidebarDisplayViewControllerAnimator>)animator {
    NSParameterAssert(menuState);
    NSParameterAssert(hidingViewControllerState);
    NSParameterAssert(displayingViewControllerState);
    NSParameterAssert(animator);
    
    MSSidebarControllerEventDisplayViewController *event = [self eventWithSidebarController:sidebarController
                                                                    transitioningFromStates:@[menuState, hidingViewControllerState]
                                                                                    toState:displayingViewControllerState];
    
    event.animator = animator;
    
    return event;
}

+ (NSString *)eventName {
    return @"display_vc";
}

#pragma mark -

- (void)eventWillFireWithTransition:(TKTransition *)transition
                  sidebarController:(MSSidebarController *)sidebarController {
    UIViewController *vc = transition.userInfoViewController;
    vc.sidebarController = sidebarController;
    
    [sidebarController.menuViewController willMoveToParentViewController:nil];
    
    [self.animator sidebarController:sidebarController
           willDisplayViewController:vc
                     completionBlock:^{
                         [sidebarController fireEvent:MSSidebarControllerEventViewControllerDisplayed.eventName
                                   withViewController:vc
                                  viewControllerIsNew:transition.viewControllerIsNew];
                     }];
}

@end
