//
//  LJBottomBar.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJBottomBar : UIView

- (instancetype)initWithContentHeight:(CGFloat)height;

@property (nonatomic, strong, readonly) UIView *contentView;

@end

NS_ASSUME_NONNULL_END
