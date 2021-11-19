//
//  UIButton+LJCategory.h
//  LJFramework
//
//  Created by 崔志伟 on 2021/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LJButtonImagePosition) {
    LJButtonImagePositionDefult = 0,        //图片在左，文字在右，默认
    LJButtonImagePositionRight,             //图片在右，文字在左
    LJButtonImagePositionTop,               //图片在上，文字在下
    LJButtonImagePositionBottom,            //图片在下，文字在上
};

@interface UIButton (LJCategory)

- (void)setImagePosition:(LJButtonImagePosition)postion spacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
