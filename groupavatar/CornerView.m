//
//  CornerView.m
//  groupavatar
//
//  Created by Gavin Xing on 2021/1/12.
//  Copyright © 2021 Gavin. All rights reserved.
//

#import "CornerView.h"

@implementation CornerView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat radius = rect.size.height / 2.0;
    [self dwMakeBottomRoundCornerWithRadius:radius];
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
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    shapeLayer.path = path.CGPath;
    
    self.layer.mask = shapeLayer;//layer的mask，顾名思义，是种位掩蔽，在shapeLayer的填充区域中，alpha值不为零的部分，self会被绘制；alpha值为零的部分，self不会被绘制，甚至不会响应touch
}

@end
