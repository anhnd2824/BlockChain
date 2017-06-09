//
//  SearchViewController.h
//  Blockchain
//
//  Created by Tuannq on 5/8/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "SWTableViewCell.h"
#import "QRCodeReaderViewController.h"

#import "LBXScanPermissions.h"
#import "LBXAlertAction.h"
#import "LBXScanNative.h"
#import "UIAlertView+Blocks.h"
#import "UIAlertView+KeepPointer.h"
#import "LEAlertController.h"

@interface SearchViewController : UIViewController<UITextFieldDelegate,SWTableViewCellDelegate,QRCodeReaderDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WCActionSheetDelegate, UIAlertViewDelegate>
{
    NSMutableArray *contactList;
    DBManager *dbManager;
    NSInteger statusScreen;
    Contact *contactModify;
    UIAlertView *alertProgressWait;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIView *conntentView;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UIView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIView *displayView;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (copy, nonatomic) void (^searchBlock)(Contact *contact);
@end
