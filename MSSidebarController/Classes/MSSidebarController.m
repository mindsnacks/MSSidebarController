//
//  MSSidebarController.m
//  MSSidebarController
//
//  Created by Nacho Soto on 3/11/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarController.h"

#import "MSSidebarController+Internal.h"
#import "UIViewController+MSSidebarController.h"

#import <TransitionKit/TransitionKit.h>
#import <libextobjc/EXTScope.h>

#import "MSSidebarControllerEventDisplayViewController.h"
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

@interface MSSidebarController () {
    UIViewController *_menu;
    UIViewController *_current;
    
    TKStateMachine *_stateMachine;
}

@end

@implementation MSSidebarController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithMenuViewController:nil
                       activeViewController:nil
              displayViewControllerAnimator:nil
                        displayMenuAnimator:nil
                 hideViewControllerAnimator:nil];
}

- (instancetype)initWithMenuViewController:(UIViewController *)menuVC
                      activeViewController:(UIViewController *)activeVC
             displayViewControllerAnimator:(id<MSSidebarDisplayViewControllerAnimator>)displayVCAnimator
                       displayMenuAnimator:(id<MSSidebarDisplayMenuAnimator>)displayMenuAnimator
                hideViewControllerAnimator:(id<MSSidebarHideViewControllerAnimator>)hideVCAnimator {
    NSParameterAssert(menuVC);
    NSParameterAssert(activeVC);
    
    NSParameterAssert(displayVCAnimator);
    NSParameterAssert(displayMenuAnimator);
    NSParameterAssert(hideVCAnimator);
    
    if ((self = [super initWithNibName:nil bundle:nil])) {
        [self setUpStateMachineWithDisplayViewControllerAnimator:displayVCAnimator
                                             displayMenuAnimator:displayMenuAnimator
                                      hideViewControllerAnimator:hideVCAnimator];
        
        _menu = menuVC;
        _current = activeVC;
        
        menuVC.sidebarController = self;
        activeVC.sidebarController = self;
    }
    
    return self;
}

- (void)setUpStateMachineWithDisplayViewControllerAnimator:(id<MSSidebarDisplayViewControllerAnimator>)displayVCAnimator
                                       displayMenuAnimator:(id<MSSidebarDisplayMenuAnimator>)displayMenuAnimator
                                hideViewControllerAnimator:(id<MSSidebarHideViewControllerAnimator>)hideVCAnimator {
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
                                                                                               animator:displayVCAnimator];
    TKEvent *vcDisplayedEvent = [MSSidebarControllerEventViewControllerDisplayed eventWithSidebarController:self
                                                                              displayingViewControllerState:displayingVCState
                                                                                        viewControllerState:vcState];
    TKEvent *displayMenuEvent = [MSSidebarControllerEventDisplayMenu eventWithSidebarController:self
                                                                            viewControllerState:vcState
                                                                            displayingMenuState:displayingMenuState
                                                                                       animator:displayMenuAnimator];
    
    TKEvent *menuDisplayedEvent = [MSSidebarControllerEventMenuDisplayed eventWithSidebarController:self
                                                                                displayingMenuState:displayingMenuState
                                                                                          menuState:menuState];
    TKEvent *hideVCEvent = [MSSidebarControllerEventHideViewController eventWithSidebarController:self
                                                                                        menuState:menuState
                                                                        hidingViewControllerState:hidingVCState
                                                                                         animator:hideVCAnimator];
    
    [_stateMachine addEvents:@[displayVCEvent,
                               vcDisplayedEvent,
                               displayMenuEvent,
                               menuDisplayedEvent,
                               hideVCEvent]];
    
    [_stateMachine activate];
}

#pragma mark -

- (void)loadView {
    [super loadView];
    
    [self addChildViewController:_current];
    [self.view addSubview:_current.view];
    [_current didMoveToParentViewController:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _menu.view.frame = self.view.bounds;
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
    [self fireEvent:MSSidebarControllerEventDisplayViewController.eventName
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

- (void)setCurrentViewController:(UIViewController *)viewController {
    NSParameterAssert(viewController);
    
    _current = viewController;
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