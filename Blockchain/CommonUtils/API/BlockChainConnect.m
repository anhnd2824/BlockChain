//
//  BlockChainConnect.m
//  WOEC
//
//  Created by Tuannq on 5/4/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import "BlockChainConnect.h"
#import "AFNetworking.h"
#import "AppConst.h"


@implementation BlockChainConnect
+ (BlockChainConnect *)sharedInstance {
    static dispatch_once_t onceToken;
    static BlockChainConnect *sharedInstance = nil;
    // make sure it run only one
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[BlockChainConnect alloc] init];
        }
    });
    return sharedInstance;
}

/**
 Common Header
 */
- (void)setHeaderForRequest:(AFHTTPRequestOperationManager *)manager {
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@%@", kPostCommonBearer, [HelperMethods getuserClientId], [HelperMethods getAccessToken]] forHTTPHeaderField:kPostCommonAuthorization];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[HelperMethods getUserName]] forHTTPHeaderField:kPostCommonUsername];
}

/**
 API working
 */

- (void)postAction:(NSString *)url params:(NSDictionary *)param successBlock:(void(^)(NSDictionary *responseDict))completion failure:(void(^)(NSInteger failureCode))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
        [self setHeaderForRequest:manage];
        manage.responseSerializer = [AFHTTPResponseSerializer serializer];
        manage.requestSerializer = [AFJSONRequestSerializer serializer];
        [manage.requestSerializer setTimeoutInterval:HTTP_REQUEST_TIME_OUT];
        [manage POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:NULL];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:url]];
                    ProfileData *profileData = [[ProfileDataManager sharedInstance] loadProfileData];
                    for (NSHTTPCookie* cookie in cookies) {
                        if ([cookie.name isEqualToString:@"connect.sid"]) {
//                            NSLog(@"%@ - %@" , cookie.value, cookie.name);
                            NSString *cookies = [NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value];
                            profileData.cookie = cookies;
                            [[ProfileDataManager sharedInstance] replaceProfileData:profileData];
                            break;
                        }
                        
                    }
                    completion(jsonResponse);
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(operation.response.statusCode);
                });
            }
        }];
    });
}



/**
 Post with Header

 @param url <#url description#>
 @param param <#param description#>
 @param header <#header description#>
 @param completion <#completion description#>
 @param failure <#failure description#>
 */
- (void)postAction:(NSString *)url params:(NSDictionary *)param header:(NSDictionary *)header successBlock:(void(^)(NSDictionary *responseDict))completion failure:(void(^)(NSInteger failureCode))failure {
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
        manage.responseSerializer = [AFHTTPResponseSerializer serializer];
        manage.requestSerializer = [AFJSONRequestSerializer serializer];
        [manage.requestSerializer setTimeoutInterval:HTTP_REQUEST_TIME_OUT];
        [manage POST:url parameters:param parameterheader:header success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:NULL];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(jsonResponse);
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(operation.response.statusCode);
                });
            }
        }];
        
    });
}



- (void)getAction:(NSString *)url successBlock:(void(^)(NSDictionary *responseDict))completion failure:(void(^)(NSInteger failureCode))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        
        AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
        [self setHeaderForRequest:manage];
        manage.responseSerializer = [AFHTTPResponseSerializer serializer];
        //        manage.requestSerializer = [AFJSONRequestSerializer serializer];
        [manage.requestSerializer setTimeoutInterval:HTTP_REQUEST_TIME_OUT];
        [manage GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:NULL];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(jsonResponse);
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(operation.response.statusCode?:500);
                });
            }
        }];
    });
}

@end
