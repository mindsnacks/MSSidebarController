//
//  MSSidebarControllerEvent.h
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import <TransitionKit/TKEvent.h>
#import <TransitionKit/TKState.h>
#import "MSSidebarAnimations.h"

@class TKState;

/**
 * @see `MSSidebarControllerEvent+Protected.h`
 */
@interface MSSidebarControllerEvent : TKEvent

/**
 * @discussion must be overriden by subclasses.
 */
+ (NSString *)eventName;

@end
