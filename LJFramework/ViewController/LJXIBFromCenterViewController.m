//
//  LJXIBFromCenterViewController.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/21.
//

#import "LJXIBFromCenterViewController.h"
#import <Masonry/Masonry.h>

@interface LJXIBFromCenterViewController ()

@end

@implementation LJXIBFromCenterViewController

- (instancetype)init {
    if (self = [super init]) {
        _margin = 30;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.contentView];
//    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.width > 0) {
            make.width.mas_equalTo(self.width);
        }else {
            make.left.mas_equalTo(self.margin);
            make.right.mas_equalTo(-self.margin);
        }
        make.center.equalTo(self.view);
    }];
        
    [self.view layoutIfNeeded];
    
    self.contentView.transform = CGAffineTransformMakeScale(0, 0);
}

- (void)showOrHideSomeView:(BOOL)isShow {
    CGFloat scale = isShow ? 1.0 : 0.0;
    
    self.contentView.transform = CGAffineTransformMakeScale(scale, scale);
}

@end
