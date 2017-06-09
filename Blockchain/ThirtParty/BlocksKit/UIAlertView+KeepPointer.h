//
//  UIAlertView+KeepPointer.h
//  CPOMobile
//
//  Created by Nguyen Van Chuyen on 10/25/16.
//
//

#import <UIKit/UIKit.h>

@interface UIAlertView (KeepPointer)

/**
 *  Dismiss all visible alert view thar are kept pointer.
 */
+ (void)dismissAllAlertView:(BOOL)animated;
- (void)keepPointer;
@end
