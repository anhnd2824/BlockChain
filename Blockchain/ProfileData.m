//
//  ProfileData.m
//  CloudPortalOffice
//
//  Created by MIC on 9/30/14.
//

#import "ProfileData.h"

@implementation ProfileData
- (instancetype)init {
    if ((self = [super init]) == nil) {
        return nil;
    }
    return self;
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    self.email = [aDecoder decodeObjectForKey:@"email"];
    self.pass = [aDecoder decodeObjectForKey:@"pass"];
    self.userId = [aDecoder decodeObjectForKey:@"userId"];
    self.pass2 = [aDecoder decodeObjectForKey:@"pass2"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.v = [aDecoder decodeObjectForKey:@"v"];
    self.activation = [aDecoder decodeObjectForKey:@"activation"];
    self.address = [aDecoder decodeObjectForKey:@"address"];
    self.passwordNotEncode = [aDecoder decodeObjectForKey:@"passwordNotEncode"];
    self.pinCode = [aDecoder decodeObjectForKey:@"pinCode"];
    self.isLogin = [aDecoder decodeBoolForKey:@"isLogin"];
    self.cookie = [aDecoder decodeObjectForKey:@"cookie"];
    return self;
}

- (void) encodeWithCoder:(NSCoder*) coder {
    
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeObject:self.pass forKey:@"pass"];
    [coder encodeObject:self.userId forKey:@"userId"];
    [coder encodeObject:self.pass2 forKey:@"pass2"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.v forKey:@"v"];
    [coder encodeObject:self.activation forKey:@"activation"];
    [coder encodeObject:self.address forKey:@"address"];
    [coder encodeObject:self.passwordNotEncode forKey:@"passwordNotEncode"];
    [coder encodeObject:self.pinCode forKey:@"pinCode"];
    [coder encodeBool:self.isLogin forKey:@"isLogin"];
    [coder encodeObject:self.cookie forKey:@"cookie"];
}
@end
