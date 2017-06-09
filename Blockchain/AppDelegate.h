//
//  AppDelegate.h
//  WOEC
//
//  Created by Tuannq on 5/2/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "SCPinViewController.h"
#import "SCPinAppearance.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, SCPinViewControllerDataSource,SCPinViewControllerCreateDelegate,SCPinViewControllerValidateDelegate,UNUserNotificationCenterDelegate>{
    UIViewController *currentController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *secondWindow;
+ (AppDelegate *)shared;
@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic) BOOL networkStatus;
@property (nonatomic) SCPinViewController *pinController;

@end

