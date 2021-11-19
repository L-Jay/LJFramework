//
//  LJRouterManager.m
//  LJFramework
//
//  Created by 崔志伟 on 2021/7/29.
//

#import "LJRouterManager.h"
#import <objc/runtime.h>

static NSArray *_verifyLoginViewControllers = nil;

static UIViewController *_loginViewController = nil;

static BOOL(^_getLoginStatus)(void) = nil;
static void(^_doLogin)(void(^loginResult)(void)) = nil;

@implementation LJRouterManager

+ (void)setVerifyLoginViewControllers:(NSArray *)verifyLoginViewControllers {
    _verifyLoginViewControllers = verifyLoginViewControllers.copy;
}

+ (NSArray *)verifyLoginViewControllers {
    return _verifyLoginViewControllers;
}

+ (void)setLoginViewController:(UIViewController *)loginViewController {
    _loginViewController = loginViewController;
}

+ (UIViewController *)loginViewController {
    return _loginViewController;
}

+ (void)setGetLoginStatus:(BOOL (^)(void))getLoginStatus {
    _getLoginStatus = getLoginStatus;
}

+ (BOOL (^)(void))getLoginStatus {
    return _getLoginStatus;
}

+ (void)setDoLogin:(void (^)(void (^)(void)))doLogin {
    _doLogin = doLogin;
}

+ (void (^)(void (^)(void)))doLogin {
    return _doLogin;
}

@end

@implementation UIViewController (LJRouterManager)

- (void)setArguments:(NSDictionary *)arguments {
    objc_setAssociatedObject(self, @selector(arguments), arguments, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDictionary *)arguments {
    return objc_getAssociatedObject(self, @selector(arguments));
}

- (void)setPopComplete:(void (^)(NSDictionary *arguments))popComplete {
    objc_setAssociatedObject(self, @selector(popComplete), popComplete, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSDictionary *arguments))popComplete {
    return objc_getAssociatedObject(self, @selector(popComplete));
}

- (void)pushViewController:(Class)vcClass animated:(BOOL)animated arguments:(NSDictionary *)arguments popComplete:(void (^)(NSDictionary *arguments))popComplete {
    [self showVC:vcClass isPush:YES animated:animated arguments:arguments popComplete:popComplete];
}

- (void)presentViewController:(Class)vcClass animated:(BOOL)animated arguments:(NSDictionary *)arguments popComplete:(void (^)(NSDictionary *arguments))popComplete {
    [self showVC:vcClass isPush:NO animated:animated arguments:arguments popComplete:popComplete];
}

- (void)showVC:(Class)class isPush:(BOOL)isPush animated:(BOOL)animated arguments:(NSDictionary *)arguments popComplete:(void (^)(NSDictionary *arguments))popComplete {
    BOOL needLogin = [LJRouterManager.verifyLoginViewControllers containsObject:class];
    BOOL isLogin = LJRouterManager.getLoginStatus();
    
    if (needLogin && !isLogin) {
        LJRouterManager.doLogin(^{
            UIViewController *vc = [class new];
            vc.arguments = arguments;
            vc.popComplete = popComplete;
            
            [self push:isPush vc:vc animated:animated];
        });
    }else {
        UIViewController *vc = [class new];
        vc.arguments = arguments;
        vc.popComplete = popComplete;
        
        [self push:isPush vc:vc animated:animated];
    }
}

- (void)push:(BOOL)isPush vc:(UIViewController *)vc animated:(BOOL)animated {
    if (isPush) {
        if ([self isKindOfClass:UINavigationController.class])
            [(UINavigationController *)self pushViewController:vc animated:animated];
        else
            [self.navigationController pushViewController:vc animated:animated];
    }else {
        if ([vc isKindOfClass:UINavigationController.class])
            [self presentViewController:vc animated:animated completion:nil];
        else {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = vc.modalPresentationStyle;
            [self presentViewController:nav animated:animated completion:nil];
        }
    }
}

- (void)pop:(NSDictionary *)arguments animated:(BOOL)animated {
    if (self.popComplete) {
        self.popComplete(arguments);
    }
    
    if (self.navigationController.viewControllers.count > 1)
        [self.navigationController popViewControllerAnimated:animated];
    else if (self.presentingViewController)
        [self.presentingViewController dismissViewControllerAnimated:animated completion:nil];
}

@end
