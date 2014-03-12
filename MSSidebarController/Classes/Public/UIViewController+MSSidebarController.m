//
//  UIViewController+MSSidebarController.m
//  MSSidebarController
//
//  Created by Nacho Soto on 3/11/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "UIViewController+MSSidebarController.h"
#import "MSSidebarController.h"

#import <objc/runtime.h>

@implementation UIViewController (MSSidebarController)

static char *sidebarControllerKey;

- (void)setSidebarController:(MSSidebarController *)sidebarController {
    objc_setAssociatedObject(self, &sidebarControllerKey, sidebarController, OBJC_ASSOCIATION_ASSIGN);
}

- (MSSidebarController *)sidebarController {
    return (MSSidebarController *)objc_getAssociatedObject(self, &sidebarControllerKey) ?: self.parentViewController.sidebarController;
}

@end
