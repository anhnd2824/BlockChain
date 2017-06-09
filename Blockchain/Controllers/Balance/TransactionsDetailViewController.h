//
//  TransactionsDetailViewController.h
//  WOEC
//
//  Created by Tuannq on 5/5/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionDetail.h"

@interface TransactionsDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbtransactionHash;
@property (weak, nonatomic) IBOutlet UITextField *tfType;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfAmount;
@property (weak, nonatomic) IBOutlet UITextField *tfFee;
@property (weak, nonatomic) IBOutlet UIButton *btnBlockIndex;
@property (weak, nonatomic) IBOutlet UITextField *tfPayment;
@property (weak, nonatomic) IBOutlet UITextField *tfUnlockTime;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@property (strong, nonatomic) TransactionDetail *tranObj;
@end
