//
//  MSFMemoryHelperManger.m
//  MSFMemoryDetectDemo
//
//  Created by apple on 2019/6/23.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import "MSFMemoryHelperManger.h"

@interface MSFMemoryHelperManger()

@property (nonatomic, strong) NSMutableArray    * tempArray;//

@end

@implementation MSFMemoryHelperManger

+ (instancetype)sharedManager {
    static MSFMemoryHelperManger * __sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [MSFMemoryHelperManger new];
    });
    return __sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.tempArray = [NSMutableArray array];
    }
    return self;
}

- (void)storeTheObject:(id)object {
    if (object) {
        [self.tempArray addObject:object];
    }
}

- (void)unStoreTheObject:(id)object {
    if ([self.tempArray containsObject:object]) {
        [self.tempArray removeObject:object];
    }
}

@end
