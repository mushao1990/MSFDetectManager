//
//  FirstViewController.h
//  MSFMemoryDetectDemo
//
//  Created by apple on 2019/6/23.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FirstViewController : UIViewController
- (IBAction)leaveAction:(id)sender;
- (IBAction)makeVcMemoryLeak:(id)sender;
- (IBAction)goToNextVc:(id)sender;
- (IBAction)makeTestViewMemoryLeakAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
