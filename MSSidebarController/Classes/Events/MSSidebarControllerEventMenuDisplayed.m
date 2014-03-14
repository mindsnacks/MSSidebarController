//
//  MSSidebarControllerEventMenuDisplayed.m
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEventMenuDisplayed.h"
#import "MSSidebarControllerEvent+Protected.h"

@implementation MSSidebarControllerEventMenuDisplayed

+ (instancetype)eventWithSidebarController:(MSSidebarController *)sidebarController
                       displayingMenuState:(TKState *)displayingMenuState
                                 menuState:(TKState *)menuState {
    return [self eventWithSidebarController:sidebarController
                    transitioningFromStates:@[displayingMenuState]
                                    toState:menuState];
}

+ (NSString *)eventName {
    return @"menu";
}

#pragma mark -

- (void)eventDidFireWithTransition:(TKTransition *)transition
                 sidebarController:(MSSidebarController *)sidebarController {
    [sidebarController.menuViewController didMoveToParentViewController:sidebarController];
    
    [sidebarController setNeedsStatusBarAppearanceUpdate];
}

@end
