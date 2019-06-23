//
//  ThreeViewController.m
//  MSFMemoryDetectDemo
//
//  Created by apple on 2019/6/23.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import "ThreeViewController.h"
#import "MSFMemoryHelperManger.h"

@interface ThreeViewController ()

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)leaveAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)makeVcMemoryLeak:(id)sender {
    UISwitch * switchView = (UISwitch *)sender;
    if (switchView.isOn) {
        [[MSFMemoryHelperManger sharedManager] storeTheObject:self];
    }
    else {
        [[MSFMemoryHelperManger sharedManager] unStoreTheObject:self];
    }
}
@end
