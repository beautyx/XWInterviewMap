//
//  SecondViewController.m
//  XWInterviewDemos
//
//  Created by 邱学伟 on 2018/7/17.
//  Copyright © 2018年 邱学伟. All rights reserved.
//

#import "SecondViewController.h"
#import "NSTimer+XW.h"
#import "XWWeakProxy.h"
#import "SecondView.h"
#import "XWThread.h"

@interface SecondViewController () {
    CGFloat secondX;
    BOOL isStopAnim;
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *tipLB;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) SecondView *secondV;

@property (nonatomic, strong) XWThread *myThread;
@property (nonatomic, assign) BOOL shouldKeepRunning;
@end

@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    stopBtn.backgroundColor = [UIColor lightGrayColor];
    stopBtn.frame = CGRectMake(50, 200, 44, 44);
    [stopBtn addTarget:self action:@selector(stopClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    
    [self testThread];
    
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    
    
//    [self testBlock];
    
//    [self setupUI];
    
//    [self drawCircle];
    
//    __weak typeof(self) weakSelf = self;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(timerMethod) userInfo:nil repeats:YES];
//
//    [NSTimer xw_timerTimeInterval:1.0 block:^{
//        [weakSelf timerMethod];
//    } repeats:YES];
    
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:[XWWeakProxy proxyWithTarget:self] selector:@selector(timerMethod) userInfo:nil repeats:YES];
    
    
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)stopClick {
    [self performSelector:@selector(stopThread) onThread:self.myThread withObject:nil waitUntilDone:NO];
}

- (void)stopThread {
    self.shouldKeepRunning = NO;
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"stopThread +++ %@",[NSThread currentThread]);
}

- (void)testThread {
    
    self.shouldKeepRunning = YES;
    __weak typeof(self) weakSelf = self;
    self.myThread = [[XWThread alloc] initWithBlock:^{
        NSLog(@"thread begin *** %@",[NSThread currentThread]);
        
        /// 线程保活
        NSRunLoop *currentLoop = [NSRunLoop currentRunLoop];
        NSPort *livePort = [NSPort new];
        [currentLoop addPort:livePort forMode:NSDefaultRunLoopMode];
//        [currentLoop run];
        while (weakSelf && weakSelf.shouldKeepRunning) {
            [currentLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        NSLog(@"thread end *** %@",[NSThread currentThread]);
    }];
    [self.myThread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self performSelector:@selector(logMessage) onThread:self.myThread withObject:nil waitUntilDone:NO];
    
//    if (isStopAnim) {
//        [self beginAnimation:self.secondV.layer];
//        isStopAnim = NO;
//    }else{
//        [self stopAnimation:self.secondV.layer];
//        isStopAnim = YES;
//    }
}

- (void)logMessage {
    NSLog(@"do something *** %@",[NSThread currentThread]);
}


- (void)timerMethod {
    NSLog(@"计时");
}

- (void)testBlockTimer {
    __weak typeof(self) weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(timerMethod) userInfo:nil repeats:YES];
    
    [NSTimer xw_timerTimeInterval:1.0 block:^{
        [weakSelf timerMethod];
    } repeats:YES];
}

- (void)testBlock {
    
    void(^logBlock)(void) = ^(void) {
        NSLog(@"%@",self.tipLB);
    };
    logBlock();
    
}

/// 暂停动画
- (void)stopAnimation:(CALayer *)layer {
    CFTimeInterval stopTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = stopTime;
}

/// 继续动画
- (void)beginAnimation:(CALayer *)layer {
    CFTimeInterval stopTime = layer.timeOffset;
    
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    
    CFTimeInterval beginTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - stopTime;
    layer.beginTime = beginTime;
}

- (void)drawCircle {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.secondV.bounds cornerRadius:self.secondV.bounds.size.width * 0.5];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = self.secondV.bounds;
    layer.path = path.CGPath;
    self.secondV.layer.mask = layer;
}


+ (instancetype)loadViewController {
    return [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
}


- (void)dealloc {
    
    [self stopClick];
    NSLog(@"%s",__func__);
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    @synchronized (self) {
//        NSLog(@"极客学伟");
//    }
    
    
}

- (void)setupUI {
    secondX = 100;
    self.secondV = [[SecondView alloc] initWithFrame:CGRectMake(secondX, 100, 200, 200)];
    self.secondV.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.secondV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
