//
//  LJStarBar.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/12.
//

#import "LJStarBar.h"
#import <Masonry/Masonry.h>

@interface LJStarBar ()

@property (nonatomic, strong) UIButton *conentButton;

@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation LJStarBar

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.level = 0;
        self.total = 5;
        self.spacing = 10;
        
        self.clipsToBounds = YES;
        
        self.backgroundColor = UIColor.clearColor;
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.level = 0;
    self.total = 5;
    self.spacing = 10;
    
    self.clipsToBounds = YES;
    
    self.backgroundColor = UIColor.clearColor;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.level = 0;
        self.total = 5;
        self.spacing = 10;
        
        self.clipsToBounds = YES;
        
        self.backgroundColor = UIColor.clearColor;
    }
    
    return self;
}

- (void)setup {
    NSMutableArray *views = @[].mutableCopy;
    
    for (int i = 1; i <= self.total; i++) {
        UIButton *button = self.conentButton;
        button.tag = i;
        button.selected = i < self.level;
        [views addObject:button];
    }
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:views];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.spacing = self.spacing;
    stackView.alignment = UIStackViewAlignmentFill;
    [self addSubview:stackView];
    self.stackView = stackView;
    
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self layoutIfNeeded];
}

- (UIButton *)conentButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:self.defaultImageName] forState:0];
    [button setImage:[UIImage imageNamed:self.selectedImageName] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:self.selectedImageName] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickStar:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)setLevel:(NSInteger)level {
    _level = level;
    
    [self updateUI:level];
}

- (void)clickStar:(UIButton *)button {
    if (self.canSelected) {
        [self updateUI:button.tag];
        
        if (self.selectedComplete)
            self.selectedComplete(button.tag);
    }
}

- (void)updateUI:(NSInteger)selectedIndex {
    _level = selectedIndex;
    
    for (int i = 1; i <= self.total; i++) {
        UIButton *button = self.stackView.subviews[i-1];
        button.selected = i <= selectedIndex;
    }
}

@end
