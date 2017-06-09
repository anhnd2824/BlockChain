//
//  TimelineTableViewCell.m
//  WOEC
//
//  Created by Tuannq on 5/5/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import "TimelineTableViewCell.h"
#import "NSDate+TimeAgo.h"


@implementation TimelineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setModel:(TransactionDetail *) transObject {
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:transObject.time];
    NSString *timeAgo = [date timeAgo];

    if ([transObject.blockIndex floatValue] == 4294967295) {
        self.lbblockHeight.text = MSG_BLANK;
        self.lbtimeSent.text = @"Just now";
    }else{
        self.lbblockHeight.text = transObject.blockIndex;
        self.lbtimeSent.text = timeAgo;
    }
    
    self.lbtransactionsHash.text = transObject.transactionHash;
    self.lbAmount.text = [CommonUtils formatWOECCoint:transObject.amount];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (transObject.output) {
            [self.ImgTransactionType setImage:[UIImage imageNamed:@"send_icon.png"]];
        }else {
            [self.ImgTransactionType setImage:[UIImage imageNamed:@"receive_icon.png"]];
        }
        
        if (transObject.time == 0) {
            [self.statusTransaction setImage:[UIImage imageNamed:@"no_icon.png"]];
        }else {
            [self.statusTransaction setImage:[UIImage imageNamed:@"yes_icon.png"]];
        }
    });
}

@end
