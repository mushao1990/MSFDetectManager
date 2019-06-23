//
//  MSFCommonAlertBaseView.m
//  MSF
//
//  Created by 慕少锋 on 2019/5/15.
//  Copyright © 2019 Leo. All rights reserved.
//

#import "MSFCommonAlertBaseView.h"

@interface MSFCommonAlertBaseView()

@property (nonatomic, strong) UILabel    * titleLabel;//

@property (nonatomic, strong) UILabel    * subTitleLabel;//

@property (nonatomic, strong) UIView    * contentView;//

@property (nonatomic, strong) UIButton    * leftButton;//

@property (nonatomic, strong) UIButton    * rightButton;//

@property (nonatomic, copy) ClickAtIndexBlock    leftButtonBlock;//

@property (nonatomic, copy) ClickAtIndexBlock    rightButtonBlock;//

@end

@implementation MSFCommonAlertBaseView

- (void)dealloc {
    
}

+ (instancetype)showWithContentView:(nullable UIView *)contentView
                              title:(nullable NSString *)title
                           subTitle:(nullable NSString *)subTitle
                     andButtonInfos:(nullable NSArray <NSDictionary *> *)buttonInfos
                    completionBlock:(nullable ClickAtIndexBlock)block {

    NSInteger buttonCount = buttonInfos.count;
    // 修复不传按钮时候的bug
    if (buttonCount <= 0) {
        buttonInfos = @[@{}];
        buttonCount = 1;
    }
    MSFCommonAlertBaseView * alertBaseView = [[MSFCommonAlertBaseView alloc] initWithFrame:CGRectZero
                                                                                      andContentView:contentView
                                                                                            andTitle:title
                                                                                         andSubTitle:subTitle
                                                                                      andButtonInfos:buttonInfos];
    alertBaseView.canNotRemoveByNextAlert = YES;
    __weak MSFCommonAlertBaseView * weakView = alertBaseView;
    alertBaseView.leftButtonBlock = ^(NSInteger index) {
        [weakView dismissFromWindow];
        if (block) {
            block(0);
        }
    };
    alertBaseView.rightButtonBlock = ^(NSInteger index) {
        [weakView dismissFromWindow];
        if (block) {
            block(buttonCount==1?0:1);
        }
    };
    [alertBaseView showInWindow];
    
    [alertBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.center.mas_offset(CGPointMake(0, 0));
    }];
    return alertBaseView;
}

- (instancetype)initWithFrame:(CGRect)frame
               andContentView:(nullable UIView *)contentView
                     andTitle:(NSString *)title
                  andSubTitle:(NSString *)subTitle
               andButtonInfos:(NSArray <NSDictionary *> *)buttonInfos {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        if (title.length > 0) {
            _titleLabel = [self createLabel];
            _titleLabel.font = [UIFont boldSystemFontOfSize:22];
            _titleLabel.text = title;
            _titleLabel.textColor = [UIColor blackColor];
        }

        if (subTitle.length > 0) {
            _subTitleLabel = [self createLabel];
            _subTitleLabel.font = [UIFont systemFontOfSize:14];
            _subTitleLabel.text = subTitle;
            _subTitleLabel.textColor = [self createColorWithString:@"#666666"];
        }
        
        if (contentView) {
            self.contentView = contentView;
            [self addSubview:contentView];
        }
        NSDictionary * rightDic = nil;
        NSDictionary * leftDic = nil;
        if (buttonInfos.count == 1) {
            rightDic = [buttonInfos firstObject];
        }
        else if (buttonInfos.count > 1) {
            rightDic = buttonInfos[1];
            leftDic = [buttonInfos firstObject];
        }
        _rightButton = [self createButtonWithButtonInfo:rightDic isLeft:NO];
        if (leftDic) {
            _leftButton = [self createButtonWithButtonInfo:leftDic isLeft:YES];
        }
        
        // 添加约束
        CGFloat top = 15;
        CGFloat buttonHeight = 50;
        UIView * lastView = nil;
        if (rightDic[@"height"]) {
            buttonHeight = [rightDic[@"height"] floatValue];
        }
        
        if (_titleLabel) {
            top = 25;
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(top);
                make.left.offset(25);
                make.right.offset(-25);
            }];
            lastView = _titleLabel;
        }
        
        if (_subTitleLabel) {
            [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastView) {
                    make.top.mas_equalTo(lastView.mas_bottom).offset(10);
                }
                else {
                    make.top.offset(top);
                }
                make.left.offset(25);
                make.right.offset(-25);
            }];
            lastView = _subTitleLabel;
        }
        
        if (contentView) {
            
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastView) {
                    make.top.mas_equalTo(lastView.mas_bottom).offset(15);
                }
                else {
                    make.top.offset(top);
                }
                make.centerX.offset(0);
            }];
            
            lastView = contentView;
        }
        
        if (_leftButton) {
            [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.offset(0);
                make.height.mas_equalTo(buttonHeight);
                make.width.mas_equalTo(self).multipliedBy(0.5);
                if (lastView) {
                    make.top.mas_equalTo(lastView.mas_bottom).offset(15);
                }
                else {
                    make.top.offset(top);
                }
            }];
            
            [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.offset(0);
                make.height.mas_equalTo(buttonHeight);
                make.width.mas_equalTo(self).multipliedBy(0.5);
                if (lastView) {
                    make.top.mas_equalTo(lastView.mas_bottom).offset(15);
                }
                else {
                    make.top.offset(top);
                }
            }];
            [self addTheCorner:UIRectCornerBottomLeft andCornerRadius:3 forView:_leftButton];
            [self addTheCorner:UIRectCornerBottomRight andCornerRadius:3 forView:_rightButton];
        }
        else {
            _rightButton.layer.cornerRadius = 3;
            _rightButton.layer.masksToBounds = YES;
            [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(-15);
                make.height.mas_equalTo(buttonHeight);
                make.width.mas_equalTo(260);
                make.centerX.offset(0);
                if (lastView) {
                    make.top.mas_equalTo(lastView.mas_bottom).offset(15);
                }
                else {
                    make.top.offset(top);
                }
            }];
        }
    }
    return self;
}

- (UIButton *)createButtonWithButtonInfo:(NSDictionary *)buttonInfo isLeft:(BOOL)isleft {

    NSString * bgColor = isleft?@"#F5F5F5":@"#5897E4";
    NSString * titleColor = isleft?@"#666666":@"#ffffff";
    NSInteger fontSize = 18;
    NSString * title = buttonInfo[@"title"]?:@"知道了";
    if (buttonInfo[@"bgColor"]) {
        bgColor = buttonInfo[@"bgColor"];
    }
    if (buttonInfo[@"titleColor"]) {
        titleColor = buttonInfo[@"titleColor"];
    }
    if (buttonInfo[@"fontSize"]) {
        fontSize = [buttonInfo[@"fontSize"] floatValue];
    }
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[self createColorWithString:titleColor] forState:UIControlStateNormal];
    button.backgroundColor = [self createColorWithString:bgColor];
    SEL selector = isleft?NSSelectorFromString(@"clickTheLeftButton"):NSSelectorFromString(@"clickTheRightButton");
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    if ([buttonInfo[@"bold"] boolValue]) {
        button.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    }
    else {
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    [self addSubview:button];
    return button;
}

- (void)clickTheLeftButton {
    if (self.leftButtonBlock) {
        self.leftButtonBlock(0);
    }
}

- (void)clickTheRightButton {
    if (self.rightButtonBlock) {
        self.rightButtonBlock(0);
    }
}

- (void)addTheCorner:(UIRectCorner)corner andCornerRadius:(CGFloat)radius forView:(UIView *)view {
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                      byRoundingCorners:corner
                                                            cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    view.layer.mask = layer;
}

- (UILabel *)createLabel {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    return label;
}

- (UIColor *)createColorWithString:(NSString *)colorStr {
    if (colorStr.length != 7) {
        return self.tintColor;
    }
    NSRange range = NSMakeRange(1, 2);
    NSString * rStr = [colorStr substringWithRange:range];
    range = NSMakeRange(3, 2);
    NSString * gStr = [colorStr substringWithRange:range];
    range = NSMakeRange(5, 2);
    NSString * bStr = [colorStr substringWithRange:range];
    unsigned int r,g,b;
    [[NSScanner scannerWithString:rStr] scanHexInt:&r];
    [[NSScanner scannerWithString:gStr] scanHexInt:&g];
    [[NSScanner scannerWithString:bStr] scanHexInt:&b];
    
    return [UIColor colorWithRed:r/225.0 green:g/255.0 blue:b/255.0 alpha:1];
}

@end
