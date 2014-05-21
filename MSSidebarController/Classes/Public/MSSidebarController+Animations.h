//
//  MSSidebarController+Animations.h
//  MSSidebarController
//
//  Created by Nacho Soto on 4/24/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarController.h"

@interface MSSidebarController ()

/**
 * Set the preferred status bar style. Setting this causes the view controller's
 * `preferredStatusBarStyle` method to return the value given for `style`. To
 * cause this view controller to use the value for the current view controller,
 * use `setCurrentStatusBarStyleWithCurrentViewController`.
 *
 * @discussion This method internally calls `setNeedsStatusBarAppearanceUpdate`.
 *
 * @param style UIStatusBarStyle is the status bar style this view controller
 *      prefers.
 */
- (void)setCurrentStatusBarStyle:(UIStatusBarStyle)style;

/**
 * Use the result of calling `preferredStatusBarStyle` on the
 * `currentViewController` as the result of calling `preferredStatusBarStyle` on
 * this view controller. This overrides any call to `setCurrentStatusBarStyle:`.
 *
 * @discussion This method internally calls `setNeedsStatusBarAppearanceUpdate`.
 *      This should be called when the `currentViewController` changes,
 *      typically from inside of the animator blocks.
 */
- (void)setCurrentStatusBarStyleWithCurrentViewController;

/**
 * Set the preferred status bar visibility. Setting this causes the view
 * controller's `prefersStatusBarHidden` method to return the value given for
 * `hidden`. To cause this view controller to use the value for the current view
 * controller, use `setStatusBarVisibilityWithCurrentViewController`.
 *
 * @discussion This method internally calls `setNeedsStatusBarAppearanceUpdate`.
 *
 * @param hidden BOOL whether to prefer a hidden status bar.
 */
- (void)setStatusBarIsHidden:(BOOL)hidden;

/**
 * Use the result of calling `prefersStatusBarHidden` on the
 * `currentViewController` as the result of calling `prefersStatusBarHidden` on
 * this view controller. This overrides any call to `setStatusBarIsHidden:`.
 *
 * @discussion This method internally calls `setNeedsStatusBarAppearanceUpdate`.
 *      This should be called when the `currentViewController` changes,
 *      typically from inside of the animator blocks.
 */
- (void)setStatusBarVisibilityWithCurrentViewController;

@end
