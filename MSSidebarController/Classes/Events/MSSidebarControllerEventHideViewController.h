//
//  MSSidebarControllerEventHideViewController.h
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEvent.h"

@interface MSSidebarControllerEventHideViewController : MSSidebarControllerEvent

+ (instancetype)eventWithSidebarController:(MSSidebarController *)sidebarController
                                 menuState:(TKState *)menuState
                 hidingViewControllerState:(TKState *)hidingVCState
                                  animator:(id<MSSidebarHideViewControllerAnimator>)animator;

@end
