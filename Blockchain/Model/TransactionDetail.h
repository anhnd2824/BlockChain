//
//  TransactionDetail.h
//  WOEC
//
//  Created by Tuannq on 5/5/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionDetail : NSObject


@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSNumber *amount;
@property (copy, nonatomic) NSString *fee;
@property (copy, nonatomic) NSString *blockIndex;
@property (copy, nonatomic) NSString *payment;
@property (copy, nonatomic) NSString *unlockTime;
@property (nonatomic) BOOL output;
@property (copy, nonatomic) NSString *transactionHash;
@property (nonatomic) NSTimeInterval time;

@end
