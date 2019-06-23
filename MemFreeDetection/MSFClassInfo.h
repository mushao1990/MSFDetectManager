//
//  MSFClassInfo.h
//  ForTest
//
//  Created by apple on 2019/6/16.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 获取类信息的类
 */
@interface MSFClassInfo : NSObject

+ (NSArray *)receiveTheInfoOfClassInstance:(id)target;

+ (NSArray *)judgeIsAllFree:(NSArray *)memoryInfoArray;

@end

NS_ASSUME_NONNULL_END
