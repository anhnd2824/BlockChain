//
//  AppDelegate.m
//  WOEC
//
//  Created by Tuannq on 5/2/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileDataManager.h"
#import "AppConst.h"
#import "UserInfoViewController.h"
#import "LoginViewController.h"
#import "CommonUtils.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)shared {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_OPENED_APP]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_OPENED_APP];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[ProfileDataManager sharedInstance] initDefaultData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChangeStatus:) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    self.networkStatus = [self.reachability currentReachabilityStatus];
    [self.reachability startNotifier];
    
    
    [self registerForRemoteNotifications];
    
    self.window.rootViewController = [CommonUtils createHomeControllerByMFSideMenu];
    [self.window makeKeyAndVisible];
        return YES;
}

//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    if (notificationSettings.types == UIUserNotificationTypeNone) {
        [application registerForRemoteNotifications];
    }
}


- (void)registerForRemoteNotifications {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        // Code for old versions
    }
}

#pragma mark - Check network status
-(void)networkChangeStatus:(NSNotification*)notifyObject {
    self.networkStatus = (self.reachability.currentReachabilityStatus != NotReachable);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //Get current view controller
    NSString *currentClass = NSStringFromClass([[[[UIApplication sharedApplication] delegate] window].rootViewController class]);
    if (![currentClass isEqualToString:@"SCPinViewController"]) {
        currentController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    }
    NSLog(@"%@", [currentController class]);
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    ProfileData *profileData = [[ProfileDataManager sharedInstance] loadProfileData];
    if (profileData.pinCode.length == 4) {
        
        if (!self.secondWindow) {
            self.secondWindow = [[UIWindow alloc] initWithFrame:self.window.frame];
            [self.secondWindow setBackgroundColor:[UIColor clearColor]];
        }
    
        
        
        //Check Window level alert or Keyboard
//        if ([KeyboardStateListener sharedInstance].isVisible) {
            NSArray *windows = [[UIApplication sharedApplication] windows];
            UIWindow *lastWindow = (UIWindow *)[windows lastObject];
            [self.secondWindow setWindowLevel:lastWindow.windowLevel + 1];
//        }else {
//            [self.secondWindow setWindowLevel:UIWindowLevelAlert];
//        }
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            if (profileData.pinCode.length == 4) {
                self.secondWindow.rootViewController = [self pincodeController];
                [self.secondWindow makeKeyAndVisible];
            }
        });
        
    }
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIViewController *)pincodeController
{
    
    SCPinAppearance *appearance = [SCPinAppearance defaultAppearance];
    appearance.numberButtonstrokeEnabled = NO;
    appearance.titleText = @"Enter PIN";
    [SCPinViewController setNewAppearance:appearance];
    self.pinController = [[SCPinViewController alloc] initWithScope:SCPinViewControllerScopeValidate];
    
    self.pinController.dataSource = self;
    self.pinController.validateDelegate = self;
    
    return self.pinController;
}
#pragma pinCode delegate
-(void)pinViewController:(SCPinViewController *)pinViewController didSetNewPin:(NSString *)pin {
    NSLog(@"pinViewController: %@",pinViewController);
    ProfileData *profileData  = [[ProfileDataManager sharedInstance] loadProfileData];
    profileData.pinCode = pin;
    [[ProfileDataManager sharedInstance] replaceProfileData:profileData];
}


-(NSInteger)lengthForPin {
    return 4;
}

-(NSString *)codeForPinViewController:(SCPinViewController *)pinViewController {
    ProfileData *profileData  = [[ProfileDataManager sharedInstance] loadProfileData];
    return profileData.pinCode;
}

-(BOOL)hideTouchIDButtonIfFingersAreNotEnrolled {
    return YES;
}

-(BOOL)showTouchIDVerificationImmediately {
    return NO;
}

- (void)pinViewControllerDidSetWrongPin:(SCPinViewController *)pinViewController numberWrong:(NSInteger)number{
    
}



-(void)pinViewControllerDidSetСorrectPin:(SCPinViewController *)pinViewController{
    [self.secondWindow setHidden:YES];
    self.secondWindow.rootViewController = nil;
    self.window.windowLevel = UIWindowLevelNormal;
    [self showMainController];
}

// SHow main view when dismis Passcode view
- (void)showMainController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.window.rootViewController = [self mainController];
        [self.window makeKeyAndVisible];
    });
}

// Main  controller when passcode success
- (UIViewController *)mainController
{
    NSLog(@"%@", [currentController class]);
    return currentController;
}

@end
