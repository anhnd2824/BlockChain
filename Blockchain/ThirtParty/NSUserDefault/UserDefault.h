//
//  NHUserDefault.h
//  ViettelPI
//
//  Created by nhantd on 3/11/14.
//  Copyright (c) 2014 viettel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefault : NSObject

+ (void)addObjectForKey:(id)value key:(NSString*)key;
+ (id)getObjectWithKey:(NSString*)key;

+ (void)addBoolForKey:(BOOL)value key:(NSString*)key;
+ (BOOL)getBoolWithKey:(NSString*)key;

+ (void)removeObjectForKey:(NSString*)key;

+ (void) removeAllUserDefaults;

@end
