//
//  LJBaseFromSheetViewController.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/6/10.
//

#import "LJBaseFromSheetViewController.h"
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import "LJDefine.h"

@interface LJBaseFromSheetViewController ()

@property (nonatomic, strong) MASConstraint *topConstraint;
@property (nonatomic, strong) MASConstraint *bottomConstraint;
@property (nonatomic, strong) MASConstraint *heightConstraint;

/// 适配全面屏
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation LJBaseFromSheetViewController

- (id)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.minHeight = 44.0;
    self.maxHeight = 200.0;
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = self.contentView.backgroundColor;
    [self.view addSubview:bottomView];
    
    [self.contentView addObserverBlockForKeyPath:@"backgroundColor"
                                          block:^(id  _Nonnull obj, UIColor  *oldVal, UIColor *newVal) {
        bottomView.backgroundColor = newVal;
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
        self.topConstraint = make.top.equalTo(self.view.mas_bottom);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(LJSafeAreaInsets.bottom);
        self.bottomConstraint = make.bottom.equalTo(self.view);
    }];
    
    [self.topConstraint activate];
    [self.bottomConstraint deactivate];
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

#pragma mark - Setter And Getter

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.heightConstraint = make.height.mas_equalTo(self.minHeight);
    }];
    
    if (self.minHeight != self.maxHeight) {
        @weakify(self);
        [self.scrollView addObserverBlockForKeyPath:@"contentSize"
                                              block:^(id  _Nonnull obj, NSValue  *oldVal, NSValue *newVal) {
            NSLog(@"%@", newVal);
            @strongify(self);
            if (![newVal isEqualToValue:oldVal]) {
                CGFloat height = newVal.CGSizeValue.height;
                self.scrollView.scrollEnabled = height > self.maxHeight;
                
                height = height > self.maxHeight ? self.maxHeight : height;
                height = height < self.minHeight ? self.minHeight : height;
                self.heightConstraint.offset(height);
                [self.view layoutIfNeeded];
            }
        }];
    }
}

@end
