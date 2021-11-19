//
//  LJBaseTranslucenceViewController.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/6/10.
//

#import "LJBaseTranslucenceViewController.h"
#import "LJDefine.h"

@interface LJBaseTranslucenceViewController ()

@property (nonatomic, strong) UIControl *translucenceView;

@property (nonatomic) BOOL isShow;

@end

@implementation LJBaseTranslucenceViewController

#pragma mark - init

- (id)init {
    if (self = [super init]) {
        // 透明显示设置
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // 透明显示设置
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.translucenceView];
    [self.view sendSubviewToBack:self.translucenceView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.isShow = YES;
    [self backgroundAnimation:nil];
}

- (void)backgroundAnimation:(void (^)(void))completion {
    [UIView animateWithDuration:LJAnimationDurationTime
                     animations:^{
                         self.translucenceView.alpha = self.isShow ? 1 : 0;
                         
                         [self showOrHideSomeView:self.isShow];
                     } completion:^(BOOL finished) {
                         if (!self.isShow) {
                             [self dismissViewControllerAnimated:NO completion:completion];
                         }
                     }];
}

- (void)showOrHideSomeView:(BOOL)show {
    
}

- (void)disMiss {
    [self disMiss:nil];
}

- (void)disMiss:(void (^)(void))completion {
    self.isShow = NO;
    [self backgroundAnimation:completion];
}

#pragma mark - Setter And Getter

- (void)setBackgroundEnabled:(BOOL)backgroundEnabled {
    _backgroundEnabled = backgroundEnabled;
    
    self.translucenceView.enabled = backgroundEnabled;
}

- (UIControl *)translucenceView {
    if (!_translucenceView) {
        _translucenceView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _translucenceView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _translucenceView.alpha = 0;
        [_translucenceView addTarget:self
                              action:@selector(disMiss)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _translucenceView;
}

- (void)setBackgroundView:(UIView *)backgroundView {
    _backgroundView = backgroundView;
    
    backgroundView.frame = self.translucenceView.bounds;
    backgroundView.userInteractionEnabled = NO;
    [self.translucenceView addSubview:backgroundView];
    self.translucenceView.backgroundColor = UIColor.clearColor;
}

@end
