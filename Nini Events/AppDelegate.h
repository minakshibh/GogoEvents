//
//  AppDelegate.h
//  Nini Events
//
//  Created by Krishna_Mac_1 on 11/17/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "screenSaverViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableData *webData;
    int webServiceCode;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) bool *startIdleTimmer;
@property (nonatomic, retain) screenSaverViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigator;
@property (strong ,nonatomic) NSString*currencySymbol;
- (void)resetIdleTimer;
@end

