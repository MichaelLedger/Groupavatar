//
//  CustomShapeView.m
//  groupavatar
//
//  Created by Gavin Xing on 2021/1/12.
//  Copyright © 2021 Gavin. All rights reserved.
//

#import "CustomShapeView.h"
#import "UIImage+maskClip.h"

@interface CustomShapeView ()

//@property (nonatomic, strong) CALayer *maskLayer;

@property (nonatomic, strong) UIView *fakeContentView;
@property (nonatomic, strong) UIImageView *fakeMaskIv;

@end

@implementation CustomShapeView

- (void)addSubview:(UIView *)view {
    if (view == self.fakeContentView || view == self.fakeMaskIv) {
        [super addSubview:view];
    } else {
        [self.fakeContentView addSubview:view];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupFakers];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupFakers];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _fakeContentView.frame = self.bounds;
    _fakeMaskIv.frame = self.bounds;
}

- (void)setupFakers {
    _fakeContentView = [[UIView alloc] init];
    _fakeContentView.frame = self.bounds;
    [self addSubview:_fakeContentView];
    
    _fakeMaskIv = [[UIImageView alloc] init];
    _fakeMaskIv.backgroundColor = [UIColor whiteColor];
    _fakeMaskIv.userInteractionEnabled = NO;
    _fakeMaskIv.frame = self.bounds;
    [self addSubview:_fakeMaskIv];
    
//    The view hierarchy is not prepared for the constraint
//    When added to a view, the constraint's items must be descendants of that view (or the view itself). This will crash if the constraint needs to be resolved before the view hierarchy is assembled.
    //Visual Format Language
//    _fakeMaskIv.translatesAutoresizingMaskIntoConstraints = NO;
//    NSDictionary *views = NSDictionaryOfVariableBindings(_fakeMaskIv);
//
//    NSString *vfl = @"H:|-[_fakeMaskIv]-|";
//    NSArray *constraint = [NSLayoutConstraint constraintsWithVisualFormat:vfl options:kNilOptions metrics:nil views:views];
//    [_fakeMaskIv addConstraints:constraint];
//
//    //Relation must be ==, >=, or <=
//    NSString *vf2 = @"V:|-[_fakeMaskIv]-|";
//    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:vf2 options:kNilOptions metrics:nil views:views];
//    [_fakeMaskIv addConstraints:constraint2];
}

- (void)dwMakeBottomRoundCornerWithRadius:(CGFloat)radius
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    // Custom draw
//    CGSize size = self.bounds.size;
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, size.width - radius, size.height);
//    CGPathAddArc(path, NULL, size.width-radius, size.height-radius, radius, M_PI/2, 0.0, YES);
//    CGPathAddLineToPoint(path, NULL, size.width, 0.0);
//    CGPathAddLineToPoint(path, NULL, 0.0, 0.0);
//    CGPathAddLineToPoint(path, NULL, 0.0, size.height - radius);
//    CGPathAddArc(path, NULL, radius, size.height - radius, radius, M_PI, M_PI/2, YES);
//    CGPathCloseSubpath(path);
//    [shapeLayer setPath:path];
//    CFRelease(path);
    
    //不建议使用 Core Graphics 绘图，使用 CAShapeLayer 搭配 贝塞尔曲线已经能完成大部分需求，且与 Core Graphics 相比可节省大量内存占用。
    
    // Using bezierPath
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
    shapeLayer.path = path.CGPath;
    
    self.layer.mask = shapeLayer;//layer的mask，顾名思义，是种位掩蔽，在shapeLayer的填充区域中，alpha值不为零的部分，self会被绘制；alpha值为零的部分，self不会被绘制，甚至不会响应touch
}

- (void)dwCustomShapeLayer {
    UIImage *maskImg = [UIImage imageNamed:@"anormal"];
//
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    [_maskLayer removeFromSuperlayer];
//    _maskLayer = [CALayer layer];
//    _maskLayer.frame = self.bounds;
//    [_maskLayer setShouldRasterize:YES];
//    _maskLayer.contents = (id)maskImg.CGImage;
//    [self.layer addSublayer:_maskLayer];
//    [CATransaction commit];
    
    // When capturing complex views, the speed of drawViewHierarchyInRect and snapshotViewAfterScreenUpdates does not match
    // UIView *snaphotView = [self.fakeContentView snapshotViewAfterScreenUpdates:YES];
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.fakeContentView drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *clippedImg = [UIImage maskClipImage:snapshot withMaskImage:maskImg];
    
    UIImageWriteToSavedPhotosAlbum(clippedImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [self bringSubviewToFront:self.fakeMaskIv];
    self.fakeMaskIv.image = clippedImg;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//    CGFloat radius = rect.size.height / 2.0;
//    [self dwMakeBottomRoundCornerWithRadius:radius];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dwCustomShapeLayer];
    });
    
    [super drawRect:rect];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __FUNCTION__);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
}

#pragma mark - Transmit properties

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _fakeContentView.backgroundColor = backgroundColor;
    [super setBackgroundColor:backgroundColor];
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    _fakeContentView.userInteractionEnabled = userInteractionEnabled;
    [super setUserInteractionEnabled:userInteractionEnabled];
}

@end
