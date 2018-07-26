//
//  WebViewController.m
//  XWFloatingWindowDemo
//
//  Created by 邱学伟 on 2018/7/25.
//  Copyright © 2018年 邱学伟. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <WKUIDelegate>

@end

@implementation WebViewController {
    WKWebView *p_webView;
}

- (void)loadView {
    [super loadView];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    p_webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    p_webView.UIDelegate = self;
    [self.view addSubview:p_webView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - private
- (void)setupUI {
    [p_webView setFrame:self.view.bounds];
    
    self.navigationController.title = @"这是一个网页";
    self.view.backgroundColor = [UIColor redColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"＋浮窗" style:UIBarButtonItemStylePlain target:self action:@selector(addFloatingWindow)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://blog.csdn.net/qxuewei"]];
    [p_webView loadRequest:request];
}

- (void)addFloatingWindow {
    NSLog(@"添加浮窗");
}

@end
