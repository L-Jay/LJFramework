//
//  LJXIBFromSheetViewController.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/10.
//

#import "LJXIBFromSheetViewController.h"
#import <Masonry/Masonry.h>

@interface LJXIBFromSheetViewController ()

@property (nonatomic, strong) MASConstraint *topConstraint;
@property (nonatomic, strong) MASConstraint *bottomConstraint;
@property (nonatomic, strong) MASConstraint *heightConstraint;

@end

@implementation LJXIBFromSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.contentView];
    CGFloat height = self.fixedHeight > 0 ? self.fixedHeight : [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(height);
        self.bottomConstraint = make.bottom.equalTo(self.view);
        self.topConstraint = make.top.equalTo(self.view.mas_bottom);
    }];
    
    [self.topConstraint activate];
    [self.bottomConstraint deactivate];
    
    [self.view layoutIfNeeded];
}

- (void)showOrHideSomeView:(BOOL)isShow {
    if (isShow) {
        [self.topConstraint deactivate];
        [self.bottomConstraint activate];
    }else {
        [self.topConstraint activate];
        [self.bottomConstraint deactivate];
    }
    
    [self.view layoutIfNeeded];
}

@end
