//
//  BlockChainConnect.h
//  WOEC
//
//  Created by Tuannq on 5/4/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockChainConnect : NSObject
+ (BlockChainConnect *)sharedInstance;
- (void)postAction:(NSString *)url params:(NSDictionary *)param successBlock:(void(^)(NSDictionary *responseDict))completion failure:(void(^)(NSInteger failureCode))failure;

- (void)postAction:(NSString *)url params:(NSDictionary *)param header:(NSDictionary *)header successBlock:(void(^)(NSDictionary *responseDict))completion failure:(void(^)(NSInteger failureCode))failure;

- (void)getAction:(NSString *)url successBlock:(void(^)(NSDictionary *responseDict))completion failure:(void(^)(NSInteger failureCode))failure;
@end
