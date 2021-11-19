//
//  LJXIBFromCenterViewController.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/21.
//

#import "LJBaseTranslucenceViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LJXIBFromCenterViewController : LJBaseTranslucenceViewController

@property (nonatomic, strong) UIView *contentView;

/// 左右边距
@property (nonatomic) CGFloat margin;

/// 要使width生效不要传margin
@property (nonatomic) CGFloat width;

@end

NS_ASSUME_NONNULL_END
