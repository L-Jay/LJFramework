//
//  OGGradientView.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/4/2.
//

#import "LJGradientView.h"

@implementation LJGradientView

+ (Class)layerClass {
    return CAGradientLayer.class;
}

- (void)setColorsArray:(NSArray<UIColor *> *)colorsArray {
    CAGradientLayer *layer = (CAGradientLayer *)self.layer;
    layer.colors = @[(id)colorsArray.firstObject.CGColor,
                     (id)colorsArray.lastObject.CGColor];
}

- (void)setStartPoint:(CGPoint)startPoint {
    CAGradientLayer *layer = (CAGradientLayer *)self.layer;
    layer.startPoint = startPoint;
}

- (void)setEndPoint:(CGPoint)endPoint {
    CAGradientLayer *layer = (CAGradientLayer *)self.layer;
    layer.endPoint = endPoint;
}

@end
