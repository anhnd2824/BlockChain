//
//  ProfileDataManager.h
//  CloudPortalOffice
//
//  Created by MIC on 9/30/14.
//

#import <Foundation/Foundation.h>
#import "ProfileData.h"
@interface ProfileDataManager : NSObject

+ (ProfileDataManager *)sharedInstance;
@property (copy, nonatomic) NSString *baseDir;

- (ProfileData*)loadProfileData; 
- (BOOL)replaceProfileData:(ProfileData*)profileData;
- (void)initDefaultData;


@end
