//
//  HomeViewController.h
//  WOEC
//
//  Created by Tuannq on 5/2/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeReaderViewController.h"
#import "AppConst.h"
#import "LBXScanPermissions.h"
#import "LBXAlertAction.h"
#import "LBXScanNative.h"
#import "WCActionSheet.h"
#import "M13BadgeView.h"
#import "MFSideMenu.h"
#import "MFSideMenuContainerViewController.h"
#import "ProfileData.h"
#import "ProfileDataManager.h"

extern NSString *const CustomTabBarControllerViewControllerChangedNotification;
extern NSString *const CustomTabBarControllerViewControllerAlreadyVisibleNotification;

@interface HomeViewController : UIViewController<QRCodeReaderDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WCActionSheetDelegate,MFSideMenuContainerViewControllerPanProtocol, UIGestureRecognizerDelegate>{
    UITextView *resultText;
    UIImageView *resultImage;
}

@property (nonatomic, retain) M13BadgeView *badgeView;
@property (weak, nonatomic) IBOutlet UIView *balanceView;

@property (weak,nonatomic) UIViewController *destinationViewController;
@property (strong, nonatomic) UIViewController *oldViewController;
@property (weak, nonatomic) IBOutlet UIView *container;

@property (assign, nonatomic) NSInteger selectedIndex;

@property (nonatomic, strong) NSMutableDictionary *viewControllersByIdentifier;
@property (strong, nonatomic) NSString *destinationIdentifier;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
- (void) signOut;
- (void) closeRightMenu;
- (void) showPasscodeView;
@end
