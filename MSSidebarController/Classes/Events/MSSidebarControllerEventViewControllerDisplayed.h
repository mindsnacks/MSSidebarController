//
//  MSSidebarControllerEventViewControllerDisplayed.h
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEvent.h"

@interface MSSidebarControllerEventViewControllerDisplayed : MSSidebarControllerEvent

+ (instancetype)eventWithSidebarController:(MSSidebarController *)sidebarController
             displayingViewControllerState:(TKState *)displayingVCState
                       viewControllerState:(TKState *)vcState;

@end
