//
//  MSSidebarAnimations.h
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

@class MSSidebarController;

@protocol MSSidebarDisplayViewControllerAnimator <NSObject>

- (void)sidebarController:(MSSidebarController *)sidebarController
willDisplayViewController:(UIViewController *)newViewController
          completionBlock:(void (^)(void))completionBlock;

@end

@protocol MSSidebarDisplayMenuAnimator <NSObject>

- (void)sidebarController:(MSSidebarController *)sidebarController
willDismissViewController:(UIViewController *)currentViewController
           andDisplayMenu:(UIViewController *)menuController
          completionBlock:(void (^)(void))completionBlock;

@end

@protocol MSSidebarHideViewControllerAnimator <NSObject>

- (void)sidebarController:(MSSidebarController *)sidebarController
   willHideViewController:(UIViewController *)currentViewController
  toShowNewViewController:(UIViewController *)newViewController
          completionBlock:(void (^)(void))completionBlock;

@end

@protocol MSSidebarControllerAnimatorFactory <NSObject>

- (id<MSSidebarDisplayViewControllerAnimator>)createDisplayViewControllerAnimatorForSidebarController:(MSSidebarController *)sidebarController;
- (id<MSSidebarDisplayMenuAnimator>)createDisplayMenuAnimatorForSidebarController:(MSSidebarController *)sidebarController;
- (id<MSSidebarHideViewControllerAnimator>)createHideViewControllerAnimatorForSidebarController:(MSSidebarController *)sidebarController;

@end
