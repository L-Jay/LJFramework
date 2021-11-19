//
//  LJWebViewController.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/19.
//

#import "LJWebViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>

static UIColor *_progressColor = nil;
/// default 1.0
static CGFloat _progressHeight = 1.0;

@interface LJWebViewController ()<UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;

@property (nonatomic) BOOL preNavibarHidden;
@property (nonatomic) CGFloat preNavibarAlpha;

@property (nonatomic, strong) UIView *naviBarImageView;

@property (nonatomic, strong) NSMutableDictionary *jsCallbackDictionary;

@end

@implementation LJWebViewController

- (void)dealloc {
    [_webView removeObserverBlocksForKeyPath:@"title"];
    [_webView removeObserverBlocksForKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self)
    [self.webView addObserverBlockForKeyPath:@"title"
                                       block:^(id  _Nonnull obj, id  _Nonnull oldVal, NSString *newVal) {
        @strongify(self)
        self.navigationItem.title = newVal;
    }];
    
    [self.webView addObserverBlockForKeyPath:@"estimatedProgress"
                                       block:^(id  _Nonnull obj, id  _Nonnull oldVal, NSNumber *newVal) {
        @strongify(self)
        self.progressView.progress = newVal.doubleValue;
        if (newVal.doubleValue >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    }];
    
    if (self.urlString == nil || self.urlString.length == 0)
        [self.webView loadHTMLString:self.htmlString baseURL:nil];
    else
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.preNavibarHidden = self.navigationController.navigationBarHidden;
    self.preNavibarAlpha = self.naviBarImageView.alpha;
    self.naviBarImageView.alpha = 1;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.jsCallbackDictionary.allKeys enumerateObjectsUsingBlock:^(NSString *methodName, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:methodName];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:self.preNavibarHidden animated:YES];
    self.naviBarImageView.alpha = self.preNavibarAlpha;
    
    [self.jsCallbackDictionary.allKeys enumerateObjectsUsingBlock:^(NSString *methodName, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:methodName];
    }];
}

#pragma mark - JS Methods

- (void)addJSMethod:(NSString *)methodName complete:(void (^)(NSDictionary * _Nonnull))complete {
    self.jsCallbackDictionary[methodName] = complete;
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    void(^complte)(NSDictionary *params) = self.jsCallbackDictionary[message.name];
    if (complte)
        complte(message.body);
}

#pragma mark - Setter And Getter

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        // 实例化对象
        configuration.userContentController = [WKUserContentController new];
        
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero
                                      configuration:configuration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = LJWebViewController.progressColor;
        [self.view addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(LJWebViewController.progressHeight);
        }];
    }
    
    return _progressView;
}

+ (UIColor *)progressColor {
    return _progressColor ?: UIColor.blueColor;
}

+ (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
}

+ (CGFloat)progressHeight {
    return _progressHeight > 0 ? _progressHeight : 1;
}

+ (void)setProgressHeight:(CGFloat)progressHeight {
    _progressHeight = progressHeight;
}

- (UIView *)naviBarImageView {
    UIView *backView = self.navigationController.navigationBar.subviews.firstObject;
    
    return backView;
}

- (NSMutableDictionary *)jsCallbackDictionary {
    if (!_jsCallbackDictionary)
        _jsCallbackDictionary = @{}.mutableCopy;
    
    return _jsCallbackDictionary;
}

@end
