//
//  CommonUtils.m
//  TVES
//
//  Created by Đầu Đất on 4/24/17.
//  Copyright © 2017 Đầu Đất. All rights reserved.
//

#import "CommonUtils.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "UserInfoViewController.h"
#import "LoginViewController.h"


@implementation CommonUtils

+ (BOOL)isNetworkAvailable
{
    CFNetDiagnosticRef dReference;
    dReference = CFNetDiagnosticCreateWithURL (kCFAllocatorDefault, (__bridge CFURLRef)[NSURL URLWithString:@"www.apple.com"]);
    
    CFNetDiagnosticStatus status;
    status = CFNetDiagnosticCopyNetworkStatusPassively (dReference, NULL);
    
    CFRelease (dReference);
    
    if ( status == kCFNetDiagnosticConnectionUp )
    {
//        NSLog (@"Connection is Available");
        return YES;
    }
    else
    {
//        NSLog (@"Connection is down");
        return NO;
    }
}

// get Document folder path
+ (NSString*)getDocumentDir {
    NSArray *docFolders = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *homeDir  = [docFolders lastObject];
    return homeDir;
}

// show alert error
+ (UIAlertView *)showCPOMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    return alert;
}

+ (UIAlertView*)showProgressWaiting:(NSString*)message withCancel:(BOOL)bCancel {
    UIAlertView *alert;
    if (bCancel) {
        alert = [[UIAlertView alloc] initWithTitle:MSG_BLANK
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:BUTTON_CANCEL
                                 otherButtonTitles:nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:MSG_BLANK
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
    }
    [alert show];
    return alert;
}


// show progress to fix iPad 8.1 bug in Landscape orientation
+ (UIAlertView*)showProgressWaiting:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MSG_BLANK
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    return alert;
}

+ (void) setBorderTextfield:(UIView *)view{
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 0.5;
}

//Check fingerprint
+ (BOOL)isTouchIDAvailable {
    if ([CommonUtils isIOS8AndAbove]) {
        return [[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    }
    return NO;
}
+ (BOOL)isIOS8AndAbove {
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO;
}

+ (BOOL)isIOS7AndAbove {
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO;
}

+ (BOOL)isIOS9AndAbove {
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? YES : NO;
}

+ (BOOL)validateEmail:(NSString *)emailString {
    if (!emailString || [emailString isEqualToString:MSG_BLANK]) {
        return NO;
    }
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

+ (BOOL)validatePaymentId:(NSString *)value {
    NSString *stricterFilterString = @"^[0-9a-f-A-F]{64}";
//    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [emailTest evaluateWithObject:value];
}

// password validation
+ (BOOL)validatePasswordField:(NSString *)password {
    BOOL correct = YES;
    if (password.length > 0) {
        if (password.length < 6 || password.length > 50) {
            correct = NO;
        }
        if (([password rangeOfString:@"\'"].location != NSNotFound) || ([password rangeOfString:@"\""].location != NSNotFound) || ([password rangeOfString:@","].location != NSNotFound) || ([password rangeOfString:@" "].location != NSNotFound)) {
            correct = NO;
        }
    }
    
    
    return correct;
}

+ (BOOL)validateBlank:(NSString *)string {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (string.length == 0) {
        return NO;
    }
    return YES;
}

+ (NSString *) trimTextfield:(UITextField *) textfield {
    return [textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// get object in array
+ (TransactionDetail*)getTransactionInArray:(NSMutableArray*)transactionsList atIndex:(NSInteger)index{
    if (index < transactionsList.count) {
        return [transactionsList objectAtIndex:index];
    }
    return nil;
}

+ (void)dimissKeyBoard:(UITextField *)textField{
    [textField resignFirstResponder];
}

+ (void)camDenied {
    
    NSString *alertText;
    NSString *alertButton;
    
    BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
    if (canOpenSettings) {
        alertText = MSG_CAN_OPEN_SETING;
        alertButton = BUTTON_GO;
    } else {
        alertText = MSG_CAN_NOT_OPEN_SETING;
        alertButton = BUTTON_OK;
    }
    
    [UIAlertView showWithTitle:MSG_BLANK
                       message:alertText
             cancelButtonTitle:alertButton
             otherButtonTitles:nil
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
                          if (canOpenSettings)
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                      }];
}

+ (void)showActionSheet:(nullable id)weakSelf firstButton:(void(^_Nonnull)())firstButton secondButton:(void(^_Nonnull)())secondButton{
    WCActionSheet *actionSheet = [[WCActionSheet alloc] initWithDelegate:weakSelf cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
    [actionSheet addButtonWithTitle:@"Scan by Camera" actionBlock:^{
        NSLog(@"Scan by Camera");
        if (firstButton) {
            firstButton();
        }
    }];
    [actionSheet addButtonWithTitle:@"Scan from Photo Album" actionBlock:^{
        NSLog(@"Scan from Photo Album");
        if (secondButton) {
            secondButton();
        }
    }];
    [actionSheet show];
}

+ (void)openQRCodeScanner:(nullable id)weakSelf{
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:BUTTON_CANCEL codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = weakSelf;
        
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [weakSelf presentViewController:vc animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:MSG_ERROR_UNKNOWN
                              message:MSG_NOT_SUPPORT_DEVICE
                              delegate:nil
                              cancelButtonTitle:BUTTON_OK
                              otherButtonTitles:nil];
        
        [alert show];
    }
}

+ (void)gotoQRcoode:(nullable id)weakSelf{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        [CommonUtils openQRCodeScanner:weakSelf];
    } else if(authStatus == AVAuthorizationStatusNotDetermined) {
        NSLog(@"%@", @"Camera access not determined. Ask for permission.");
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted) {
                NSLog(@"Granted access to %@", AVMediaTypeVideo);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CommonUtils openQRCodeScanner:weakSelf];
                });
            } else {
                [CommonUtils camDenied];
            }
        }];
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        [CommonUtils showCPOMessage:MSG_DOES_NOT_HAVE_ACCESS_CAMERA];
    } else {
        // AVAuthorizationStatusDenied
        [CommonUtils camDenied];
    }
}

+ (void)openLocalPhoto:(nullable id) weakself
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = weakself;
    picker.allowsEditing = YES;
    
    [weakself presentViewController:picker animated:YES completion:nil];
}

+ (void)openLocalPhotoAlbum:(nullable id)weakSelf
{
    if ([LBXScanPermissions photoPermission])
    {
        [CommonUtils openLocalPhoto:weakSelf];
    }else {
        [CommonUtils showCPOMessage:@"Not Permission"];
    }
}

+ (NSString *) formatWOECCoint:(NSNumber *)number{
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    numberFormatter.usesGroupingSeparator = YES;
//    [numberFormatter setMaximumFractionDigits:5];
//    return [numberFormatter stringFromNumber:number];
    
    return ![number isEqual:@0] ? [NSString stringWithFormat:@"%.8f",[number doubleValue] / 100000000] : @"0";
}

+ (MFSideMenuContainerViewController*)createHomeControllerByMFSideMenu {
    MFSideMenuContainerViewController *container;
    //    CPORightMenuViewController *rightMenuViewController = [[CPORightMenuViewController alloc] init];
    
    UserInfoViewController *rightMenuViewController = [[UserInfoViewController alloc] init];
    if (IS_IPHONE6) {
        CGRect rightMenuFrame = rightMenuViewController.view.frame;
        rightMenuFrame.size.height = 667;
        rightMenuViewController.view.frame = rightMenuFrame;
    }
    if (IS_IPHONE6PLUS) {
        CGRect rightMenuFrame = rightMenuViewController.view.frame;
        rightMenuFrame.size.height = 736;
        rightMenuViewController.view.frame = rightMenuFrame;
    }
    if (IS_IPHONE5) {
        CGRect rightMenuFrame = rightMenuViewController.view.frame;
        rightMenuFrame.size.height = 568;
        rightMenuViewController.view.frame = rightMenuFrame;
    }
    if (IS_IPAD) {
        CGRect rightMenuFrame = rightMenuViewController.view.frame;
        rightMenuFrame.size.height = 768;
        rightMenuViewController.view.frame = rightMenuFrame;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginView = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    
    container = [MFSideMenuContainerViewController containerWithCenterViewController:[self navigationForPresentModalWithRootView:loginView]
                                                              leftMenuViewController:nil
                                                             rightMenuViewController:rightMenuViewController];
    
    //    container.panGestureDelegate = self;
    [container.shadow setEnabled:NO];
    [container setPanMode:MFSideMenuPanModeSideMenu];
    [container setMenuSlideAnimationEnabled:YES];
    [container setMenuSlideAnimationFactor:1];
    [container childViewControllerForStatusBarStyle];
    return container;
}

// create new navigation for present modal
+ (UINavigationController *)navigationForPresentModalWithRootView:(id)rootView {
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:rootView];
    [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    navi.navigationBar.translucent = NO;
    UIColor *tintColor = [UIColor whiteColor];
    [navi.view setTintColor:tintColor];
    return navi;
}

+ (LEAlertController *) showAlertConfirm:(NSString *_Nullable) message cancelButton:(void(^)())cancelButton okButton:(void(^)())okButton {
    LEAlertController *alertController = [LEAlertController alertControllerWithTitle:MSG_BLANK message:message preferredStyle:LEAlertControllerStyleAlert];
    
    LEAlertAction *cancelAction = [LEAlertAction actionWithTitle:BUTTON_CANCEL style:LEAlertActionStyleCancel handler:^(LEAlertAction *action) {
        // handle cancel button action
        NSLog(@"cancel button pressed");
        if (cancelButton) {
            cancelButton();
        }
    }];
    [alertController addAction:cancelAction];
    
    LEAlertAction *okAction = [LEAlertAction actionWithTitle:BUTTON_OK style:LEAlertActionStyleDefault handler:^(LEAlertAction *action) {
        // handle default button action
        NSLog(@"ok button pressed");
        if (okButton) {
            okButton();
        }
    }];
    [alertController addAction:okAction];
    return alertController;
}

+ (NSString *_Nonnull) randomStringWithLength{
    NSString *letters = @"abcdefABCDEF0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 64];
    
    for (int i=0; i<64; i++) {
        u_int32_t r = arc4random() % [letters length];
        unichar c = [letters characterAtIndex:r];
        [randomString appendFormat:@"%C", c];
//        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

@end
