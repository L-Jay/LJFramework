//
//  LJAutoTextView.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/19.
//

#import "LJAutoTextView.h"

@implementation LJAutoTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _minHeight = 20;
        _maxHeight = MAXFLOAT;
    }
    
    return self;
}

- (void)setContentSize:(CGSize)contentSize {
    super.contentSize = contentSize;
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    if (self.contentSize.height < self.minHeight)
        return CGSizeMake(self.contentSize.width, self.minHeight);
    else if (self.contentSize.height > self.maxHeight)
        return CGSizeMake(self.contentSize.width, self.maxHeight);
    
    return self.contentSize;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

@end
