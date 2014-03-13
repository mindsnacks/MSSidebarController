//
//  MSSidebarControllerEventDisplayMenu.m
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEventDisplayMenu.h"
#import "MSSidebarControllerEvent+Protected.h"

#import "MSSidebarControllerEventMenuDisplayed.h"

@interface MSSidebarControllerEventDisplayMenu () {
    id<MSSidebarDisplayMenuAnimator> _animator;
}

@property (nonatomic) id<MSSidebarControllerAnimatorFactory> animatorFactory;

@end

@implementation MSSidebarControllerEventDisplayMenu

+ (instancetype)eventWithSidebarController:(MSSidebarController *)sidebarController
                       viewControllerState:(TKState *)vcState
                       displayingMenuState:(TKState *)displayingMenuState
                           animatorFactory:(id<MSSidebarControllerAnimatorFactory>)animatorFactory {
    NSParameterAssert(vcState);
    NSParameterAssert(displayingMenuState);
    NSParameterAssert(animatorFactory);
    
    MSSidebarControllerEventDisplayMenu *event = [self eventWithSidebarController:sidebarController
                                                          transitioningFromStates:@[vcState]
                                                                          toState:displayingMenuState];
    event.animatorFactory = animatorFactory;
    
    return event;
}

+ (NSString *)eventName {
    return @"display_menu";
}

#pragma mark -

- (void)eventWillFireWithTransition:(TKTransition *)transition
                  sidebarController:(MSSidebarController *)sidebarController {
    UIViewController *menuViewController = sidebarController.menuViewController,
                     *currentViewController = sidebarController.currentViewController;
    
    [sidebarController addChildViewController:menuViewController];
    [sidebarController.view insertSubview:menuViewController.view
                                  atIndex:0];
    
    currentViewController.view.userInteractionEnabled = NO;
    
    _animator = [self.animatorFactory createDisplayMenuAnimatorForSidebarController:sidebarController];
    [_animator sidebarController:sidebarController
       willDismissViewController:currentViewController
                  andDisplayMenu:menuViewController
                 completionBlock:^
     {
         _animator = nil;
         [sidebarController fireEvent:MSSidebarControllerEventMenuDisplayed.eventName];
     }];
}

@end
