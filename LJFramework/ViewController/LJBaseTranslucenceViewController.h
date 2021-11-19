//
//  LJBaseTranslucenceViewController.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJBaseTranslucenceViewController : UIViewController

/// 点击背景dismiss,默认YES
@property (nonatomic) BOOL backgroundEnabled;

@property (nonatomic, strong) UIView *backgroundView;

/**
 动画方法，子类要继承重写此方法，不用写UIView动画，直接改变值即可

 @param isShow 视图弹出状态，已弹出YES，否NO
 */
- (void)showOrHideSomeView:(BOOL)isShow;

/**
 隐藏
 */
- (void)disMiss;

- (void)disMiss:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
