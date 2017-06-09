//
//  ReceiveViewController.h
//  WOEC
//
//  Created by Tuannq on 5/3/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ReceiveViewController : UIViewController<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImage;

@end
