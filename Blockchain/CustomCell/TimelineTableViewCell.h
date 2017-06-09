//
//  TimelineTableViewCell.h
//  WOEC
//
//  Created by Tuannq on 5/5/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionDetail.h"

@interface TimelineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbtimeSent;
@property (weak, nonatomic) IBOutlet UILabel *lbblockHeight;
@property (weak, nonatomic) IBOutlet UILabel *lbtransactionsHash;
@property (weak, nonatomic) IBOutlet UILabel *lbAmount;
@property (weak, nonatomic) IBOutlet UIImageView *ImgTransactionType;
@property (weak, nonatomic) IBOutlet UIImageView *statusTransaction;


- (void) setModel:(TransactionDetail *) transObject;
@end
