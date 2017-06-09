//
//  SendViewController.h
//  WOEC
//
//  Created by Tuannq on 5/3/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQActionSheetPickerView.h"
#import "SCPinViewController.h"
#import "SCPinAppearance.h"
#import "CommonUtils.h"

#import "MFSideMenu.h"
#import "MFSideMenuContainerViewController.h"
#import "HomeViewController.h"

@interface SendViewController : UIViewController<SCPinViewControllerCreateDelegate, SCPinViewControllerDataSource, SCPinViewControllerValidateDelegate>{
    SCPinViewController *vc;
    NSTimer *timer;

}
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIView *amountView;
@property (weak, nonatomic) IBOutlet UIView *feeView;
@property (weak, nonatomic) IBOutlet UIView *advanceView;
@property (weak, nonatomic) IBOutlet UIButton *btnAdvance;

@property (weak, nonatomic) IBOutlet UITextField *tfMixin;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfAmount;
@property (weak, nonatomic) IBOutlet UITextField *tfPaymentId;
@property (weak, nonatomic) IBOutlet UITextField *tfFee;

@property (weak, nonatomic) IBOutlet UILabel *lbBalance;
@property (weak, nonatomic) IBOutlet UILabel *lbLockAmount;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *btnPicker;

- (void) showPinCodeView;
- (void) changePinCodeView;
@end
