//
//  MSFCommonAlertBaseView.h
//  MSF
//
//  Created by 慕少锋 on 2019/5/15.
//  Copyright © 2019 Leo. All rights reserved.
//

#import "MSFAlertBaseView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 机票可通用的alert弹窗
 */
@interface MSFCommonAlertBaseView : MSFAlertBaseView

/**
 弹出一个弹窗

 @param contentView 内容view 交给使用者自定义，需要对contentView做好约束（宽度和高度）
 @param title 标题 支持html
 @param subTitle 副标题 支持html
 @param buttonInfos 按钮的信息（最多支持两个按钮）
 例：@{@"title":@"",@"height":@44,@"titleColor":@"#333333",@"bgColor":@"#333333",@"fontSize":@18,@"bold":@YES}
                    默认设置： 字体大小18，按钮高度为50
                             左侧按钮：背景为 #F5F5F5，字体色值#666666
                             右侧按钮：背景为 tintColor，字体色值#ffffff
                    不传该参数，默认 一个按钮“我知道了”
 @param block 回调
 @return 返回一个实例
 
 // 最简单的例子：
 
     UIView * contentView = [[UIView alloc] initWithFrame:CGRectZero];
     contentView.backgroundColor = [UIColor redColor];
     [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.size.mas_equalTo(CGSizeMake(270, 100));
     }];
 
     [MSFCommonAlertBaseView showWithContentView:contentView title:@"温馨提示" subTitle:@"我是测试" andButtonInfos:nil completionBlock:^(NSInteger index) {
 
     }];
 
 */
+ (instancetype)showWithContentView:(nullable UIView *)contentView
                              title:(nullable NSString *)title
                           subTitle:(nullable NSString *)subTitle
                     andButtonInfos:(nullable NSArray <NSDictionary *> *)buttonInfos
                    completionBlock:(nullable ClickAtIndexBlock)block;

@end

NS_ASSUME_NONNULL_END
