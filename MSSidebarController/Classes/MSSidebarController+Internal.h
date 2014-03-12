//
//  MSSidebarController+Internal.h
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarController.h"

#import <TransitionKit/TKTransition.h>

@interface MSSidebarController ()

/**
 * @discussion fires event checking for errors.
 */
- (BOOL)fireEvent:(id)eventOrEventName;
- (BOOL)fireEvent:(id)eventOrEventName
withViewController:(UIViewController *)viewController
viewControllerIsNew:(BOOL)vcIsNew;

- (void)setCurrentViewController:(UIViewController *)viewController;

@end

@interface TKTransition (MSSidebarController)

- (UIViewController *)userInfoViewController;
- (BOOL)viewControllerIsNew;

@end