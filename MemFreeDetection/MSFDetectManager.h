//
//  MSFReferenceManager.h
//  ForTest
//
//  Created by apple on 2019/6/16.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MSFExcepitonBlock)(NSDictionary * exceptionInfo);

/**
 持有和管理内存信息
 */
@interface MSFDetectManager : NSObject

+ (instancetype)sharedManager;

// 建立回调
- (void)didDetectedTheMemFreeException:(MSFExcepitonBlock)block;

- (void)beginDetectViewController:(id)viewController;

@end

NS_ASSUME_NONNULL_END
