//
//  UIViewController+MSFswizzle.m
//  ForTest
//
//  Created by apple on 2019/6/16.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import "UIViewController+MSFswizzle.h"
#import "MSFDetectManager.h"

@implementation UIViewController (MSFswizzle)

- (void)msf_dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    [self msf_dismissViewControllerAnimated:flag completion:completion];
    [[MSFDetectManager sharedManager] beginDetectViewController:self];
}

@end
