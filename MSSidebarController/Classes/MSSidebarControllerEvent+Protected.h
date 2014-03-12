//
//  MSSidebarControllerEvent+Protected.h
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEvent.h"
#import "MSSidebarController+Internal.h"

#import <TransitionKit/TKTransition.h>
#import <TransitionKit/TKStateMachine.h>

@class TKTransition;

@interface MSSidebarControllerEvent ()

/**
 * Will use `+eventName` as the name.
 */
+ (instancetype)eventWithSidebarController:(MSSidebarController *)sidebarController
                   transitioningFromStates:(NSArray *)sourceStates
                                   toState:(TKState *)destinationState;

/**
 * Can be overriden to perform custom actions.
 */
- (void)eventWillFireWithTransition:(TKTransition *)transition
                  sidebarController:(MSSidebarController *)sidebarController;
- (void)eventDidFireWithTransition:(TKTransition *)transition
                 sidebarController:(MSSidebarController *)sidebarController;

@end
