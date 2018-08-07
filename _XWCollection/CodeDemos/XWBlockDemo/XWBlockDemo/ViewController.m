//
//  ViewController.m
//  XWBlockDemo
//
//  Created by 邱学伟 on 2018/8/8.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"To Second" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toSecond) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn.frame = CGRectMake(200, 100, 200, 30);
    
}

- (void)toSecond {
    [self.navigationController pushViewController:[SecondViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

