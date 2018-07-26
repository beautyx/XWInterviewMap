//
//  ViewController.m
//  XWFloatingWindowDemo
//
//  Created by 邱学伟 on 2018/7/22.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "XWFloatingWindowView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"微信悬浮窗Demo";
    label.center = self.view.center;
    [self.view addSubview:label];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toWeb)];
//    label.userInteractionEnabled = YES;
//    [label addGestureRecognizer:tap];
    
    [XWFloatingWindowView show];
    
}

- (void)toWeb {
    WebViewController *web = [[WebViewController alloc] init];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
