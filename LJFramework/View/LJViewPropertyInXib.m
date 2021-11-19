//
//  CustomViewPropertyInXib.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2018/9/17.
//  Copyright © 2018年 cui. All rights reserved.
//

#import "LJViewPropertyInXib.h"

@implementation LJViewPropertyInXib

- (void)setCViewCornerRadius:(CGFloat)cViewCornerRadius {
    self.layer.cornerRadius =  cViewCornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cViewCornerRadius {
    return self.layer.cornerRadius;
}

@end

@implementation UIView (InXib)

- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = 1.0;
}

- (UIColor *)shadowColor {
    UIColor *color = [UIColor colorWithCGColor:self.layer.shadowColor];
    
    return color;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius =  cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    UIColor *color = [UIColor colorWithCGColor:self.layer.borderColor];
    
    return color;
}

@end


@implementation UIButton (InXib)

- (void)setButtonCornerRadius:(CGFloat)buttonCornerRadius {
    self.layer.cornerRadius =  buttonCornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)buttonCornerRadius {
    return self.layer.cornerRadius;
}

@end

@implementation CustomButton

- (void)setCButtonCornerRadius:(CGFloat)cButtonCornerRadius {
    self.layer.cornerRadius =  cButtonCornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cButtonCornerRadius {
    return self.layer.cornerRadius;
}

@end

@implementation CustomImageView

- (void)setImageViewCornerRadius:(CGFloat)imageViewCornerRadius {
    self.layer.cornerRadius =  imageViewCornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)imageViewCornerRadius {
    return self.layer.cornerRadius;
}

@end

@implementation EmptyImageView

@end

@implementation InheritCustomXibView

@end
