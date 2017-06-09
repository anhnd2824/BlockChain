//
//  UserInfoViewController.h
//  Blockchain
//
//  Created by Tuannq on 5/18/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "MFSideMenuContainerViewController.h"
#import "HomeViewController.h"
#import "LEAlertController.h"

@interface UserInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heighConstains;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateUserInfo;
@property (weak, nonatomic) IBOutlet UITextField *tfConfirmSecondPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfSecondPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfPasswordSecond;
@property (weak, nonatomic) IBOutlet UIButton *btnSetUpSecondPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePasscode;
@property (weak, nonatomic) IBOutlet UIView *changePasswordView;

@property (weak, nonatomic) IBOutlet UITextField *tfNewSecondPassword;

@property (copy, nonatomic) NSNumber *heightConstantBackUp;
@end
