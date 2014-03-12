//
//  MSSidebarControllerEventMenuDisplayed.h
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEvent.h"

@interface MSSidebarControllerEventMenuDisplayed : MSSidebarControllerEvent

+ (instancetype)eventWithSidebarController:(MSSidebarController *)sidebarController
                       displayingMenuState:(TKState *)displayingMenuState
                                 menuState:(TKState *)menuState;

@end
