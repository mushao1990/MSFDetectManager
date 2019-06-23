//
//  MSFReferenceManager.m
//  ForTest
//
//  Created by apple on 2019/6/16.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import "MSFDetectManager.h"
#import "MSFClassInfo.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

static inline void msf_exchangeSelector(Class target,SEL sel_firt,SEL sel_second) {
    Method m1 = class_getInstanceMethod(target, sel_firt);
    Method m2 = class_getInstanceMethod(target, sel_second);
    if (m2 != NULL && m1 != NULL) {
        method_exchangeImplementations(m1, m2);
    }
}

@interface MSFDetectManager()

@property (nonatomic, copy) MSFExcepitonBlock block;

@end

@implementation MSFDetectManager

+ (instancetype)sharedManager {
    static MSFDetectManager * __sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [MSFDetectManager new];
    });
    return __sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        // 先对vc进行方法交换
        Class navClass = NSClassFromString(@"UINavigationController");
        Class vcClass = NSClassFromString(@"UIViewController");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        msf_exchangeSelector(navClass, @selector(popViewControllerAnimated:), @selector(msf_popViewControllerAnimated:));
        msf_exchangeSelector(navClass, @selector(popToViewController:animated:), @selector(msf_popToViewController:animated:));
        msf_exchangeSelector(navClass, @selector(popToRootViewControllerAnimated:), @selector(msf_popToRootViewControllerAnimated:));
        msf_exchangeSelector(vcClass, @selector(dismissViewControllerAnimated:completion:), @selector(msf_dismissViewControllerAnimated:completion:));
#pragma clang diagnostic pop

    }
    return self;
}

- (void)beginDetectViewController:(id)viewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 获取信息
        NSArray * classInfoArray = [MSFClassInfo receiveTheInfoOfClassInstance:viewController];
        // 5秒后去验证是否所有的东西都被释放
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray * resultInfo = [MSFClassInfo judgeIsAllFree:classInfoArray];
            if (resultInfo.count > 0) {
                NSString * infoStr = [resultInfo componentsJoinedByString:@"\n"];
                if (self.block) {
                    self.block(@{@"info":infoStr});
                }
            }
        });
    });
}

- (void)didDetectedTheMemFreeException:(MSFExcepitonBlock)block {
    self.block = block;
}

@end
