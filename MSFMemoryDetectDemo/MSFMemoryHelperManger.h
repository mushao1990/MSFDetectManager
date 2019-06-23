//
//  MSFMemoryHelperManger.h
//  MSFMemoryDetectDemo
//
//  Created by apple on 2019/6/23.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 单例对象  目的是为了帮助实现内存泄漏
 
 注： 一般项目中的内存泄漏都是由于循环引用等原因导致对象不释放。这里用单例去持有这些对象，以实现对象不释放。
 */
@interface MSFMemoryHelperManger : NSObject

+ (instancetype)sharedManager;

- (void)storeTheObject:(id)object;

- (void)unStoreTheObject:(id)object;

@end

NS_ASSUME_NONNULL_END
