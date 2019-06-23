//
//  MSFClassInfo.m
//  ForTest
//
//  Created by apple on 2019/6/16.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import "MSFClassInfo.h"
#import <objc/runtime.h>

@interface MSFObjectInfo : NSObject

@property (nonatomic, weak) id    object;// 变量对象

@property (nonatomic, copy) NSString    * varibleName;// 变量名字

@property (nonatomic, strong) MSFObjectInfo    * previousInfo;// 前一个信息

@property (nonatomic, strong) NSMutableArray    * nextInfoArrays;// 后面的

+ (instancetype)genrateOneObjectWithObject:(id)object;

@end

@implementation MSFObjectInfo

+ (instancetype)genrateOneObjectWithObject:(id)object {
    MSFObjectInfo * info = [MSFObjectInfo new];
    info.object = object;
    info.nextInfoArrays = [NSMutableArray array];
    return info;
}

@end

@implementation MSFClassInfo

static inline BOOL msf_isSystemClas(NSString * className) {
    return msf_isHasNSPrefix(className)||msf_isHasUIPrefix(className);
}

static inline BOOL msf_isHasNSPrefix(NSString * className) {
    if ([className hasPrefix:@"NS"] || [className hasPrefix:@"__NS"] || [className hasPrefix:@"CA"]) {
        return YES;
    }
    return NO;
}

static inline BOOL msf_isHasUIPrefix(NSString * className) {
    if ([className hasPrefix:@"UI"]) {
        return YES;
    }
    return NO;
}

static inline BOOL msf_isObject(NSString * attributeStr) { // TODO 待扩展 只考虑了strong修饰的变量
    if ([attributeStr rangeOfString:@",&"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (NSArray *)receiveTheInfoOfClassInstance:(id)target {
    if (!target) {
        return nil;
    }
    
    if ([target isKindOfClass:NSArray.class]) {
        NSArray * tempArr = (NSArray *)target;
        NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:tempArr.count];
        for (id obj in tempArr) {
            MSFObjectInfo * objectInfo = [MSFObjectInfo genrateOneObjectWithObject:obj];
            objectInfo.varibleName = NSStringFromClass([obj class]);
            [self p_receiveTheInfoForTarget:obj andObjectInfoModel:objectInfo];
            [tempArray addObject:objectInfo];
        }
        return [tempArray copy];
    }
    else {
        MSFObjectInfo * objectInfo = [MSFObjectInfo genrateOneObjectWithObject:target];
        objectInfo.varibleName = NSStringFromClass([target class]);
        [self p_receiveTheInfoForTarget:target andObjectInfoModel:objectInfo];
        return @[objectInfo];
    }
}

+ (void)p_receiveTheInfoForTarget:(id)target andObjectInfoModel:(MSFObjectInfo *)objectInfoModel {
    [self p_receiveThePropertiesWithTarget:target andObjectInfoModel:objectInfoModel];
}

+ (void)p_receiveThePropertiesWithTarget:(id)target andObjectInfoModel:(MSFObjectInfo *)objectInfoModel {
    
    Class targetClass = [target class];
    NSString * className = NSStringFromClass(targetClass);
    //过滤系统的类库
    if (msf_isSystemClas(className)) {
        return;
    }
    unsigned int propertyCount = 0;
    objc_property_t * proerty_ts = class_copyPropertyList(targetClass, &propertyCount);
    if (proerty_ts) {
        for (unsigned int i = 0; i < propertyCount; i++) {
            objc_property_t pro = proerty_ts[i];
            const char * name = property_getName(pro);
            const char * attribute = property_getAttributes(pro);
            NSString * attributeStr = [[NSString alloc] initWithCString:attribute encoding:NSUTF8StringEncoding];
            if (msf_isObject(attributeStr)) {
                NSString * key = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
                SEL selector = NSSelectorFromString(key);
                if ([target respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    id newTarget = [target performSelector:selector];
#pragma clang diagnostic pop
                    if (newTarget && !msf_isHasNSPrefix(NSStringFromClass([newTarget class]))) { // 暂时也过滤掉了NS开头的，因为考虑到字符串的生命周期问题
                        MSFObjectInfo * nextObject = [MSFObjectInfo genrateOneObjectWithObject:newTarget];
                        nextObject.varibleName = key;
                        [objectInfoModel.nextInfoArrays addObject:nextObject];
                        nextObject.previousInfo = objectInfoModel;
                        [self p_receiveTheInfoForTarget:newTarget andObjectInfoModel:nextObject];
                    }
                }
            }
        }
    }
    free(proerty_ts);
}

+ (NSArray *)judgeIsAllFree:(NSArray *)memoryInfoArray {
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:memoryInfoArray.count];
    for (MSFObjectInfo * objectInfo in memoryInfoArray) {
        NSString * leakInfo = [self p_findTheMemmoryLeakInfoWithObjectInfoModel:objectInfo];
        if (leakInfo) {
            [tempArray addObject:leakInfo];
        }
    }
    return [tempArray copy];
}

// 返回内存泄露的信息
+ (nullable NSString *)p_findTheMemmoryLeakInfoWithObjectInfoModel:(MSFObjectInfo *)objectInfoModel {
    if (objectInfoModel.object) {
        return [self p_thePathOfLeakWithObjectInfoModel:objectInfoModel];
    }
    else {
        if (objectInfoModel.nextInfoArrays.count <= 0) {
            return nil;
        }
        NSMutableString * tempStr = [NSMutableString string];
        for (MSFObjectInfo * subObjectInfo in objectInfoModel.nextInfoArrays) {
            NSString * objectInfoStr = [self p_findTheMemmoryLeakInfoWithObjectInfoModel:subObjectInfo];
            if (objectInfoStr) {
                [tempStr appendString:objectInfoStr];
            }
        }
        if (tempStr.length <= 0) {
            return nil;
        }
        return tempStr;
    }
    return nil;
}

// 返回泄露对象的路径
+ (NSString *)p_thePathOfLeakWithObjectInfoModel:(MSFObjectInfo *)objectInfo {
    NSString * objectInfoStr = [NSString stringWithFormat:@"可能泄露的对象：%@ %p",[objectInfo.object class],objectInfo.object];
    NSMutableString * pathInfoStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@ %p",[objectInfo.object class],objectInfo.object]];
    MSFObjectInfo * tempInfoModel = objectInfo.previousInfo;
    while (tempInfoModel) {
        [pathInfoStr insertString:[NSString stringWithFormat:@"%@-->",tempInfoModel.varibleName] atIndex:0];
        tempInfoModel = tempInfoModel.previousInfo;
    }
    NSString * resultStr = objectInfoStr;
    if (pathInfoStr.length > 2) {
        resultStr = [NSString stringWithFormat:@"\n%@\n参考路径:%@",objectInfoStr,pathInfoStr];
    }
    return resultStr;
}

// TOOD 取变量的时候，会将属性的也取到，所以暂时先不考虑变量
//+ (void)p_receiveTheIvarsWithTarget:(id)target andTable:(NSMapTable *)table {
//    Class targetClass = [target class];
//    unsigned int ivarCount = 0;
//    Ivar *ivars = class_copyIvarList(targetClass, &ivarCount);
//    if (ivars) {
//        for (unsigned int i = 0; i < ivarCount; i++) {
//            Ivar ivar = ivars[i];
//            const char * type = ivar_getTypeEncoding(ivar);
//            NSString * typeStr = [[NSString alloc] initWithCString:type encoding:NSUTF8StringEncoding];
//            NSLog(@"typeStr:%@",typeStr);
////            const char *name = ivar_getName(ivar);
//        }
//        free(ivars);
//    }
//}

@end
