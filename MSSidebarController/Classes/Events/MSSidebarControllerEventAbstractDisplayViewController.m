//
//  MSSidebarControllerEventAbstractDisplayViewController.m
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEventAbstractDisplayViewController.h"
#import "MSSidebarControllerEvent+Protected.h"

#import "UIViewController+MSSidebarController.h"

#import "MSSidebarControllerEventViewControllerDisplayed.h"

@interface MSSidebarControllerEventAbstractDisplayViewController () {
    id<MSSidebarDisplayViewControllerAnimator> _animator;
}

@property (nonatomic) id<MSSidebarControllerAnimatorFactory> animatorFactory;

@end

@implementation MSSidebarControllerEventAbstractDisplayViewController

+ (instancetype)eventWithSidebarController:(MSSidebarController *)sidebarController
                                 menuState:(TKState *)menuState
                 hidingViewControllerState:(TKState *)hidingViewControllerState
             displayingViewControllerState:(TKState *)displayingViewControllerState
                           animatorFactory:(id<MSSidebarControllerAnimatorFactory>)animatorFactory {
    NSParameterAssert(menuState);
    NSParameterAssert(hidingViewControllerState);
    NSParameterAssert(displayingViewControllerState);
    NSParameterAssert(animatorFactory);
    
    MSSidebarControllerEventAbstractDisplayViewController *event = [self eventWithSidebarController:sidebarController
                                                                            transitioningFromStates:@[[self.class fromStateWithMenuState:menuState
                                                                                                             hidingViewControllerState:hidingViewControllerState]]
                                                                                            toState:displayingViewControllerState];
    
    event.animatorFactory = animatorFactory;
    
    return event;
}

#pragma mark -

+ (TKState *)fromStateWithMenuState:(TKState *)menuState
          hidingViewControllerState:(TKState *)hidingViewControllerState {
    [self doesNotRecognizeSelector:_cmd];
    
    return nil;
}

#pragma mark -

- (void)eventWillFireWithTransition:(TKTransition *)transition
                  sidebarController:(MSSidebarController *)sidebarController {
    UIViewController *vc = transition.userInfoViewController;
    vc.sidebarController = sidebarController;
    
    sidebarController.currentViewController = vc;
    [sidebarController.menuViewController willMoveToParentViewController:nil];
    
    _animator = [self.animatorFactory createDisplayViewControllerAnimatorForSidebarController:sidebarController];
    [_animator sidebarController:sidebarController
       willDisplayViewController:vc
                 completionBlock:^
     {
         _animator = nil;
         
         [sidebarController fireEvent:MSSidebarControllerEventViewControllerDisplayed.eventName
                   withViewController:vc
                  viewControllerIsNew:transition.viewControllerIsNew];
     }];
}

@end
