//
//  SecondViewController.m
//  XWBlockDemo
//
//  Created by 邱学伟 on 2018/8/8.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import "SecondViewController.h"

typedef int(^XWTestBlock2)(int,int);

@interface SecondViewController ()
@property (nonatomic, copy) NSString *str;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.str = @"123";
//
//    void (^XWBlock)(void) = ^ {
//        NSLog(@"%@",self->_str);
//    };
//    XWBlock();
    
    
    int (^XWTestBlock)(int first,int second) = ^ (int first,int second) {
        return first + second;
    };
    
    XWTestBlock2 block = ^(int first,int second) {
        return first + second;
    };
    
    NSLog(@"%d",block(1,2));
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
