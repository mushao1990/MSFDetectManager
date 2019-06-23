//
//  SecondViewController.h
//  MSFMemoryDetectDemo
//
//  Created by apple on 2019/6/23.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecondViewController : UIViewController
- (IBAction)leaveVcAction:(id)sender;
- (IBAction)leaveToRootVcAction:(id)sender;
- (IBAction)makeVCmemoryLeak:(id)sender;
- (IBAction)makeModelMemoryLeak:(id)sender;

@end

NS_ASSUME_NONNULL_END
