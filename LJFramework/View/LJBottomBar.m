//
//  LJBottomBar.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/20.
//

#import "LJBottomBar.h"
#import <Masonry/Masonry.h>

@implementation LJBottomBar

- (instancetype)initWithContentHeight:(CGFloat)height {
    if (self = [super initWithFrame:CGRectZero]) {
        _contentView = [UIView new];
        _contentView.backgroundColor = self.backgroundColor;
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(height);
        }];
        
        CGFloat bottomSafeInset = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(bottomSafeInset+height);
        }];
    }
    
    return self;
}

@end
