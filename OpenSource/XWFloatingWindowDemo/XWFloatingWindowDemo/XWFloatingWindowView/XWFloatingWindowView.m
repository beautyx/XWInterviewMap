//
//  XWFloatingWindowView.m
//  XWFloatingWindowDemo
//
//  Created by 邱学伟 on 2018/7/22.
//  Copyright © 2018 邱学伟. All rights reserved.
//

#import "XWFloatingWindowView.h"
#import "SecondViewController.h"

//浮窗宽度
static const CGFloat cFloatingWindowWidth = 60.0;
//默认缩放动画时间
static const NSTimeInterval cFloatingWindowPathAnimtiontDuration = 1.0;

#pragma mark - **************************************** 转场视图 ******************************************************
@interface XWFloatingAnimationView : UIView <CAAnimationDelegate>
@property (nonatomic, strong) UIImage *screenImage;
@end

@implementation XWFloatingAnimationView {
    UIImageView *p_imageView;
    CAShapeLayer *p_shapeLayer;
    UIView *p_theView;
}
#pragma mark - public
- (void)startAnimatingWithView:(UIView *)view fromRect:(CGRect)fromRect toRect:(CGRect)toRect {
    p_theView = view;
    
    p_shapeLayer = [CAShapeLayer layer];
    p_shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:fromRect cornerRadius:cFloatingWindowWidth * 0.5].CGPath;
    p_shapeLayer.fillColor = [UIColor lightGrayColor].CGColor;
    p_imageView.layer.mask = p_shapeLayer;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.toValue = (__bridge id)[UIBezierPath bezierPathWithRoundedRect:toRect cornerRadius:cFloatingWindowWidth * 0.5].CGPath;
    anim.duration = cFloatingWindowPathAnimtiontDuration;
    anim.delegate = self;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    [p_shapeLayer addAnimation:anim forKey:@"revealAnimation"];
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    p_theView.hidden = NO;
    [self removeFromSuperview];
}
#pragma mark system
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark  private
- (void)setupUI {
    self.backgroundColor = [UIColor greenColor];
    p_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:p_imageView];
}
- (void)setScreenImage:(UIImage *)screenImage {
    p_imageView.image = screenImage;
}
@end

#pragma mark - ***************************************** 转场工具类 *****************************************************
@interface XWFloatingAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) CGPoint currentFloatingCenter;
@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, assign) BOOL isInteractive;
@end

@implementation XWFloatingAnimator
#pragma mark  UIViewControllerAnimatedTransitioning
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    
    if (_operation == UINavigationControllerOperationPush) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [containerView addSubview:toView];
        
        XWFloatingAnimationView *animationV = [[XWFloatingAnimationView alloc] initWithFrame:toView.bounds];
        
        // toView 截屏
        UIGraphicsBeginImageContext(toView.bounds.size);
        [toView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        animationV.screenImage = image;
        
        toView.hidden = YES;
        UIGraphicsEndImageContext();
        
        [containerView addSubview:animationV];
        
        [animationV startAnimatingWithView:toView fromRect:CGRectMake(_currentFloatingCenter.x, _currentFloatingCenter.y, cFloatingWindowWidth, cFloatingWindowWidth) toRect:toView.frame];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(cFloatingWindowPathAnimtiontDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [transitionContext completeTransition:YES];
        });
        
    }else if (_operation == UINavigationControllerOperationPop) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [containerView addSubview:toView];
        
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        [containerView bringSubviewToFront:fromView];
        
        UIView *floatingBtn = [UIApplication sharedApplication].keyWindow.subviews.lastObject;
        
        if (_isInteractive) {  /// 可交互式动画
            
            [UIView animateWithDuration:0.3f animations:^{
                
                fromView.frame = CGRectOffset(fromView.frame, [UIScreen mainScreen].bounds.size.width, 0.f);
                
            } completion:^(BOOL finished) {
                
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                
                if (!transitionContext.transitionWasCancelled) {
                    
                    floatingBtn.alpha = 1.f;
                    
                }
                
            }];
            
        } else {    /// 非可交互式动画
            
            ///截屏
            
            XWFloatingAnimationView *theView = [[XWFloatingAnimationView alloc] initWithFrame:fromView.bounds];
            UIGraphicsBeginImageContext(fromView.bounds.size);
            [fromView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            theView.screenImage = image;
            UIGraphicsEndImageContext();
            
            CGRect fromRect = fromView.frame;
            fromView.frame = CGRectZero;
            
            [containerView addSubview:theView];
            
            [theView startAnimatingWithView:theView fromRect:fromRect toRect:CGRectMake(_currentFloatingCenter.x, _currentFloatingCenter.y, 60.f, 60.f)];
            
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            floatingBtn.alpha = 1.f;
        }

    }
    
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

#pragma mark - private
/// view -> 截图
- (UIImage *)screenImageWithView:(UIView *)view {
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}
@end


#pragma mark - ****************************************** 滑动返回 ****************************************************
@interface XWInteractiveTransition : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL isInteractive;
@property (nonatomic, assign) CGPoint curPoint;
- (void)transitionToViewController:(UIViewController *)toViewController;

@end

@implementation XWInteractiveTransition {
    UIViewController *presentedViewController;
    BOOL shouldComplete;
    CGFloat transitionX;
}

- (void)transitionToViewController:(UIViewController *)toViewController {
    
    presentedViewController = toViewController;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [toViewController.view addGestureRecognizer:panGesture];
    
}


- (void)panAction:(UIPanGestureRecognizer *)gesture {
    
    UIView *floatingBtn = [UIApplication sharedApplication].keyWindow.subviews.lastObject;
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    switch (gesture.state) {
            
        case UIGestureRecognizerStateBegan:
            
            _isInteractive = YES;
            
            [nav popViewControllerAnimated:YES];
            
            break;
            
        case UIGestureRecognizerStateChanged: {
            
            //监听当前滑动的距离
            CGPoint transitionPoint = [gesture translationInView:presentedViewController.view];
            
            CGFloat ratio = transitionPoint.x/[UIScreen mainScreen].bounds.size.width;
            
            transitionX = transitionPoint.x;
            
            ///获得floatingBtn，改变它的alpha值
            floatingBtn.alpha = ratio;
            if (ratio >= 0.5) {
                shouldComplete = YES;
            } else {
                shouldComplete = NO;
            }
            
            [self updateInteractiveTransition:ratio];
            
        }
            
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
            if (shouldComplete) {
                /// 添加动画
                ///截屏
                UIView *fromView = presentedViewController.view;
                
                
                XWFloatingAnimationView *theView = [[XWFloatingAnimationView alloc] initWithFrame:fromView.bounds];
                UIGraphicsBeginImageContext(fromView.bounds.size);
                [fromView.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                theView.screenImage = image;
                UIGraphicsEndImageContext();
                
                CGRect fromRect = fromView.frame;
                fromView.frame = CGRectZero;
                [fromView.superview addSubview:theView];
                [theView startAnimatingWithView:theView fromRect:CGRectMake(transitionX, 0.f, fromRect.size.width, fromRect.size.height) toRect:CGRectMake(_curPoint.x, _curPoint.y, 60.f, 60.f)];
                [self finishInteractiveTransition];
                nav.delegate = nil;  //这个需要设置，而且只能在这里设置，不能在外面设置
            } else {
                floatingBtn.alpha = 0.f;
                [self cancelInteractiveTransition];
            }
            _isInteractive = NO;
        }
            break;
        default:
            break;
    }
}
@end

#pragma mark - ****************************************** 浮窗右下红色容器视图 ****************************************************
@interface XWFloatingWindowContentView : UIView
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, strong) CATextLayer *textLayer;
@end

@implementation XWFloatingWindowContentView

#pragma mark - system
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - private
- (void)setupUI {
    [self.layer addSublayer:self.shapeLayer];
    [self.layer addSublayer:self.imageLayer];
    [self.layer addSublayer:self.textLayer];
    
    CGFloat imageW = 50.0;
    _imageLayer.frame = CGRectMake(0.5 * (self.frame.size.width - imageW), 0.5 * (self.frame.size.height - imageW), imageW, imageW);
    _textLayer.frame = CGRectMake(_imageLayer.frame.origin.x, CGRectGetMaxY(_imageLayer.frame), _imageLayer.frame.size.width, 20);
}

#pragma mark - getter
- (CAShapeLayer *)shapeLayer {
    if(!_shapeLayer){
        _shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width, self.frame.size.height) radius:self.frame.size.width startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
        [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        [path closePath];
        
        _shapeLayer.path = path.CGPath;
        _shapeLayer.fillColor = [UIColor colorWithRed:206/255.0 green:85/255.0 blue:85/255.0 alpha:1].CGColor;;
    }
    return _shapeLayer;
}

- (CALayer *)imageLayer {
    if(!_imageLayer){
        _imageLayer = [[CALayer alloc] init];
        _imageLayer.contents = (__bridge id)[UIImage imageNamed:@"CornerIcon"].CGImage;
    }
    return _imageLayer;
}

- (CATextLayer *)textLayer {
    if(!_textLayer){
        _textLayer = [[CATextLayer alloc] init];
        _textLayer.string = @"取消浮窗";
        _textLayer.fontSize = 12.0;
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        _textLayer.foregroundColor = [UIColor colorWithRed:234.f/255.0 green:160.f/255.0 blue:160.f/255.0 alpha:1].CGColor;
    }
    return _textLayer;
}
@end


#pragma mark - ****************************************** 浮窗视图 ****************************************************
@interface XWFloatingWindowView() <UINavigationControllerDelegate> {
    CGSize screenSize;
    CGPoint lastPointInSuperView;
    CGPoint lastPointInSelf;
    XWInteractiveTransition *interactiveTransition;
}
@end

@implementation XWFloatingWindowView
//全局浮窗
static XWFloatingWindowView *xw_floatingWindowView;
//全局隐藏浮窗视图
static XWFloatingWindowContentView *xw_floatingWindowContentView;
//两边间距
static const CGFloat cFloatingWindowMargin = 20.0;
//隐藏浮窗视图宽度
static const CGFloat cFloatingWindowContentWidth = 160.0;
//默认动画时间
static const NSTimeInterval cFloatingWindowAnimtionDefaultDuration = 0.25;


#pragma mark - publish
+ (void)show {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xw_floatingWindowView = [[XWFloatingWindowView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width - cFloatingWindowWidth * 2 - cFloatingWindowMargin, 200.0, cFloatingWindowWidth, cFloatingWindowWidth)];
        
        xw_floatingWindowContentView = [[XWFloatingWindowContentView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height, cFloatingWindowContentWidth, cFloatingWindowContentWidth)];
    });
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!xw_floatingWindowContentView.superview) {
        [keyWindow addSubview:xw_floatingWindowContentView];
        [keyWindow bringSubviewToFront:xw_floatingWindowContentView];
    }
    if (!xw_floatingWindowView.superview) {
        [keyWindow addSubview:xw_floatingWindowView];
        [keyWindow bringSubviewToFront:xw_floatingWindowView];
    }
}

#pragma mark - system
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    lastPointInSuperView = [touch locationInView:self.superview];
    lastPointInSelf = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint curentPoint = [touch locationInView:self.superview];
    
    /// 展开 右下浮窗隐藏视图
    if (!CGPointEqualToPoint(lastPointInSuperView, curentPoint)) {
        /// 有移动才展开
        CGRect rect = CGRectMake(screenSize.width - cFloatingWindowContentWidth, screenSize.height - cFloatingWindowContentWidth, cFloatingWindowContentWidth, cFloatingWindowContentWidth);
        if (!CGRectEqualToRect(xw_floatingWindowContentView.frame, rect)) {
            [UIView animateWithDuration:cFloatingWindowAnimtionDefaultDuration animations:^{
                xw_floatingWindowContentView.frame = rect;
            }];
        }
    }
    
    /// 调整浮窗中心点
    CGFloat halfWidth = self.frame.size.width * 0.5;
    CGFloat halfHeight = self.frame.size.height * 0.5;
    CGFloat centerX = curentPoint.x + (halfWidth - lastPointInSelf.x);
    CGFloat centerY = curentPoint.y + (halfHeight - lastPointInSelf.y);
    CGFloat x = MIN(screenSize.width - halfWidth, MAX(centerX, halfWidth));
    CGFloat y = MIN(screenSize.height - halfHeight, MAX(centerY, halfHeight));
    self.center = CGPointMake(x,y);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    
    if (CGPointEqualToPoint(lastPointInSuperView, currentPoint)) {
        NSLog(@"单击!");
        [self toWeb];
    }else{
        
        /// 收缩 右下浮窗隐藏视图
        [UIView animateWithDuration:cFloatingWindowAnimtionDefaultDuration animations:^{
            /// 浮窗在隐藏视图内部,移除浮窗
            CGFloat distance = sqrtf( (pow(self->screenSize.width - xw_floatingWindowView.center.x,2) + pow(self->screenSize.height - xw_floatingWindowView.center.y, 2)) );
            if (distance < (cFloatingWindowContentWidth - cFloatingWindowWidth * 0.5)) {
                [self removeFromSuperview];
            }
            
            xw_floatingWindowContentView.frame = CGRectMake(self->screenSize.width, self->screenSize.height, cFloatingWindowContentWidth, cFloatingWindowContentWidth);
        }];
        
        CGFloat left = currentPoint.x;
        CGFloat right = screenSize.width - currentPoint.x;
        if (left <= right) {
            [UIView animateWithDuration:cFloatingWindowAnimtionDefaultDuration animations:^{
                self.center = CGPointMake(cFloatingWindowMargin + self.bounds.size.width * 0.5, self.center.y);
            }];
        }else{
            [UIView animateWithDuration:cFloatingWindowAnimtionDefaultDuration animations:^{
                self.center = CGPointMake(self->screenSize.width - cFloatingWindowMargin - self.bounds.size.width * 0.5, self.center.y);
            }];
        }
    }
}

#pragma mark - private
- (void)setupUI {
    screenSize = UIScreen.mainScreen.bounds.size;
    self.backgroundColor = [UIColor clearColor];
    self.layer.contents = (__bridge id)[UIImage imageNamed:@"FloatBtn"].CGImage;
}

- (void)toWeb {
    
    interactiveTransition = [XWInteractiveTransition new];
    interactiveTransition.curPoint = self.frame.origin;
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (![rootVC isKindOfClass:[UINavigationController class]]) {
        NSLog(@"跟控制器不是 UINavigationController");
        return;
    }
    UINavigationController *navi = (UINavigationController *)rootVC;
    navi.delegate = self;
    SecondViewController *web = [[SecondViewController alloc] init];
    
    [interactiveTransition transitionToViewController:web];
    
    [navi pushViewController:web animated:YES];
}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        self.alpha = 0.0;
    }
    XWFloatingAnimator *animator = [[XWFloatingAnimator alloc] init];
    animator.currentFloatingCenter = self.frame.origin;
    animator.operation = operation;
    animator.isInteractive = interactiveTransition.isInteractive;
    return animator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return interactiveTransition.isInteractive?interactiveTransition:nil;
}
@end
