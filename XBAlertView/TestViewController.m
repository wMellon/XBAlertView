//
//  TestViewController.m
//  XBAlertView
//
//  Created by xxb on 16/7/22.
//  Copyright © 2016年 xxb. All rights reserved.
//

#import "TestViewController.h"
#import "XBAlertView.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - event

- (IBAction)oneClick:(id)sender {
    XBAlertView *alertView = [[XBAlertView alloc] initWithTitle:@"单个按钮" contentText:@"alert显示了"];
    [alertView addAction:^{
        NSLog(@"测试1111");
    } withTitle:@"测试1"];
    [alertView show];
}

- (IBAction)twoClick:(id)sender {
    XBAlertView *alertView = [[XBAlertView alloc] initWithTitle:@"单个按钮" contentText:@"alert显示了"];
    [alertView addAction:^{
        NSLog(@"测试1111");
    } withTitle:@"测试1"];
    [alertView addAction:^{
        NSLog(@"测试222");
    } withTitle:@"测试2"];
    [alertView show];
}
- (IBAction)threeClick:(id)sender {
    XBAlertView *alertView = [[XBAlertView alloc] initWithTitle:@"单个按钮" contentText:@"alert显示了"];
    [alertView addAction:^{
        NSLog(@"测试1111");
    } withTitle:@"测试1"];
    [alertView addAction:^{
        NSLog(@"测试222");
    } withTitle:@"测试2"];
    [alertView addAction:^{
        NSLog(@"测试333");
    } withTitle:@"测试3"];
    [alertView show];
}

@end
