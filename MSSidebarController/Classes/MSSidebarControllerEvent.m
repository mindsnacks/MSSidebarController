//
//  MSSidebarControllerEvent.m
//  MSSidebarController
//
//  Created by Nacho Soto on 3/12/14.
//  Copyright (c) 2014 MindSnacks. All rights reserved.
//

#import "MSSidebarControllerEvent.h"
#import "MSSidebarControllerEvent+Protected.h"

#import <libextobjc/EXTScope.h>

@implementation MSSidebarControllerEvent

+ (instancetype)eventWithName:(NSString *)name
      transitioningFromStates:(NSArray *)sourceStates
                      toState:(TKState *)destinationState {
    return [self eventWithSidebarController:nil
                    transitioningFromStates:nil
                                    toState:nil];
}

+ (instancetype)eventWithSidebarController:(MSSidebarController *)sidebarController
                   transitioningFromStates:(NSArray *)sourceStates
                                   toState:(TKState *)destinationState {
    NSParameterAssert(sidebarController);
    
    MSSidebarControllerEvent *event = [super eventWithName:self.eventName
                                   transitioningFromStates:sourceStates
                                                   toState:destinationState];
    
    @weakify(sidebarController);
    
    [event setWillFireEventBlock:^(TKEvent *event, TKTransition *transition) {
        @strongify(sidebarController);
        
        [(MSSidebarControllerEvent *)event eventWillFireWithTransition:transition
                                                     sidebarController:sidebarController];
    }];
    
    [event setDidFireEventBlock:^(TKEvent *event, TKTransition *transition) {
        @strongify(sidebarController);
        
        [(MSSidebarControllerEvent *)event eventDidFireWithTransition:transition
                                                    sidebarController:sidebarController];
    }];
    
    return event;
}

- (void)eventWillFireWithTransition:(TKTransition *)transition
                  sidebarController:(MSSidebarController *)sidebarController {
    
}

- (void)eventDidFireWithTransition:(TKTransition *)transition
                 sidebarController:(MSSidebarController *)sidebarController {
    
}

+ (NSString *)eventName {
    [self doesNotRecognizeSelector:_cmd];
    
    return nil;
}

@end
