//
//  UINavigationController+MSFswizzle.m
//  ForTest
//
//  Created by apple on 2019/6/16.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import "UINavigationController+MSFswizzle.h"
#import "MSFDetectManager.h"

@implementation UINavigationController (MSFswizzle)

- (nullable UIViewController *)msf_popViewControllerAnimated:(BOOL)animated {
    UIViewController * popV = [self msf_popViewControllerAnimated:animated];
    [[MSFDetectManager sharedManager] beginDetectViewController:popV];
    return popV;
}

- (nullable NSArray<__kindof UIViewController *> *)msf_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray * popVs = [self msf_popToViewController:viewController animated:animated];
    [[MSFDetectManager sharedManager] beginDetectViewController:popVs];
    return popVs;
}

- (nullable NSArray<__kindof UIViewController *> *)msf_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray * popVs = [self msf_popToRootViewControllerAnimated:animated];
    [[MSFDetectManager sharedManager] beginDetectViewController:popVs];
    return popVs;
}

@end
