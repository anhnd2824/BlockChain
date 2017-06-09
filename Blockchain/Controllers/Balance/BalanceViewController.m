//
//  BalanceViewController.m
//  WOEC
//
//  Created by Tuannq on 5/5/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import "BalanceViewController.h"
#import "TimelineTableViewCell.h"
#import "CommonUtils.h"
#import "TransactionsDetailViewController.h"
#import "TransactionDetail.h"

@interface BalanceViewController ()

@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CommonUtils setBorderTextfield:self.transactionsListView];
    self.transactionsListView.layer.cornerRadius = 10.0;
    
    [CommonUtils setBorderTextfield:self.paymentListView];
    self.paymentListView.layer.cornerRadius = 10.0;
    self.paymentListTable.hidden = YES;
    [self getTransactionList];
    [self setTimerInBackground];

}

- (NSTimer *)setTimerInBackground{
    timerIsRunning = YES;
    return timer = [NSTimer scheduledTimerWithTimeInterval:20.0
                                                    target:self
                                                  selector:@selector(getTransactionListInBackGround)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (IBAction)segmentAction:(UISegmentedControl *)sender {
    self.selectedIndex = sender.selectedSegmentIndex;
    [self.transactionTable reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (self.selectedIndex) {
        case SegmentStateAll:
            return transactionsListArr.count;
            break;
        case SegmentStateSend:
            return transactionsListSendArr.count;
            break;
        case SegmentStateReceive:
            return transactionsListReceiveArr.count;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (void) getTransactionListInBackGround {
    if (![AppDelegate shared].networkStatus) {
        if (timerIsRunning) {
            [CommonUtils showCPOMessage:MSG_ERROR_NETWORK];
            timerIsRunning = NO;
        }
        return;
    }
//    NSLog(@"transaction list");
    timerIsRunning = YES;
    transactionsListArr = [[NSMutableArray alloc] init];
    transactionsListSendArr = [[NSMutableArray alloc] init];
    transactionsListReceiveArr = [[NSMutableArray alloc] init];
    ProfileData *profile = [[ProfileDataManager sharedInstance] loadProfileData];
    NSString *url = [NSString stringWithFormat:URL_GET_TRANSFERS,profile.email,profile.passwordNotEncode];
    
    [[BlockChainConnect sharedInstance] getAction:url successBlock:^(NSDictionary *responseDict) {
        NSDictionary *data = responseDict[@"result"];
        NSArray *transfers = data[@"transfers"];
        for (int i = 0; i < transfers.count; i++) {
            NSDictionary *transObject = transfers[i];
            TransactionDetail *transDetail = [[TransactionDetail alloc] init];
            transDetail.address = transObject[@"address"];
            transDetail.amount = transObject[@"amount"] ;
            transDetail.blockIndex = [transObject[@"blockIndex"] stringValue];
            transDetail.fee = [transObject[@"fee"] stringValue];
            transDetail.output = [transObject[@"output"] boolValue];
            transDetail.time = [transObject[@"time"] doubleValue];
            transDetail.transactionHash = transObject[@"transactionHash"];
            transDetail.unlockTime = [transObject[@"unlockTime"] stringValue];
            
            if (transDetail.output) {
                [transactionsListSendArr addObject:transDetail];
            }else {
                [transactionsListReceiveArr addObject:transDetail];
            }
            
            [transactionsListArr addObject:transDetail];
        }
        transactionsListReceiveArr = [[self compare:transactionsListReceiveArr] copy];
        transactionsListSendArr = [[self compare:transactionsListSendArr] copy];
        transactionsListArr = [[self compare:transactionsListArr] copy];
        [self.transactionTable reloadData];
        [self.paymentListTable reloadData];
    } failure:^(NSInteger failureCode) {
        NSLog(@"%ld", (long)failureCode);
    }];
}

- (void) getTransactionList{
    if (![AppDelegate shared].networkStatus) {
        [CommonUtils showCPOMessage:MSG_ERROR_NETWORK];
        return;
    }
    
    UIAlertView *alert = [CommonUtils showProgressWaiting:MSG_LOADING];
    
    transactionsListArr = [[NSMutableArray alloc] init];
    transactionsListSendArr = [[NSMutableArray alloc] init];
    transactionsListReceiveArr = [[NSMutableArray alloc] init];
    ProfileData *profile = [[ProfileDataManager sharedInstance] loadProfileData];
    NSString *url = [NSString stringWithFormat:URL_GET_TRANSFERS,profile.email,profile.passwordNotEncode];

    [[BlockChainConnect sharedInstance] getAction:url successBlock:^(NSDictionary *responseDict) {
        NSDictionary *data = responseDict[@"result"];
        NSArray *transfers = data[@"transfers"];
        for (int i = 0; i < transfers.count; i++) {
            NSDictionary *transObject = transfers[i];
            TransactionDetail *transDetail = [[TransactionDetail alloc] init];
            transDetail.address = transObject[@"address"];
            transDetail.amount = transObject[@"amount"] ;
            transDetail.blockIndex = [transObject[@"blockIndex"] stringValue];
            transDetail.fee = [transObject[@"fee"] stringValue];
            transDetail.output = [transObject[@"output"] boolValue];
            transDetail.time = [transObject[@"time"] doubleValue];
            transDetail.transactionHash = transObject[@"transactionHash"];
            transDetail.unlockTime = [transObject[@"unlockTime"] stringValue];
            
            if (transDetail.output) {
                [transactionsListSendArr addObject:transDetail];
            }else {
                [transactionsListReceiveArr addObject:transDetail];
            }
            
            [transactionsListArr addObject:transDetail];
        }
        transactionsListReceiveArr = [[self compare:transactionsListReceiveArr] copy];
        transactionsListSendArr = [[self compare:transactionsListSendArr] copy];
        transactionsListArr = [[self compare:transactionsListArr] copy];
        [self.transactionTable reloadData];
        [self.paymentListTable reloadData];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    } failure:^(NSInteger failureCode) {
        NSLog(@"%ld", (long)failureCode);
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    __weak typeof(self) weakSelf = self;
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",(long)indexPath.section, (long)indexPath.row];
    TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:kVC_TimelineTableViewCell owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    TransactionDetail *transObj;
    switch (self.selectedIndex) {
        case SegmentStateAll:
            transObj = [CommonUtils getTransactionInArray:transactionsListArr atIndex:indexPath.row];
            break;
        case SegmentStateSend:
            transObj = [CommonUtils getTransactionInArray:transactionsListSendArr atIndex:indexPath.row];
            break;
        case SegmentStateReceive:
            transObj = [CommonUtils getTransactionInArray:transactionsListReceiveArr atIndex:indexPath.row];
            break;
        default:
            break;
    }
    [cell setModel:transObj];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.paymentListTable]) {
        [self.paymentListTable deselectRowAtIndexPath:indexPath animated:NO];
    }else {
        [self.transactionTable deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TransactionsDetailViewController *transDetail = (TransactionsDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"TransactionsDetailViewController"];
//    transDetail.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [transDetail setModalPresentationStyle:UIModalPresentationCustom];
    [transDetail setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    switch (self.selectedIndex) {
        case SegmentStateAll:
            transDetail.tranObj = [CommonUtils getTransactionInArray:transactionsListArr atIndex:indexPath.row];
            break;
        case SegmentStateSend:
            transDetail.tranObj = [CommonUtils getTransactionInArray:transactionsListSendArr atIndex:indexPath.row];
            break;
        case SegmentStateReceive:
            transDetail.tranObj = [CommonUtils getTransactionInArray:transactionsListReceiveArr atIndex:indexPath.row];
            break;
        default:
            break;
    }
    [self presentViewController:transDetail animated:YES completion:nil];
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

//Sort Array
- (NSArray *)compare:(NSMutableArray *) scores{
    NSArray *sorted = [scores sortedArrayUsingComparator:^(id obj1, id obj2){
        if ([obj1 isKindOfClass:[TransactionDetail class]] && [obj2 isKindOfClass:[TransactionDetail class]]) {
            TransactionDetail *s1 = obj1;
            TransactionDetail *s2 = obj2;
            
            if ([s1.blockIndex floatValue] > [s2.blockIndex floatValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if ([s1.blockIndex floatValue] < [s2.blockIndex floatValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sorted;
}
@end
