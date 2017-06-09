//
//  LoginViewController.m
//  WOEC
//
//  Created by Tuannq on 5/2/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "UserInfoViewController.h"
#import "Balance.h"



@interface LoginViewController () <SCPinViewControllerCreateDelegate, SCPinViewControllerDataSource, SCPinViewControllerValidateDelegate,MFSideMenuContainerViewControllerPanProtocol, UIGestureRecognizerDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
   
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIAlertView *alert = [CommonUtils showProgressWaiting:MSG_LOADING];
    double delayInSeconds = 0.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        ProfileData *profileData  = [[ProfileDataManager sharedInstance] loadProfileData];
        if (profileData.isLogin && profileData.cookie.length > 0) {
            if (profileData.pinCode.length == 4) {
                 AppDelegate *appdDelegate = [AppDelegate shared];
                if (!appdDelegate.secondWindow) {
                    appdDelegate.secondWindow = [[UIWindow alloc] initWithFrame:self.view.frame];
                    [appdDelegate.secondWindow setBackgroundColor:[UIColor clearColor]];
                }
                appdDelegate.secondWindow.rootViewController = [self pincodeController];
                [appdDelegate.secondWindow makeKeyAndVisible];
            }
        }
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) disableLogin:(BOOL) enabled{
    self.tfemail.hidden = enabled;
    self.tfPassword.hidden = enabled;
}

- (IBAction)loginAction:(id)sender {
    NSString *email = [CommonUtils trimTextfield:self.tfemail];
    NSString *password = [CommonUtils trimTextfield:self.tfPassword];
    
    if (![self validateLogin:email password:password]) {
        return;
    }
    
    if (![AppDelegate shared].networkStatus) {
        [CommonUtils showCPOMessage:MSG_ERROR_NETWORK];
        return;
    }
    
    UIAlertView *alert = [CommonUtils showProgressWaiting:MSG_LOADING];
    
    NSString *url = URL_LOGIN;
    NSDictionary *param = @{@"email": email,
                            @"pass": password};
    
    [[BlockChainConnect sharedInstance] postAction:url params:param successBlock:^(NSDictionary *responseDict) {
        NSDictionary *value = responseDict[@"data"];
        NSInteger error = [responseDict[@"error_code"] intValue];
        switch (error) {
            case 0:{
                ProfileData *profileData  = [[ProfileDataManager sharedInstance] loadProfileData];
                profileData.isLogin = YES;
                profileData.userId = value[@"_id"];
                profileData.pass = value[@"pass"];
                profileData.pass2 = value[@"pass2"];
                profileData.email = value[@"email"];
                profileData.activation = value[@"activation"];
                profileData.v = value[@"__v"];
                profileData.name = value[@"name"];
                profileData.passwordNotEncode = password;
                  
                
                [[ProfileDataManager sharedInstance] replaceProfileData:profileData];
                
//                NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:kViewControllerPin];
                NSString *pin = profileData.pinCode;
                if (pin.length != 4) {
                    //Create pin code
                    SCPinAppearance *appearance = [SCPinAppearance defaultAppearance];
                    SCPinViewController *vc;
                    
                    appearance.titleText = @"Create PIN";
                    [SCPinViewController setNewAppearance:appearance];
                    vc = [[SCPinViewController alloc] initWithScope:SCPinViewControllerScopeCreate];
                    
                    vc.createDelegate = self;
                    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
                    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
                    [vc.navigationItem setLeftBarButtonItems:@[item]];
                    [self presentViewController:navigation animated:YES completion:nil];
                }else {
                    [self getBalance:email password:password];
                    //Go to Home View
                    [self gotoHomeView];
                }
                break;
            }
                
            default:
                [CommonUtils showCPOMessage:@"Login fail"];
                break;
        }
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        
    } failure:^(NSInteger failureCode) {
        NSLog(@"%ld", (long)failureCode);
        [CommonUtils showCPOMessage:@"Login fail"];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }];
    
}

- (void) gotoHomeView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *homeVC = (HomeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    homeVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    UINavigationController *naviTop = [CommonUtils navigationForPresentModalWithRootView:homeVC];
    UserInfoViewController *rightMenuViewController = [[UserInfoViewController alloc] init];
    CGRect rightMenuFrame = rightMenuViewController.view.frame;
    rightMenuFrame.size.height = self.view.bounds.size.height;
    rightMenuViewController.view.frame = rightMenuFrame;
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController containerWithCenterViewController:naviTop
                                                                                                 leftMenuViewController:nil
                                                                                                rightMenuViewController:rightMenuViewController];
    container.panGestureDelegate = self;
    [container.shadow setEnabled:NO];
    [container setPanMode:MFSideMenuPanModeSideMenu];
    [container setMenuSlideAnimationEnabled:YES];
    [container setMenuSlideAnimationFactor:1];
    [container childViewControllerForStatusBarStyle];
    [self.navigationController pushViewController:homeVC animated:NO];

}

//Validate Login form
- (BOOL) validateLogin:(NSString *)email password:(NSString *)password {
    
    if (![CommonUtils validateBlank:email] || ![CommonUtils validateBlank:password]) {
        [CommonUtils showCPOMessage:[NSString stringWithFormat:MSG_ERROR_TEXTFIELD_EMPTY, @"Email or Password"]];
        return NO;
    }
    if (![CommonUtils validateEmail:email]) {
        [CommonUtils showCPOMessage:@"Email invalid"];
        return NO;
    }
    if (![CommonUtils validatePasswordField:password]) {
        [CommonUtils showCPOMessage:@"Password invalid"];
        return NO;
    }
    return YES;
}

- (void) getBalance:(NSString *)email password:(NSString *)password {
    
    NSString *url = [NSString stringWithFormat:URL_GET_BALANCE,email, password];
    [[BlockChainConnect sharedInstance] getAction:url successBlock:^(NSDictionary *responseDict) {
        
        NSDictionary *value = responseDict[@"result"];
        NSLog(@"getBalance");
        Balance *balanceAmount = [[Balance alloc] init];
        NSNumber *available_balance = value[@"available_balance"];
        balanceAmount.balanceAmount = available_balance;
        NSNumber *locked_amount = value[@"locked_amount"];
        balanceAmount.lockAmount = locked_amount;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifUpdateAmout object:balanceAmount];
    } failure:^(NSInteger failureCode) {
        NSLog(@"%ld", (long)failureCode);

    }];
}

#pragma pinCode delegate
-(void)pinViewController:(SCPinViewController *)pinViewController didSetNewPin:(NSString *)pin {
    NSLog(@"pinViewController: %@",pinViewController);
    ProfileData *profileData  = [[ProfileDataManager sharedInstance] loadProfileData];
    profileData.pinCode = pin;
    [[ProfileDataManager sharedInstance] replaceProfileData:profileData];
    
//    [[NSUserDefaults standardUserDefaults] setObject:pin forKey:kViewControllerPin];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self getBalance:profileData.email password:profileData.passwordNotEncode];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    //Go to Home View
   [self gotoHomeView];
}

-(void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)lengthForPin {
    return 4;
}

-(NSString *)codeForPinViewController:(SCPinViewController *)pinViewController {
//    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:kViewControllerPin];
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


-(void)pinViewControllerDidSetСorrectPin:(SCPinViewController *)pinViewController{
    if(self.pinController.validateDelegate){
        AppDelegate *appdDelegate = [AppDelegate shared];
        dispatch_async(dispatch_get_main_queue(), ^{
            [appdDelegate.secondWindow setHidden:YES];
            appdDelegate.secondWindow.rootViewController = nil;
            appdDelegate.window.windowLevel = UIWindowLevelNormal;
             ProfileData *profileData  = [[ProfileDataManager sharedInstance] loadProfileData];
            [self getBalance:profileData.email password:profileData.passwordNotEncode];
            [self gotoHomeView];
        });
        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

@end
