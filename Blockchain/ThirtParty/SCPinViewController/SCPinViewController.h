//
//  SCPinViewController.h
//  SCPinViewController
//
//  Created by Maxim Kolesnik on 15.07.16.
//  Copyright © 2016 Sugar and Candy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtils.h"

@protocol SCPinViewControllerValidateDelegate;
@protocol SCPinViewControllerCreateDelegate;
@protocol SCPinViewControllerDataSource;
@class SCPinAppearance;
typedef NS_ENUM(NSInteger, SCPinViewControllerScope) {
    SCPinViewControllerScopeValidate,
    SCPinViewControllerScopeCreate,
    SCPinViewControllerScopeEdit
};

typedef NS_ENUM(NSInteger, SCPinViewControllerScopeEditView) {
    SCPinViewControllerScopeEditViewValidate,
    SCPinViewControllerScopeEditViewCreate
};

@interface SCPinViewController : UIViewController
- (instancetype)initWithScope:(SCPinViewControllerScope)scope;

+ (SCPinAppearance *)appearance;
+ (void)setNewAppearance:(SCPinAppearance *)newAppearance;


@property (nonatomic, assign) SCPinViewControllerScope scope;
@property (nonatomic, assign) SCPinViewControllerScopeEditView editScope;

@property (nonatomic, weak) id<SCPinViewControllerCreateDelegate> createDelegate;
@property (nonatomic, weak) id<SCPinViewControllerValidateDelegate> validateDelegate;
@property (nonatomic, weak) id<SCPinViewControllerDataSource> dataSource;
@property (nonatomic) NSInteger numberWrong;

@end

@protocol SCPinViewControllerValidateDelegate <NSObject>
@required
/**
 *  when user set wrong pin code calling this delegate method
 */
-(void)pinViewControllerDidSetWrongPin:(SCPinViewController *)pinViewController numberWrong:(NSInteger)number;
/**
 *  when user set correct pin code calling this delegate method
 */
-(void)pinViewControllerDidSetСorrectPin:(SCPinViewController *)pinViewController;
@end

@protocol SCPinViewControllerCreateDelegate <NSObject>
@required
/**
 *  when user set new pin code calling this delegate method
 */
-(void)pinViewController:(SCPinViewController *)pinViewController didSetNewPin:(NSString *)pin;
-(NSInteger)lengthForPin;
@end

@protocol SCPinViewControllerDataSource <NSObject>
@required
/**
 *  Pin code for controller. Supports from 2 to 8 characters
 */
-(NSString *)codeForPinViewController:(SCPinViewController *)pinViewController;

@optional
-(BOOL)hideTouchIDButtonIfFingersAreNotEnrolled;
-(BOOL)showTouchIDVerificationImmediately;
@end
