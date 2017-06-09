//
//  ReceiveViewController.m
//  WOEC
//
//  Created by Tuannq on 5/3/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import "ReceiveViewController.h"
#import "LBXScanNative.h"
#import "ProfileData.h"
#import "ProfileDataManager.h"

@interface ReceiveViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CommonUtils setBorderTextfield:self.addressView];
    [self getAddress];
    
    self.qrCodeImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(handlePinch:)];
    pgr.delegate = self;
    [self.qrCodeImage addGestureRecognizer:pgr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getAddress{
    UIAlertView *alert = [CommonUtils showProgressWaiting:MSG_LOADING];
    ProfileData *profileData  = [[ProfileDataManager sharedInstance] loadProfileData];
    NSString *urlGetAddress = [NSString stringWithFormat:URL_GET_ADDRESS,profileData.email,profileData.passwordNotEncode];
    [[BlockChainConnect sharedInstance] getAction:urlGetAddress successBlock:^(NSDictionary *responseDict) {
        NSDictionary *result = responseDict[@"result"];
        profileData.address = result[@"address"];
        self.qrCodeImage.image = [LBXScanNative createQRWithString:profileData.address QRSize:self.qrCodeImage.bounds.size];
        self.tfAddress.text = profileData.address;
        [[ProfileDataManager sharedInstance] replaceProfileData:profileData];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    } failure:^(NSInteger failureCode) {
        [CommonUtils showCPOMessage:@"Not generate captcha image"];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }];
}

-(void)launchMailAppOnDevice
{
//    NSString *emailTitle = @"Great Photo and Doc";
//    NSString *messageBody = @"Hey, check this out!";
//    NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
//    
//    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//    mc.mailComposeDelegate = self;
//    [mc setSubject:emailTitle];
//    [mc setMessageBody:messageBody isHTML:NO];
//    [mc setToRecipients:toRecipents];
//    
//    // Determine the file name and extension
//    NSArray *filepart = [@"qrcode.png" componentsSeparatedByString:@"."];
//    NSString *filename = [filepart objectAtIndex:0];
//    NSString *extension = [filepart objectAtIndex:1];
//    
//    // Get the resource path and read the file using NSData
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
//    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
//    
//    // Determine the MIME type
//    NSString *mimeType;
//    if ([extension isEqualToString:@"jpg"]) {
//        mimeType = @"image/jpeg";
//    } else if ([extension isEqualToString:@"png"]) {
//        mimeType = @"image/png";
//    } else if ([extension isEqualToString:@"doc"]) {
//        mimeType = @"application/msword";
//    } else if ([extension isEqualToString:@"ppt"]) {
//        mimeType = @"application/vnd.ms-powerpoint";
//    } else if ([extension isEqualToString:@"html"]) {
//        mimeType = @"text/html";
//    } else if ([extension isEqualToString:@"pdf"]) {
//        mimeType = @"application/pdf";
//    }
//    
//    // Add attachment
//    [mc addAttachmentData:fileData mimeType:mimeType fileName:filename];
//    
//    // Present mail view controller on screen
//    [self presentViewController:mc animated:YES completion:NULL];
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"A Message from MobileTuts+"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"fisrtMail@example.com", @"secondMail@example.com", nil];
        [mailer setToRecipients:toRecipients];
        
        NSData *imageData = UIImagePNGRepresentation(self.qrCodeImage.image);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:self.tfAddress.text];
        
        NSString *emailBody = @"Have you seen the MobileTuts+ web site?";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        // Present mail view controller on screen
        [self presentViewController:mailer animated:YES completion:NULL];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:BUTTON_OK
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)handlePinch:(UITapGestureRecognizer *)pinchGestureRecognizer
{
    [self launchMailAppOnDevice];
}

#pragma MFMail delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
