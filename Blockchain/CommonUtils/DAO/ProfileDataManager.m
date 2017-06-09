//
//  ProfileDataManager.h
//  CloudPortalOffice
//
//  Created by MIC on 9/30/14.
//

#import "ProfileDataManager.h"
#import "AppConst.h"
#import "CommonUtils.h"

@implementation ProfileDataManager

+ (ProfileDataManager *)sharedInstance{
    static ProfileDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ProfileDataManager alloc] init];
    });
    return manager;
}
- (instancetype)init {
    if ((self = [super init]) == nil) {
        return nil;
    }
    self.baseDir = [CommonUtils getDocumentDir];
    return self;
}

- (ProfileData*)loadProfileData {
    NSString *filePath = [self.baseDir stringByAppendingPathComponent:PROFILEDATA_NAME];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    ProfileData *profileData = [[ProfileData alloc] init];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        profileData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    return profileData;
}

- (BOOL)replaceProfileData:(ProfileData*)data {
    NSString *filePath = [self.baseDir stringByAppendingPathComponent:PROFILEDATA_NAME];
    return [NSKeyedArchiver archiveRootObject:data toFile:filePath];
}
- (void)initDefaultData {
    
    ProfileData *profileData = [[ProfileDataManager sharedInstance] loadProfileData];
    profileData.email = @"";
    profileData.pass = @"";
    profileData.userId = @"";
    profileData.pass2 = @"";
    profileData.name = @"";
    profileData.v = @"";
    profileData.activation = @"";
    
    [self replaceProfileData:profileData];
}

@end
