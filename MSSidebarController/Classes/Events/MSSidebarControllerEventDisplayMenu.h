//
//  MSSidebarControllerEventDisplayMenu.h
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEvent.h"

@interface MSSidebarControllerEventDisplayMenu : MSSidebarControllerEvent

+ (instancetype)eventWithSidebarController:(MSSidebarController *)sidebarController
                       viewControllerState:(TKState *)vcState
                       displayingMenuState:(TKState *)displayingMenuState
                           animatorFactory:(id<MSSidebarControllerAnimatorFactory>)animatorFactory;

@end
