//
//  MSFAlertBaseView.m
//  Ticket
//
//  Created by 慕少锋 on 2018/11/5.
//  Copyright © 2018 Arron Zhang. All rights reserved.
//

#import "MSFAlertBaseView.h"

@interface MSFAlertBaseView()

@property (nonatomic, copy) ClickBlock    clickBackGroundBlock;//

@property (nonatomic, strong) UIButton    * deleteButton;//

@property (nonatomic, weak) MSFAlertBaseView    * bgView;//

@end

@implementation MSFAlertBaseView

- (void)showInWindow {
    
    // 移除之前的
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView * subView in keyWindow.subviews) {
        if ([subView isKindOfClass:[MSFAlertBaseView class]]) {
            if (![(MSFAlertBaseView *)subView canNotRemoveByNextAlert]) {
                [subView removeFromSuperview];
            }
        }
    }
    
    // 添加背部遮罩
    MSFAlertBaseView  *bgViewNew = [[MSFAlertBaseView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgViewNew.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    bgViewNew.canNotRemoveByNextAlert = self.canNotRemoveByNextAlert;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTheBackGroundView)];
    [bgViewNew addGestureRecognizer:tapGesture];
    self.bgView = bgViewNew;
    [keyWindow addSubview:bgViewNew];
    
    if (self.isShowDeleteButton) {
        [self deleteButton];
    }
    
    // 添加自己
    [keyWindow addSubview:self];
    
    if (self.isBottomSuplmentWhite) {
        UIView * bottomSuplmentWhiteView = [[UIView alloc] initWithFrame:CGRectZero];
        bottomSuplmentWhiteView.backgroundColor = [UIColor whiteColor];
        [keyWindow addSubview:bottomSuplmentWhiteView];
        
        [bottomSuplmentWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset(0);
            make.top.mas_equalTo(self.mas_bottom);
        }];
    }

}

- (void)clickTheBackGroundView {
    if (self.clickBackGroundBlock) {
        self.clickBackGroundBlock();
    }
}

- (void)dismissFromWindow {
    // 移除之前的
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    self.canNotRemoveByNextAlert = NO;// 让自己标记为可移除的状态
    self.bgView.canNotRemoveByNextAlert = NO; // 让自己的背景也标记为可移除的状态
    for (UIView * subView in keyWindow.subviews) {
        if ([subView isKindOfClass:[MSFAlertBaseView class]]) {
            [subView removeFromSuperview];
        }
    }
}

- (void)clickTheBackGroundBlock:(ClickBlock)block {
    self.clickBackGroundBlock = block;
}

- (void)setIsShowDeleteButton:(BOOL)isShowDeleteButton {
    _isShowDeleteButton = isShowDeleteButton;
    if (isShowDeleteButton && self.bgView.superview) {
        [self deleteButton];
    }
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectZero];
//        [_deleteButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_deleteButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(dismissFromWindow) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_deleteButton];
        
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.width.height.mas_equalTo(30);
            make.bottom.offset(-50);
        }];
    }
    return _deleteButton;
}

@end
