//
//  MaskView.m
//  groupavatar
//
//  Created by Gavin Xiang on 2021/1/13.
//  Copyright © 2021 Gavin. All rights reserved.
//

#import "MaskView.h"

@interface MaskView () <UIGestureRecognizerDelegate>

@end

@implementation MaskView

- (void)layoutSubviews {
    _iv.frame = self.bounds;
    _rootLayer.frame = self.bounds;
    _maskLayer.frame = self.bounds;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
//        [self setupRootLayer];
        [self setupGradientLayer];
        [self setupMaskLayer];
        [self addPanGesture];
    }
    return self;
}

- (void)setupImageView {
    _iv = [[UIImageView alloc] init];
    _iv.image = [UIImage imageNamed:@"swift"];
    [self addSubview:_iv];
}

- (void)setupRootLayer {
    _rootLayer = [CALayer layer];
    _rootLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"swift"].CGImage);
    [self.layer addSublayer:_rootLayer];
}

- (void)setupGradientLayer {
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
//    设置渐变颜色数组
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5].CGColor,(__bridge id)[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5].CGColor,(__bridge id)[UIColor colorWithRed:0 green:0 blue:1 alpha:0.5].CGColor];
//    渐变颜色的区间分布,locations的数组长度和colors一致
    gradientLayer.locations = @[@0.25,@0.5,@0.75];
//    映射locations中起始位置，用单位向量表示。比如（0, 0）表示从左上角开始变化。默认值是：(0.5, 0.0)。
    gradientLayer.startPoint = CGPointMake(0, 0);
//    映射locations中结束位置，用单位向量表示。比如（1, 1）表示到右下角变化结束。默认值是：(0.5, 1.0)。
    gradientLayer.endPoint = CGPointMake(0, 1);
    [self.layer addSublayer:gradientLayer];
    _gradientLayer = gradientLayer;
}

- (void)setupMaskLayer {
    _maskLayer = [CALayer layer];
    _maskLayer.contents = (__bridge id _Nullable)[UIImage imageNamed:@"apple"].CGImage;
    self.layer.mask = _maskLayer;
}

- (void)addPanGesture {
    //添加手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panGesture.delegate = self;
    _iv.userInteractionEnabled = YES;
    [_iv addGestureRecognizer:panGesture];
}

- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        //获取手势偏移量
        CGPoint translationPoint = [gestureRecognizer translationInView:gestureRecognizer.view];
        //平移视图
        gestureRecognizer.view.frame = CGRectOffset(gestureRecognizer.view.frame, translationPoint.x, translationPoint.y);
        //重置手势偏移量
        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
    }
}

//代理--手势识别器是否能够开始识别手势.
//当手势识别器识别到手势,准备从UIGestureRecognizerStatePossible状态开始转换时.调用此代理,如果返回YES,那么就继续识别,如果返回NO,那么手势识别器将会将状态置为UIGestureRecognizerStateFailed.
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    
    //相对有手势父视图的坐标点(注意如果父视图是scrollView,locationPoint.x可能会大于视图的width)
//    CGPoint locationPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    
    if (translation.x < 0) {
        //向左滑
//        NSLog(@"向左滑");
    }else if (translation.x > 0) {
        //向右滑
//        NSLog(@"向右滑");
    }
    
    if (translation.y < 0) {
        //向上滑
//        NSLog(@"向上滑");
    }else if (translation.y > 0) {
        //向下滑
//        NSLog(@"向下滑");
    }
    
    return YES;
}

@end
