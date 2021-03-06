//
//  MSSidebarController.m
//  MSSidebarController
//
//  Created by Nacho Soto on 3/11/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarController.h"

#import "MSSidebarController+Internal.h"
#import "MSSidebarController+Animations.h"
#import "UIViewController+MSSidebarController.h"

#import <TransitionKit/TransitionKit.h>
#import <libextobjc/EXTScope.h>

#import "MSSidebarControllerEventDisplayViewController.h"
#import "MSSidebarControllerEventRestoreViewController.h"
#import "MSSidebarControllerEventViewControllerDisplayed.h"
#import "MSSidebarControllerEventDisplayMenu.h"
#import "MSSidebarControllerEventMenuDisplayed.h"
#import "MSSidebarControllerEventHideViewController.h"

static NSString * const kMSSidebarControllerEventViewControllerKey = @"vc";
static NSString * const kMSSidebarControllerEventViewControllerIsNewKey = @"is_new";

static NSString * const kStateMenu              = @"menu";
static NSString * const kStateVC                = @"vc";
static NSString * const kStateDisplayingVC      = @"displaying_vc";
static NSString * const kStateHidingVC          = @"hiding_vc";
static NSString * const kStateDisplayingMenu    = @"displaying_menu";

@interface MSSidebarFilterView : UIView

@property (nonatomic, weak) MSSidebarController *sidebarController;

@end

@interface MSSidebarController ()
{
    UIViewController *_menu;
    UIViewController *_current;
    
    TKStateMachine *_stateMachine;
    
    UIStatusBarStyle _currentStatusBarStyle;
    BOOL _currentStyleDependsOnCurrentVC;

    BOOL _statusBarIsHidden;
    BOOL _statusBarVisibilityDependsOnCurrentVC;
}

@end

@implementation MSSidebarController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithMenuViewController:nil
                       activeViewController:nil
                            animatorFactory:nil];
}

- (instancetype)initWithMenuViewController:(UIViewController *)menuVC
                      activeViewController:(UIViewController *)activeVC
                           animatorFactory:(id<MSSidebarControllerAnimatorFactory>)animatorFactory {
    NSParameterAssert(menuVC);
    NSParameterAssert(activeVC);
    
    NSParameterAssert(animatorFactory);
    
    if ((self = [super initWithNibName:nil bundle:nil])) {
        [self setUpStateMachineWithAnimatorFactory:animatorFactory];
        
        _menu = menuVC;
        _current = activeVC;
        
        menuVC.sidebarController = self;
        activeVC.sidebarController = self;
        
        _currentStyleDependsOnCurrentVC = YES;

        _statusBarVisibilityDependsOnCurrentVC = YES;
    }
    
    return self;
}

- (void)setUpStateMachineWithAnimatorFactory:(id<MSSidebarControllerAnimatorFactory>)animatorFactory {
    _stateMachine = TKStateMachine.new;
    
    TKState *menuState              = [TKState stateWithName:kStateMenu];
    TKState *vcState                = [TKState stateWithName:kStateVC];
    TKState *displayingVCState      = [TKState stateWithName:kStateDisplayingVC];
    TKState *hidingVCState          = [TKState stateWithName:kStateHidingVC];
    TKState *displayingMenuState    = [TKState stateWithName:kStateDisplayingMenu];
    
    [_stateMachine addStates:@[menuState,
                               vcState,
                               displayingVCState,
                               hidingVCState,
                               displayingMenuState]];
    _stateMachine.initialState = vcState;
    
    TKEvent *displayVCEvent = [MSSidebarControllerEventDisplayViewController eventWithSidebarController:self
                                                                                              menuState:menuState
                                                                              hidingViewControllerState:hidingVCState
                                                                          displayingViewControllerState:displayingVCState
                                                                                        animatorFactory:animatorFactory];
    TKEvent *restoreVCEvent = [MSSidebarControllerEventRestoreViewController eventWithSidebarController:self
                                                                                              menuState:menuState
                                                                              hidingViewControllerState:hidingVCState
                                                                          displayingViewControllerState:displayingVCState
                                                                                        animatorFactory:animatorFactory];
    TKEvent *vcDisplayedEvent = [MSSidebarControllerEventViewControllerDisplayed eventWithSidebarController:self
                                                                              displayingViewControllerState:displayingVCState
                                                                                        viewControllerState:vcState];
    TKEvent *displayMenuEvent = [MSSidebarControllerEventDisplayMenu eventWithSidebarController:self
                                                                            viewControllerState:vcState
                                                                            displayingMenuState:displayingMenuState
                                                                                animatorFactory:animatorFactory];
    TKEvent *menuDisplayedEvent = [MSSidebarControllerEventMenuDisplayed eventWithSidebarController:self
                                                                                displayingMenuState:displayingMenuState
                                                                                          menuState:menuState];
    TKEvent *hideVCEvent = [MSSidebarControllerEventHideViewController eventWithSidebarController:self
                                                                                        menuState:menuState
                                                                        hidingViewControllerState:hidingVCState
                                                                                  animatorFactory:animatorFactory];
    
    [_stateMachine addEvents:@[displayVCEvent,
                               restoreVCEvent,
                               vcDisplayedEvent,
                               displayMenuEvent,
                               menuDisplayedEvent,
                               hideVCEvent]];
    
    [_stateMachine activate];
}

- (TKStateMachine *)stateMachine {
    return _stateMachine;
}

#pragma mark -

- (void)loadView {
    MSSidebarFilterView *view = [[MSSidebarFilterView alloc] initWithFrame:UIScreen.mainScreen.applicationFrame];
    view.sidebarController = self;
    
    self.view = view;

    _current.view.frame = self.view.bounds;
    
    [self addChildViewController:_current];
    [self.view addSubview:_current.view];
    [_current didMoveToParentViewController:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _menu.view.frame = self.view.bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return (_currentStyleDependsOnCurrentVC) ? self.currentViewController.preferredStatusBarStyle : _currentStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
    return (_statusBarVisibilityDependsOnCurrentVC) ? self.currentViewController.prefersStatusBarHidden : _statusBarIsHidden;
}

#pragma mark - public

- (UIViewController *)menuViewController {
    return _menu;
}

- (UIViewController *)currentViewController {
    return _current;
}

- (void)showMenu {
    [self fireEvent:MSSidebarControllerEventDisplayMenu.eventName];
}

- (void)restoreLastViewController {
    [self fireEvent:MSSidebarControllerEventRestoreViewController.eventName
 withViewController:_current
viewControllerIsNew:NO];
}

- (void)showViewController:(UIViewController *)vc {
    NSParameterAssert(vc);
    
    if (vc == _current) {
        [self restoreLastViewController];
    } else {
        [self fireEvent:MSSidebarControllerEventHideViewController.eventName
     withViewController:vc
    viewControllerIsNew:YES];
    }
}

#pragma mark - internal

- (BOOL)fireEvent:(id)eventOrEventName {
    return [self fireEvent:eventOrEventName withInfo:nil];
}

- (BOOL)fireEvent:(id)eventOrEventName
withViewController:(UIViewController *)viewController
viewControllerIsNew:(BOOL)vcIsNew {
    NSParameterAssert(viewController);
    
    return [self fireEvent:eventOrEventName
                  withInfo:@{
                             kMSSidebarControllerEventViewControllerKey: viewController,
                             kMSSidebarControllerEventViewControllerIsNewKey: @(vcIsNew)
                             }];
}

- (BOOL)fireEvent:(id)eventOrEventName
         withInfo:(NSDictionary *)info {
    NSParameterAssert(eventOrEventName);
    
    return [_stateMachine fireEvent:eventOrEventName
                           userInfo:info
                              error:nil];
}

#pragma mark -

- (void)setCurrentViewController:(UIViewController *)viewController {
    NSParameterAssert(viewController);
    
    _current = viewController;
}

- (void)setCurrentStatusBarStyle:(UIStatusBarStyle)style {
    _currentStatusBarStyle = style;
    _currentStyleDependsOnCurrentVC = NO;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setCurrentStatusBarStyleWithCurrentViewController {
    _currentStyleDependsOnCurrentVC = YES;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarIsHidden:(BOOL)hidden {
    _statusBarIsHidden = hidden;
    _statusBarVisibilityDependsOnCurrentVC = NO;

    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarVisibilityWithCurrentViewController {
    _statusBarVisibilityDependsOnCurrentVC = YES;

    [self setNeedsStatusBarAppearanceUpdate];
}

@end

@implementation TKTransition (MSSidebarController)

- (UIViewController *)userInfoViewController {
    return self.userInfo[kMSSidebarControllerEventViewControllerKey];
}

- (BOOL)viewControllerIsNew {
    return [self.userInfo[kMSSidebarControllerEventViewControllerIsNewKey] boolValue];
}

@end

@implementation MSSidebarFilterView

- (BOOL)pointInside:(CGPoint)point
          withEvent:(UIEvent *)event {
    const MSSidebarController *sidebarController = self.sidebarController;

    // If we are not in the menu state, use the super implementation
    if (![sidebarController.stateMachine.currentState.name isEqualToString:kStateMenu]) {
        return [super pointInside:point withEvent:event];
    }

    NSArray * const sidebarSubviews = sidebarController.view.subviews;
    UIView * const currentView = sidebarController.currentViewController.view;
    UIView * const menuView = sidebarController.menuViewController.view;

    // Restore the last view controller if:
    // - the touch is in the current view and the menu is behind the current view
    // - the touch is not in the menu view and the menu is in front of the current view
    const BOOL currentViewTouch = [currentView pointInside:[self convertPoint:point toView:currentView] withEvent:event];
    const BOOL menuViewTouch = [menuView pointInside:[self convertPoint:point toView:menuView] withEvent:event];

    const NSUInteger menuViewIndex = [sidebarSubviews indexOfObject:menuView];
    const NSUInteger currentViewIndex = [sidebarSubviews indexOfObject:currentView];
    NSAssert(menuViewIndex != NSNotFound, @"The menu view is required to be a subview of the sidebar controller.");
    NSAssert(currentViewIndex != NSNotFound, @"The current view is required to be a subview of the sidebar controller.");

    const BOOL menuIsInFront = menuViewIndex > currentViewIndex;

    const BOOL restoreLastVC = (menuIsInFront) ? !menuViewTouch : currentViewTouch;

    if (restoreLastVC) {
        [sidebarController restoreLastViewController];
    }
    
    return !restoreLastVC;
}

@end