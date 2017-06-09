//
//  SendViewController.m
//  WOEC
//
//  Created by Tuannq on 5/3/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import "SendViewController.h"
#import "CommonUtils.h"
#import "AppConst.h"
#import "Balance.h"
#import "SearchViewController.h"
#import "ProfileDataManager.h"


@interface SendViewController ()<IQActionSheetPickerViewDelegate, UITextFieldDelegate>

@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CommonUtils setBorderTextfield:_addressView];
    [CommonUtils setBorderTextfield:self.amountView];
//    [CommonUtils setBorderTextfield:self.feeView];
    self.advanceView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateAmount:)
                                                 name:kNotifUpdateAmout
                                               object:nil];
    timer = [self getBalanceInBackground];
    self.tfPaymentId.text = [CommonUtils randomStringWithLength];
}

- (NSTimer *) getBalanceInBackground {
    return timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                    target:self
                                                  selector:@selector(getBalance)
                                                  userInfo:nil
                                                   repeats:YES];
}
- (void)updateAmount:(NSNotification *)notification
{
    Balance *balance = (Balance *)notification.object;
    self.lbBalance.text = [CommonUtils formatWOECCoint:balance.balanceAmount];
    self.lbLockAmount.text = [CommonUtils formatWOECCoint:balance.lockAmount];
}

- (void) getBalance {
    ProfileData *profileData  = [[ProfileDataManager sharedInstance] loadProfileData];
    NSString *url = [NSString stringWithFormat:URL_GET_BALANCE,profileData.email,profileData.passwordNotEncode];
    [[BlockChainConnect sharedInstance] getAction:url successBlock:^(NSDictionary *responseDict) {
        
        NSDictionary *value = responseDict[@"result"];
//        NSLog(@"getBalance");
        Balance *balanceAmount = [[Balance alloc] init];
        NSNumber *available_balance = value[@"available_balance"];
        NSNumber *locked_amount = value[@"locked_amount"];
        
        balanceAmount.balanceAmount = available_balance;
        balanceAmount.lockAmount = locked_amount;
        self.lbBalance.text = [CommonUtils formatWOECCoint:balanceAmount.balanceAmount];
        self.lbLockAmount.text = [CommonUtils formatWOECCoint:balanceAmount.lockAmount];
    } failure:^(NSInteger failureCode) {
        NSLog(@"%ld", (long)failureCode);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifUpdateAmout object:nil];
}
- (IBAction)advanceAction:(id)sender {
    if ([self.btnAdvance.titleLabel.text isEqualToString:BUTTON_ADVANCE]) {
//        self.tfPaymentId.text = [CommonUtils randomStringWithLength];
        [self.btnAdvance setTitle:BUTTON_SIMPLE forState:UIControlStateNormal];
        self.advanceView.hidden = false;
    }else {
        [self.btnAdvance setTitle:BUTTON_ADVANCE forState:UIControlStateNormal];
        self.advanceView.hidden = YES;
    }
}

#pragma Action Send
- (IBAction)sendAction:(id)sender {
    
    if (![self validateFormTransfer]) {
        return;
    }
    
    if (![CommonUtils validatePaymentId:self.tfPaymentId.text]) {
        [CommonUtils showCPOMessage:@"There are some errors"];
        return;
    }
    
    NSNumber *amount = [NSNumber numberWithDouble:[[CommonUtils trimTextfield:self.tfAmount] doubleValue] * 100000000];
    if([amount isEqual:@0.0]) {
        [CommonUtils showCPOMessage:@"Amount must be more than zero"];
        return;
    }
    
    [self showPinCodeView];
}

//Validate form transfer
- (BOOL) validateFormTransfer {
    if (![CommonUtils validateBlank:self.tfAddress.text] || ![CommonUtils validateBlank:self.tfAmount.text]) {
        [CommonUtils showCPOMessage:[NSString stringWithFormat:MSG_ERROR_TEXTFIELD_EMPTY, @"Address"]];
        return NO;
    }
    
    if (![CommonUtils validateBlank:self.tfAmount.text]) {
        [CommonUtils showCPOMessage:[NSString stringWithFormat:MSG_ERROR_TEXTFIELD_EMPTY, @"Amount"]];
        return NO;
    }
    return YES;
}

- (void) showPinCodeView{
    SCPinAppearance *appearance = [SCPinAppearance defaultAppearance];
    appearance.numberButtonstrokeEnabled = NO;
    appearance.titleText = @"Enter PIN";
    [SCPinViewController setNewAppearance:appearance];
    vc = [[SCPinViewController alloc] initWithScope:SCPinViewControllerScopeValidate];
    
    vc.dataSource = self;
    vc.validateDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

//Show picker view
- (IBAction)showPickerViewAction:(id)sender {
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Mixin" delegate:self];
    picker.titleFont = [UIFont systemFontOfSize:12];
    picker.titleColor = [UIColor redColor];
    [picker setTag:1];
    [picker setTitlesForComponents:@[@[@"0", @"1", @"2", @"3"]]];
    [picker show];
}

#pragma mark - IQActionSheetPickerView delegate

//Delegate when done button click
- (void) actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles{
    
//    NSLog(@"%@", [titles componentsJoinedByString:@" - "]);
//    self.tfMixin.text = [titles componentsJoinedByString:@" - "];
    [self.btnPicker setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal];
}

-(void)pinViewController:(SCPinViewController *)pinViewController didSetNewPin:(NSString *)pin {
//    NSLog(@"pinViewController: %@",pinViewController);
//    [[NSUserDefaults standardUserDefaults] setObject:pin forKey:kViewControllerPin];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    ProfileData *profileData  = [[ProfileDataManager sharedInstance] loadProfileData];
    profileData.pinCode = pin;
    [[ProfileDataManager sharedInstance] replaceProfileData:profileData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if (number == 4) {
        [CommonUtils showCPOMessage:MSG_ERROR_PASSCODE_FAIL_TOO_MUCH];
        [self dismissViewControllerAnimated:YES completion:nil];
//        ProfileData *profileData  = [[ProfileDataManager sharedInstance] loadProfileData];
//        profileData.pinCode = MSG_BLANK;
//        [[ProfileDataManager sharedInstance] replaceProfileData:profileData];
        UINavigationController *parentNavi = ((UINavigationController*)self.menuContainerViewController.centerViewController);
        HomeViewController *homeVC = (HomeViewController*)[parentNavi.viewControllers lastObject];
        [homeVC closeRightMenu];
        [homeVC signOut];
    }
}

-(void)pinViewControllerDidSetСorrectPin:(SCPinViewController *)pinViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (![CommonUtils isNetworkAvailable]) {
        [CommonUtils showCPOMessage:MSG_ERROR_NETWORK];
        return;
    }
    
    UIAlertView *alert = [CommonUtils showProgressWaiting:MSG_LOADING];
//    NSString *transferValue = [NSString stringWithFormat:@"%@,%@" , @"CDUo7oDJ7aB7ezaT4kMWWE9P1tV3FgKzna9vgNgm91Yc4r5EzCtMDz52zFyjwodWAdUFYL2ye5UkTCA4rg9bWc6rM6PiGhR", @"12000000000"];
    NSNumber *amount = [NSNumber numberWithDouble:[[CommonUtils trimTextfield:self.tfAmount] doubleValue] * 100000000];
    NSNumber *fee = [NSNumber numberWithDouble:[[CommonUtils trimTextfield:self.tfFee] doubleValue] * 10000000];
    NSString *feeValue = [NSString stringWithFormat:@"%@" , fee];
    NSString *transferValue = [NSString stringWithFormat:@"%@,%@" , [CommonUtils trimTextfield:self.tfAddress], amount];
    
    NSDictionary *param = @{@"transfer": transferValue,
                            @"fee": feeValue,
                            @"mixin": self.btnPicker.currentTitle,
                            @"payment_id": [CommonUtils trimTextfield:self.tfPaymentId]
                            };
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    ProfileData *profileData = [[ProfileDataManager sharedInstance] loadProfileData];
    [headers setValue:profileData.cookie forKey:COOKIE_HEADER];
    
    [[BlockChainConnect sharedInstance] postAction:URL_SEND params:param header:headers successBlock:^(NSDictionary *responseDict) {
        NSInteger error = [responseDict[@"res_code"] intValue];
        switch (error) {
            case 0:{
                NSDictionary *data = responseDict[@"data"];
                //                NSLog(@"%@", data);
                if ([data objectForKey:@"error"]) {
                    NSDictionary *error = data[@"error"];
                    [CommonUtils showCPOMessage:error[@"message"]];
                } else {
                    [CommonUtils showCPOMessage:@"Transfer success"];
                    [self clearData];
                    [timer invalidate];
                    timer = nil;
                    [self getBalance];
                    timer = [self getBalanceInBackground];
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
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [CommonUtils showCPOMessage:@"Transfer fail"];
    }];
}

- (void) changePinCodeView{
    //Create pin code
    SCPinAppearance *appearance = [SCPinAppearance defaultAppearance];
    SCPinViewController *editVC;
    
    appearance.titleText = @"Enter old PIN";
    [SCPinViewController setNewAppearance:appearance];
    editVC = [[SCPinViewController alloc] initWithScope:SCPinViewControllerScopeEdit];
    editVC.dataSource = self;
    editVC.validateDelegate = self;
    editVC.createDelegate = self;
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:editVC];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    [editVC.navigationItem setLeftBarButtonItems:@[item]];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void) clearData{
    self.tfPaymentId.text = [CommonUtils randomStringWithLength];
    self.tfAddress.text = MSG_BLANK;
    self.tfAmount.text = MSG_BLANK;
    self.tfFee.text = @"0.1";
    [self.btnAdvance setTitle:BUTTON_ADVANCE forState:UIControlStateNormal];
    self.advanceView.hidden = YES;
}

- (IBAction)openContactAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *contactVC = (SearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [contactVC setModalPresentationStyle:UIModalPresentationCustom];
    [contactVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    contactVC.searchBlock = ^(Contact *contact) {
        self.tfAddress.text = contact.address;
    };
    [self presentViewController:contactVC animated:YES completion:nil];
}

@end
