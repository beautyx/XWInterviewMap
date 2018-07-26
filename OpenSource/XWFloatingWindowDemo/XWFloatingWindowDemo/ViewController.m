//
//  ViewController.m
//  XWFloatingWindowDemo
//
//  Created by 邱学伟 on 2018/7/22.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()
@end

@implementation ViewController
#pragma mark - system
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - private
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"首页";

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"微信悬浮窗Demo";
    label.center = self.view.center;
    
    UIButton *toSecondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:toSecondBtn];
    toSecondBtn.bounds = CGRectMake(0, 0, 150, 30);
    toSecondBtn.backgroundColor = [UIColor lightGrayColor];
    toSecondBtn.layer.cornerRadius = 6.0;
    toSecondBtn.center = CGPointMake(label.center.x, label.center.y + 150);
    [toSecondBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [toSecondBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [toSecondBtn setTitle:@"To 二级视图" forState:UIControlStateNormal];
    [toSecondBtn addTarget:self action:@selector(toSecondClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)toSecondClick {
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
}
@end
