//
//  MaskView.h
//  groupavatar
//
//  Created by Gavin Xiang on 2021/1/13.
//  Copyright © 2021 Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MaskView : UIView

@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) CALayer *rootLayer;
@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

NS_ASSUME_NONNULL_END
