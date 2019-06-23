//
//  SecondViewController.m
//  MSFMemoryDetectDemo
//
//  Created by apple on 2019/6/23.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import "SecondViewController.h"
#import "MSFMemoryHelperManger.h"
#import "TestModel.h"
@interface SecondViewController ()

@property (nonatomic, strong) TestModel * testModel;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.testModel = [TestModel new];
}

- (IBAction)leaveVcAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leaveToRootVcAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)makeVCmemoryLeak:(id)sender {
    UISwitch * switchView = (UISwitch *)sender;
    if (switchView.isOn) {
        [[MSFMemoryHelperManger sharedManager] storeTheObject:self];
    }
    else {
        [[MSFMemoryHelperManger sharedManager] unStoreTheObject:self];
    }
}

- (IBAction)makeModelMemoryLeak:(id)sender {
    UISwitch * switchView = (UISwitch *)sender;
    if (switchView.isOn) {
        [[MSFMemoryHelperManger sharedManager] storeTheObject:self.testModel];
    }
    else {
        [[MSFMemoryHelperManger sharedManager] unStoreTheObject:self.testModel];
    }
}

@end
