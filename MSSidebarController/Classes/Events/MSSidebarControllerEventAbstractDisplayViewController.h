//
//  MSSidebarControllerEventAbstractDisplayViewController.h
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEvent.h"

@interface MSSidebarControllerEventAbstractDisplayViewController : MSSidebarControllerEvent

+ (instancetype)eventWithSidebarController:(MSSidebarController *)sidebarController
                                 menuState:(TKState *)menuState
                 hidingViewControllerState:(TKState *)hidingViewControllerState
             displayingViewControllerState:(TKState *)displayingViewControllerState
                           animatorFactory:(id<MSSidebarControllerAnimatorFactory>)animatorFactory;

/**
 * Must be implemented by subclasses.
 */
+ (TKState *)fromStateWithMenuState:(TKState *)menuState
          hidingViewControllerState:(TKState *)hidingViewControllerState;

@end
