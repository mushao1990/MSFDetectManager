//
//  RootViewController.m
//  MSFMemoryDetectDemo
//
//  Created by apple on 2019/6/23.
//  Copyright © 2019 Mushao. All rights reserved.
//

#import "RootViewController.h"
#import "ThreeViewController.h"
#import "FirstViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)presentVcAction:(id)sender {
    ThreeViewController * threeVc = [[ThreeViewController alloc] initWithNibName:@"ThreeViewController" bundle:nil];
    [self presentViewController:threeVc animated:YES completion:nil];
}

- (IBAction)pushVcAction:(id)sender {
    FirstViewController * firstVc = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    [self.navigationController pushViewController:firstVc animated:YES];
}
@end
