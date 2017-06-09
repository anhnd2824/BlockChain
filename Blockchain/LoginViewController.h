//
//  LoginViewController.h
//  WOEC
//
//  Created by Tuannq on 5/2/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPinViewController.h"
#import "SCPinAppearance.h"

@interface LoginViewController : UIViewController<SCPinViewControllerDataSource,SCPinViewControllerCreateDelegate,SCPinViewControllerValidateDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfemail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@property (nonatomic) SCPinViewController *pinController;

@end
