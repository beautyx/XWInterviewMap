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

#pragma mark - system
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"girl_726.JPG"]];
    imageV.frame = self.view.bounds;
    [self.view addSubview:imageV];
    
    self.navigationItem.title = @"这是个二级界面";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"＋浮窗" style:UIBarButtonItemStylePlain target:self action:@selector(addFloatingWindow)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark - private
- (void)addFloatingWindow {
    NSLog(@"添加浮窗");
}

@end
