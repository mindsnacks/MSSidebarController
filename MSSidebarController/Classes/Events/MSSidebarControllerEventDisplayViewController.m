//
//  MSSidebarControllerEventDisplayViewController.m
//  MSSidebarController
//
//  Created by Nacho Soto on 8/21/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEventDisplayViewController.h"

@implementation MSSidebarControllerEventDisplayViewController

+ (NSString *)eventName {
    return @"display_vc";
}

+ (TKState *)fromStateWithMenuState:(TKState *)menuState
          hidingViewControllerState:(TKState *)hidingViewControllerState {
    return hidingViewControllerState;
}

@end
