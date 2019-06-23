//
//  MSFAlertBaseView.h
//  Ticket
//
//  Created by 慕少锋 on 2018/11/5.
//  Copyright © 2018 Arron Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

typedef void(^ClickBlock)(void);
typedef void(^ClickAtIndexBlock)(NSInteger index);

@interface MSFAlertBaseView : UIView

/**
 补白的情况下，关闭按钮就不会显示了
*/

@property (nonatomic, assign) BOOL    isShowDeleteButton;// 默认不显示

@property (nonatomic, assign) BOOL    isBottomSuplmentWhite;// 底部是否补白 默认不补 （和上面的属性互斥）

@property (nonatomic, assign) BOOL    canNotRemoveByNextAlert;// 默认为NO  如果为YES，当其他MSFAlertBaseView对象要出现的时候，不移除该view

- (void)showInWindow;// 显示

- (void)dismissFromWindow; // 消失

- (void)clickTheBackGroundBlock:(ClickBlock)block;

@end
