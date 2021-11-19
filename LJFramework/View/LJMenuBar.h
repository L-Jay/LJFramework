//
//  LJMenuBar.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJMenuBar : UIView

@property (nonatomic, copy) NSArray *titles;

@property (nonatomic) CGFloat spacing;

@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selecredFont;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selecredColor;

@property (nonatomic, copy) void(^selectedIndex)(NSInteger index);

@property (nonatomic) NSInteger index;

@end

NS_ASSUME_NONNULL_END
