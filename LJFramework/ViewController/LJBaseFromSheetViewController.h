//
//  LJBaseFromSheetViewController.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/6/10.
//

#import "LJBaseTranslucenceViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LJBaseFromSheetViewController : LJBaseTranslucenceViewController

/// 容器View，
@property (nonatomic, strong) UIView *contentView;

/// 如果视图中包含scrollView类，传入自动计算动态高度，并且在最小、最大高度范围内
@property (nonatomic, strong) UIScrollView *scrollView;

/// 弹出视图最小高度
@property (nonatomic) CGFloat minHeight;

/// 弹出视图最大高度
@property (nonatomic) CGFloat maxHeight;

@end

NS_ASSUME_NONNULL_END
