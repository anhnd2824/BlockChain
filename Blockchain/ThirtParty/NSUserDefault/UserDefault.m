//
//  NHUserDefault.m
//  ViettelPI
//
//  Created by nhantd on 3/11/14.
//  Copyright (c) 2014 viettel. All rights reserved.
//

#import "UserDefault.h"

@implementation UserDefault


+ (void)addObjectForKey:(id)value key:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (id)getObjectWithKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}


+ (void)addBoolForKey:(BOOL)value key:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}

+ (BOOL)getBoolWithKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

+ (void)removeObjectForKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

+ (void) removeAllUserDefaults
{
//    [UserDefault removeObjectForKey:USER_DEFAULTS_TOKEN];
//    [UserDefault removeObjectForKey:USER_DEFAULTS_USER_ID];
//    
//    [UserDefault removeObjectForKey:USER_DEFAULTS_GROUP_ROOT];
//    [UserDefault removeObjectForKey:USER_DEFAULTS_ROLE_ID];
//    
//    [UserDefault removeObjectForKey:DEVICE_PIN_VEHICLE];
//    [UserDefault removeObjectForKey:REG_NO_VEHICLE];
//    [UserDefault removeObjectForKey:DEVICE_TYPE];
//    [UserDefault removeObjectForKey:PHONE_NUMBER];
//    [UserDefault removeObjectForKey:LATITUDE];
//    [UserDefault removeObjectForKey:LONGITUDE];
//    [UserDefault removeObjectForKey:STATE];
//    [UserDefault removeObjectForKey:GPS_SPEED];
//    [UserDefault removeObjectForKey:ID];
//    [UserDefault removeObjectForKey:TIME_STATE];
//    
//    [UserDefault removeObjectForKey:USER_DEFAULTS_SEARCH_REGNO];
//    [UserDefault removeObjectForKey:USER_DEFAULTS_SEARCH_STATE];
//    [UserDefault removeObjectForKey:USER_DEFAULTS_SEARCH_GROUP];
}


@end
