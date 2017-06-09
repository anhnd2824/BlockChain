//
//  UIAlertView+KeepPointer.m
//  CPOMobile
//
//  Created by Nguyen Van Chuyen on 10/25/16.
//
//

#import "UIAlertView+KeepPointer.h"

static NSPointerArray *pointerArray;

@implementation UIAlertView (KeepPointer)

+ (void)dismissAllAlertView:(BOOL)animated {
    while (0 < pointerArray.count) {
        if ([pointerArray pointerAtIndex:0]) {
            UIAlertView *alertView = (__bridge UIAlertView *)[pointerArray pointerAtIndex:0];
            [alertView dismissWithClickedButtonIndex:-1 animated:animated];
        }
        [pointerArray removePointerAtIndex:0];
    }
}

- (void)keepPointer {
    if (!pointerArray) {
        pointerArray = [NSPointerArray weakObjectsPointerArray];
    }
    
    int i = 0;
    while (i < pointerArray.count) {
        if ([pointerArray pointerAtIndex:i]) {
            i++;
            continue;
        }
        
        [pointerArray removePointerAtIndex:i];
    }
    [pointerArray addPointer:(__bridge void *)self];
}

@end
