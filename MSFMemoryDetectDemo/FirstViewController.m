//
//  FirstViewController.m
//  MSFMemoryDetectDemo
//
//  Created by apple on 2019/6/23.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import "FirstViewController.h"
#import "MSFMemoryHelperManger.h"
#import "SecondViewController.h"
@interface FirstViewController ()

@property (nonatomic, strong) UIView * testView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.testView = [UIView new];
}

- (IBAction)leaveAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)goToNextVc:(id)sender {
    SecondViewController * secondVc = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    [self.navigationController pushViewController:secondVc animated:YES];
}

- (IBAction)makeTestViewMemoryLeakAction:(id)sender {
    UISwitch * switchView = (UISwitch *)sender;
    if (switchView.isOn) {
        [[MSFMemoryHelperManger sharedManager] storeTheObject:self.testView];
    }
    else {
        [[MSFMemoryHelperManger sharedManager] unStoreTheObject:self.testView];
    }
}
@end
