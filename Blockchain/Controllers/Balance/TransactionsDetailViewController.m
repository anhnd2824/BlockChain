//
//  TransactionsDetailViewController.m
//  WOEC
//
//  Created by Tuannq on 5/5/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import "TransactionsDetailViewController.h"

@interface TransactionsDetailViewController ()

@end

@implementation TransactionsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentView.layer.cornerRadius = 10;
    
    self.lbtransactionHash.text = self.tranObj.transactionHash;
    self.tfType.text = self.tranObj.type;
    self.tfAddress.text = self.tranObj.address;
    self.tfAmount.text  = [CommonUtils formatWOECCoint:self.tranObj.amount];
    self.tfFee.text     = self.tranObj.fee;
    [self.btnBlockIndex setTitle:self.tranObj.blockIndex forState:UIControlStateNormal];
    self.tfPayment.text = self.tranObj.payment;
    self.tfUnlockTime.text = self.tranObj.unlockTime;
    if (self.tranObj.output) {
        self.tfType.text = @"Send";
    }else {
        self.tfType.text = @"Receive";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
