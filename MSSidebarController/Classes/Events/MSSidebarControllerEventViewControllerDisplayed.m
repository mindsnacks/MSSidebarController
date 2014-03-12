//
//  MSSidebarControllerEventViewControllerDisplayed.m
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEventViewControllerDisplayed.h"
#import "MSSidebarControllerEvent+Protected.h"

@implementation MSSidebarControllerEventViewControllerDisplayed

+ (instancetype)eventWithSidebarController:(MSSidebarController *)sidebarController
             displayingViewControllerState:(TKEvent *)displayingVCState
                       viewControllerState:(TKEvent *)vcState {
    NSParameterAssert(displayingVCState);
    NSParameterAssert(vcState);
    
    MSSidebarControllerEventViewControllerDisplayed *event = [self eventWithSidebarController:sidebarController
                                                                      transitioningFromStates:@[displayingVCState]
                                                                                      toState:vcState];
    
    return event;
}

+ (NSString *)eventName {
    return @"vc_displayed";
}

#pragma mark -

- (void)eventWillFireWithTransition:(TKTransition *)transition
                  sidebarController:(MSSidebarController *)sidebarController {
    [sidebarController.menuViewController.view removeFromSuperview];
    [sidebarController.menuViewController removeFromParentViewController];
}

- (void)eventDidFireWithTransition:(TKTransition *)transition
                 sidebarController:(MSSidebarController *)sidebarController {
    UIViewController *vc = transition.userInfoViewController;
    
    if (transition.viewControllerIsNew) {
        [vc didMoveToParentViewController:sidebarController];
    }
    
    vc.view.userInteractionEnabled = YES;
    sidebarController.currentViewController = vc;
}

@end
