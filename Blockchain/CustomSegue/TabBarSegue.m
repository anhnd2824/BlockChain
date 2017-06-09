//
//  TabBarSegue.m
//  WOEC
//
//  Created by Tuannq on 5/2/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import "TabBarSegue.h"
#import "HomeViewController.h"

@implementation TabBarSegue
- (void)perform {
    HomeViewController *tabBarViewController = (HomeViewController *)self.sourceViewController;
    UIViewController *destinationViewController = (UIViewController *)tabBarViewController.destinationViewController;
    
    //remove old viewController
    if (tabBarViewController.oldViewController) {
        [tabBarViewController.oldViewController willMoveToParentViewController:nil];
        [tabBarViewController.oldViewController.view removeFromSuperview];
        [tabBarViewController.oldViewController removeFromParentViewController];
    }
    
    destinationViewController.view.frame = tabBarViewController.container.bounds;
    [tabBarViewController addChildViewController:destinationViewController];
    [tabBarViewController.container addSubview:destinationViewController.view];
    [destinationViewController didMoveToParentViewController:tabBarViewController];
}
@end
