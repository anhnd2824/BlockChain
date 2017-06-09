//
//  CommonUtils.h
//  TVES
//
//  Created by Đầu Đất on 4/24/17.
//  Copyright © 2017 Đầu Đất. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConst.h"
#import "TransactionDetail.h"
#import "UIAlertView+Blocks.h"
#import "WCActionSheet.h"
#import "QRCodeReaderViewController.h"
#import "LBXScanPermissions.h"
#import "MFSideMenuContainerViewController.h"
#import "LEAlertController.h"

@import UIKit;

@interface CommonUtils : NSObject
+ (BOOL)isNetworkAvailable;

+ (NSString *)getDocumentDir;

+ (UIAlertView *)showCPOMessage:(NSString *)message;
// Show waiting alert view
+ (UIAlertView*)showProgressWaiting:(NSString*)message withCancel:(BOOL)bCancel;

// show progress to fix iPad 8.1 bug in Landscape orientation
+ (UIAlertView*)showProgressWaiting:(NSString*)message;
+ (void) setBorderTextfield:(UIView *)view;
//Check fingerprint
+ (BOOL)isTouchIDAvailable;

+ (BOOL)isIOS8AndAbove;

+ (BOOL)isIOS7AndAbove;

+ (BOOL)isIOS9AndAbove;

+ (BOOL)validateEmail:(NSString *)emailString;

+ (BOOL)validatePasswordField:(NSString *)password;

+ (BOOL)validateBlank:(NSString *)string;
+ (NSString *) trimTextfield:(UITextField *) textfield;
// get object in array
+ (TransactionDetail*)getTransactionInArray:(NSMutableArray*)transactionsList atIndex:(NSInteger)index;

+ (void)dimissKeyBoard:(UITextField *)textField;

+ (void)camDenied;

+ (void)showActionSheet:(nullable id)weakSelf firstButton:(void(^_Nonnull)())firstButton secondButton:(void(^_Nonnull)())secondButton;
+ (void)openQRCodeScanner:(nullable id)weakSelf;
+ (void)openLocalPhoto:(nullable id) weakself;
+ (void)gotoQRcoode:(nullable id)weakSelf;
+ (void)openLocalPhotoAlbum:(nullable id)weakSelf;
+ (NSString*) formatWOECCoint:(NSNumber *)number;
+ (BOOL)validatePaymentId:(NSString *)value;
+ (MFSideMenuContainerViewController*)createHomeControllerByMFSideMenu;
+ (UINavigationController *)navigationForPresentModalWithRootView:(id)rootView;
+ (LEAlertController *) showAlertConfirm:(NSString *_Nullable) message cancelButton:(void(^)())cancelButton okButton:(void(^)())okButton;
+ (NSString *_Nonnull) randomStringWithLength;
@end
