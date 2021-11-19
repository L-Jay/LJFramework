//
//  UIView+LJCategory.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LJViewAnimation) {
    LJViewAnimationFade = 0,            //淡出
    LJViewAnimationRipple,              //波纹
    LJViewAnimationSuckEffect,          //吸收
    LJViewAnimationFlipFromLeft,        //水平翻转,从左向右
    LJViewAnimationFlipFromRight,       //水平翻转,从右向左
    LJViewAnimationFlipFromBottm,       //竖直翻转,从下向上
    LJViewAnimationFlipFromTop,         //竖直翻转,从上向下
    LJViewAnimationPageCurlFromLeft,    //从左翻页
    LJViewAnimationPageCurlFromRight,   //从右翻页
    LJViewAnimationPageCurlFromBottom,  //从下翻页
    LJViewAnimationPageCurlFromTop,     //从上翻页
    LJViewAnimationPageUnCurlFromLeft,  //从左反翻页
    LJViewAnimationPageUnCurlFromRight, //从右反翻页
    LJViewAnimationPageUnCurlFromBottom,//从下反翻页
    LJViewAnimationPageUnCurlFromTop,   //从上反翻页
    LJViewAnimationMoveInFromLeft,      //从左覆盖
    LJViewAnimationMoveInFromRight,     //从右覆盖
    LJViewAnimationMoveInFromBottom,    //从下覆盖
    LJViewAnimationMoveInFromTop,       //从上覆盖
    LJViewAnimationPushFromLeft,        //从左推出
    LJViewAnimationPushFromRight,       //从右推出
    LJViewAnimationPushFromBottom,      //从下推出
    LJViewAnimationPushFromTop,         //从上推出
    LJViewAnimationRevealFromLeft,      //从左移开
    LJViewAnimationRevealFromRight,     //从右移开
    LJViewAnimationRevealFromBottom,    //从下移开
    LJViewAnimationRevealFromTop,       //从上移开
    LJViewAnimationCubeFromLeft,        //从左旋转
    LJViewAnimationCubeFromRight,       //从右旋转
    LJViewAnimationCubeFromBottom,      //从下旋转
    LJViewAnimationCubeFromTop,         //从上旋转
};

@interface UIView (LJCategory)

#pragma mark - Coordinate

@property (nonatomic) CGFloat minX;

@property (nonatomic) CGFloat minY;

@property (nonatomic) CGFloat maxX;

@property (nonatomic) CGFloat maxY;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;

@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;

@property (nonatomic) CGSize size;

@property (nonatomic) CGPoint centerBounds;

@property (nonatomic) CGFloat moveMinX;

@property (nonatomic) CGFloat moveMinY;

@property (nonatomic) CGFloat moveMaxX;

@property (nonatomic) CGFloat moveMaxY;

#pragma mark - Property Extend

@property (nonatomic, assign, readonly) UIViewController *controller;

#pragma mark - Instance Methods

- (void)removeAllSubviews;

- (void)removeAllSubviewsWith:(Class)Class;


#pragma mark - Subview Methods

- (UIView *)subviewWithClass:(Class)Class;

- (UIView *)superviewWithClass:(Class)Class;

- (UIView *)subviewAtIndex:(NSInteger)index;


#pragma mark - Animations

- (void)startAnimation:(LJViewAnimation)animation;

@end

@interface UIView (LJXib)

+ (instancetype)loadXibView;

@end

NS_ASSUME_NONNULL_END
