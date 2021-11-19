//
//  CustomViewPropertyInXib.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2018/9/17.
//  Copyright © 2018年 cui. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 总结，直接在原生类的拓展里写属性不能实时更新，必须是UIView的子类
 自定义继承UIKit原生类后，UIView (InXib)或者自定义类的IBInspectable都可以实时更新
 */

/**
 这种自定义的UIviews会优先使用自己的属性，同时下面UIView (InXib)的属性无效
 并且cViewCornerRadius,cornerRadius都可以实时更新
 */
IB_DESIGNABLE
@interface LJViewPropertyInXib : UIView

@property (nonatomic) IBInspectable CGFloat cViewCornerRadius;

@end

IB_DESIGNABLE
@interface UIView (InXib)

@property (nonatomic) IBInspectable UIColor *shadowColor;

@property (nonatomic) IBInspectable CGFloat cornerRadius;

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;

@end

/**
 目前发现UIView子控件button，label等，用上面UIView（Inxib）是不能实时更新的
 父类为原生类比如UIButton，也是不能实时更新的
 但是用下面的CustomButton，xib中用下面的UIButton (InXib)的buttonCornerRadius是可以实时更新的
 */
IB_DESIGNABLE
@interface UIButton (InXib)

@property (nonatomic) IBInspectable CGFloat buttonCornerRadius;

@end

IB_DESIGNABLE
@interface CustomButton : UIButton

@property (nonatomic) IBInspectable CGFloat cButtonCornerRadius;

@end

IB_DESIGNABLE
@interface CustomImageView : UIImageView

@property (nonatomic) IBInspectable CGFloat imageViewCornerRadius;

@end

IB_DESIGNABLE
@interface EmptyImageView : UIImageView

@end

/**
 可以继承IBInspectable
 */
@interface InheritCustomXibView : LJViewPropertyInXib

@end

// 未验证
//对于使用 #import <> 方式引入的 UIView 子类，是无法在 Storyboard 中被 Compile 的，所以你需要将源代码添加到 Project 中才可以显示。


