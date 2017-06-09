//
//  UserInfoViewController.m
//  Blockchain
//
//  Created by Tuannq on 5/18/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ProfileData.h"
#import "ProfileDataManager.h"
#import "CommonUtils.h"
#import "BlockChainConnect.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.avatarView.layer.cornerRadius = 50.0;
    
    
    self.heightConstantBackUp  = [NSNumber numberWithFloat:self.heighConstains.constant];
    float heightChangePasswordView = self.changePasswordView.bounds.size.height - 2;
    self.heighConstains.constant = [[NSString stringWithFormat:@"-%f", heightChangePasswordView] doubleValue];
    [_btnChangePassword setBackgroundImage:[UIImage imageNamed:@"grey_icon.png"] forState:UIControlStateNormal];
    [self.view layoutIfNeeded];
    self.changePasswordView.hidden = YES;
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ProfileData *profileData  = [[ProfileDataManager sharedInstance] loadProfileData];
    self.tfEmail.text = profileData.email;
    self.lbName.text = self.tfName.text = profileData.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 Change password enable/disable button

 @param sender sender
 */
- (IBAction)changePasswordAction:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.changePasswordView.hidden) {
            self.heighConstains.constant = [self.heightConstantBackUp floatValue];
            self.changePasswordView.hidden = NO;
            [_btnChangePassword setBackgroundImage:[UIImage imageNamed:@"yes_icon.png"] forState:UIControlStateNormal];
        }else {
            self.heighConstains.constant = -50;
            self.changePasswordView.hidden = YES;
            [_btnChangePassword setBackgroundImage:[UIImage imageNamed:@"grey_icon.png"] forState:UIControlStateNormal];
        }
        
        [self.view layoutIfNeeded];
        
    });
}
- (IBAction)updateUserInfoAction:(id)sender {
    if (![AppDelegate shared].networkStatus) {
        [CommonUtils showCPOMessage:MSG_ERROR_NETWORK];
        return;
    }
    
    if (![CommonUtils validateBlank:self.tfName.text]) {
        [CommonUtils showCPOMessage:[NSString stringWithFormat:MSG_ERROR_TEXTFIELD_EMPTY, @"Name"]];
        return;
    }
    
    if (![CommonUtils validateBlank:self.tfPassword.text]) {
        [CommonUtils showCPOMessage:[NSString stringWithFormat:MSG_ERROR_TEXTFIELD_EMPTY, @"Password"]];
        return;
    }
    
    ProfileData *profileData  = [[ProfileDataManager sharedInstance] loadProfileData];
    if (![profileData.name isEqualToString:self.tfName.text]) {
        NSDictionary *param = @{
                                @"email": [CommonUtils trimTextfield:self.tfEmail],
                                @"pass": [CommonUtils trimTextfield:self.tfPassword],
                                @"name": [CommonUtils trimTextfield:self.tfName],
                                @"language": @"en"
                                };
        UIAlertView *alert = [CommonUtils showProgressWaiting:MSG_LOADING];
        [[BlockChainConnect sharedInstance] postAction:URL_UPDATE_USER params:param successBlock:^(NSDictionary *responseDict) {
            NSInteger error = [responseDict[@"error_code"] intValue];
            switch (error) {
                case 0:
                    profileData.name = self.lbName.text = self.tfName.text;
                    [[ProfileDataManager sharedInstance] replaceProfileData:profileData];
                    [CommonUtils showCPOMessage:MSG_SUCCESS];
                    break;
                    
                default:
                    break;
            }
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        } failure:^(NSInteger failureCode) {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [CommonUtils showCPOMessage:MSG_ERROR_UPDATE_FAIL];
        }];
    }
    
    if (!self.changePasswordView.hidden) {
        
    }
    
}
- (IBAction)changePasscodeAction:(id)sender {
//    NSLog(@"changePasscodeAction");
    UINavigationController *parentNavi = ((UINavigationController*)self.menuContainerViewController.centerViewController);
    HomeViewController *homeVC = (HomeViewController*)[parentNavi.viewControllers lastObject];
    [homeVC showPasscodeView];
}

- (IBAction)SignOutAction:(id)sender {
    NSLog(@"SignOutAction");
    // Delete button was pressed
    LEAlertController *alertController = [CommonUtils showAlertConfirm:MSG_CONFIRM_LOGOUT cancelButton:^{
        NSLog(@"cancel button pressed");
    } okButton:^{
        UINavigationController *parentNavi = ((UINavigationController*)self.menuContainerViewController.centerViewController);
        HomeViewController *homeVC = (HomeViewController*)[parentNavi.viewControllers lastObject];
        [homeVC signOut];
        
    }];
    [self presentAlertController:alertController animated:YES completion:nil];
    
}


@end
