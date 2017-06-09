//
//  HomeViewController.m
//  WOEC
//
//  Created by Tuannq on 5/2/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import "HomeViewController.h"
#import "TabBarSegue.h"
#import "CommonUtils.h"
#import "UIAlertView+Blocks.h"
#import "UserInfoViewController.h"
#import "SendViewController.h"

@interface HomeViewController ()

@end

NSString *const CustomTabBarControllerViewControllerChangedNotification = @"CustomTabBarControllerViewControllerChangedNotification";
NSString *const CustomTabBarControllerViewControllerAlreadyVisibleNotification = @"CustomTabBarControllerViewControllerAlreadyVisibleNotification";

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllersByIdentifier = [NSMutableDictionary dictionary];
//    [[[UIApplication sharedApplication] keyWindow] recursiveDescription]
    //Add bagde
    _badgeView = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 24.0, 24.0)];
    _badgeView.text = @"0";
    _badgeView.hidesWhenZero = YES;
    _badgeView.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
    [_balanceView addSubview:_badgeView];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.childViewControllers.count < 1) {
        [self performSegueWithIdentifier:@"viewController1" sender:[self.buttons objectAtIndex:0]];
    }
}
#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (![segue isKindOfClass:[TabBarSegue class]]) {
        [super prepareForSegue:segue sender:sender];
        return;
    }
    
    self.oldViewController = self.destinationViewController;
    
    //if view controller isn't already contained in the viewControllers-Dictionary
    if (![self.viewControllersByIdentifier objectForKey:segue.identifier]) {
        [self.viewControllersByIdentifier setObject:segue.destinationViewController forKey:segue.identifier];
    }
    
    [self.buttons setValue:@NO forKeyPath:@"selected"];
    [sender setSelected:YES];
    self.selectedIndex = [self.buttons indexOfObject:sender];
    
    self.destinationIdentifier = segue.identifier;
    self.destinationViewController = [self.viewControllersByIdentifier objectForKey:self.destinationIdentifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CustomTabBarControllerViewControllerChangedNotification object:nil];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self.destinationIdentifier isEqual:identifier]) {
        //Dont perform segue, if visible ViewController is already the destination ViewController
        [[NSNotificationCenter defaultCenter] postNotificationName:CustomTabBarControllerViewControllerAlreadyVisibleNotification object:nil];
        return NO;
    }
    
    return YES;
}
- (IBAction)qrCodeAction:(id)sender {
    self.menuContainerViewController.panGestureDelegate = self;
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        if (self.menuContainerViewController.menuState == MFSideMenuStateRightMenuOpen){
            
            self.menuContainerViewController.panMode = MFSideMenuPanModeSideMenu|MFSideMenuPanModeCenterViewController;
            
            UserInfoViewController *rightMenuView = (UserInfoViewController*)self.menuContainerViewController.rightMenuViewController;
            [rightMenuView beginAppearanceTransition:YES animated:NO];
            [rightMenuView endAppearanceTransition];
            
        } else if (self.menuContainerViewController.menuState == MFSideMenuStateClosed){
            self.menuContainerViewController.panMode = MFSideMenuPanModeSideMenu;
        }
    }];
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [[self.viewControllersByIdentifier allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if (![self.destinationIdentifier isEqualToString:key]) {
            [self.viewControllersByIdentifier removeObjectForKey:key];
        }
    }];
    
    [super didReceiveMemoryWarning];
}

#pragma mark - QRCodeReader Delegate Methods
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", result);
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark : Asset picker controller
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
    {
        //ios8.0之后支持
        __weak __typeof(self) weakSelf = self;
        [LBXScanNative recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
            [weakSelf scanResultWithArray:array];
        }];
    }
    else
    {
        [CommonUtils showCPOMessage:@"App not support for IOS 8 "];
    }
}
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [CommonUtils showCPOMessage:@"Not result"];
        
        return;
    }
    
    //Get value image
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    if (!array[0].strScanned || [array[0].strScanned isEqualToString:@""] ) {
        
        [CommonUtils showCPOMessage:@"Not result"];
        return;
    }
//    LBXScanResult *scanResult = array[0];
}


#pragma wcaction Sheet delegate 
- (void)actionSheetCancel:(WCActionSheet *)actionSheet {
    
}

- (void)actionSheet:(WCActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    ;
}

- (void)actionSheet:(WCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    ;
}

- (void)actionSheet:(WCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    ;
}

- (void)willPresentActionSheet:(WCActionSheet *)actionSheet {
    ;
}

- (void)didPresentActionSheet:(WCActionSheet *)actionSheet {
    ;
}

- (IBAction)refreshAction:(id)sender {
    _badgeView.text = @"1";
    _badgeView.hidesWhenZero = NO;
    _badgeView.shadowBorder = YES;
    
    
    //Add bagde to App icon
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
}

- (void) showPasscodeView{
    [self closeRightMenu];
    if (![self.destinationViewController isKindOfClass:[SendViewController class]]) {
        [self performSegueWithIdentifier:@"viewController1" sender:[self.buttons objectAtIndex:0]];
    }
    SendViewController *sendVC = (SendViewController *)self.destinationViewController;
    [sendVC changePinCodeView];
}

- (void) closeRightMenu{
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}
- (void) signOut{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self closeRightMenu];
        ProfileData *profileData = [[ProfileDataManager sharedInstance] loadProfileData];
        profileData.isLogin = false;
        profileData.cookie = MSG_BLANK;
        [[ProfileDataManager sharedInstance] replaceProfileData:profileData];
        [self.navigationController popViewControllerAnimated:NO];
    });
}

@end
