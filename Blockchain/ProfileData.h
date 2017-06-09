//
//  ProfileData.h
//  CloudPortalOffice
//
//  Created by MIC on 9/30/14.
//

#import <Foundation/Foundation.h>

@interface ProfileData : NSObject<NSCoding>

// Setting
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *pass;
@property (copy, nonatomic) NSString *passwordNotEncode;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *pass2;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *v;
@property (copy, nonatomic) NSString *activation;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *pinCode;
@property (assign, nonatomic) BOOL isLogin;
@property (copy, nonatomic) NSString *cookie;
@end
