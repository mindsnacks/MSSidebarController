//
//  MSSidebarControllerEventRestoreViewController.m
//  MSSidebarController
//
//  Created by Nacho Soto on 8/21/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEventRestoreViewController.h"

@implementation MSSidebarControllerEventRestoreViewController

+ (NSString *)eventName {
    return @"restore_vc";
}

+ (TKState *)fromStateWithMenuState:(TKState *)menuState
          hidingViewControllerState:(TKState *)hidingViewControllerState {
    return menuState;
}

@end
