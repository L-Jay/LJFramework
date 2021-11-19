//
//  ETBaseXibView.m
//  ElongTrain
//
//  Created by cuizhiwei on 2017/9/14.
//  Copyright © 2017年 elong. All rights reserved.
//

#import "LJBaseXibView.h"
#import <Masonry/Masonry.h>

@implementation LJBaseXibView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self loadXibView];
    }
    
    return self;
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    
    [self loadXibView];
}

- (void)loadXibView {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    UIView *containerView = [[nib instantiateWithOwner:self options:nil] firstObject];
    [self addSubview:containerView];
    self.contentView = containerView;
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
