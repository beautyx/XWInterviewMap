//
//  SecondViewController.m
//  XWFloatingWindowDemo
//
//  Created by 邱学伟 on 2018/7/25.
//  Copyright © 2018年 邱学伟. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"girl.jpg"]];
    imageV.frame = self.view.bounds;
    [self.view addSubview:imageV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"二级界面里面展示的内容!!!";
    label.textColor = [UIColor orangeColor];
    label.center = self.view.center;
    [self.view addSubview:label];
    
    self.navigationController.title = @"这是个二级界面";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"＋浮窗" style:UIBarButtonItemStylePlain target:self action:@selector(addFloatingWindow)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)addFloatingWindow {
    NSLog(@"添加浮窗");
}

@end
