//
//  BalanceViewController.h
//  WOEC
//
//  Created by Tuannq on 5/5/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConst.h"
#import "ProfileDataManager.h"
#import "ProfileData.h"

@interface BalanceViewController : UIViewController{
    NSMutableArray *transactionsListArr;
    NSMutableArray *transactionsListSendArr;
    NSMutableArray *transactionsListReceiveArr;
    NSTimer *timer;
    BOOL timerIsRunning;
}
@property (weak, nonatomic) IBOutlet UITableView *transactionTable;
@property (weak, nonatomic) IBOutlet UIView *transactionsListView;
@property (weak, nonatomic) IBOutlet UIView *paymentListView;
@property (weak, nonatomic) IBOutlet UITableView *paymentListTable;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (nonatomic) NSInteger selectedIndex;

@end
