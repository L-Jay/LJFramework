//
//  LJRouterManager.h
//  LJFramework
//
//  Created by 崔志伟 on 2021/7/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LJRouterManager : NSObject

@property (nonatomic, copy, class) NSArray<Class> *verifyLoginViewControllers;

@property (nonatomic, strong, class) UIViewController *loginViewController;

@property (nonatomic, copy, class) BOOL(^getLoginStatus)(void);
@property (nonatomic, copy, class) void(^doLogin)(void(^loginResult)(void));

@end

@interface UIViewController (LJRouterManager)

@property (nonatomic, copy) NSDictionary *arguments;

@property (nonatomic, copy) void(^popComplete)(NSDictionary *arguments);

- (void)pushViewController:(Class)vcClass animated:(BOOL)animated arguments:(NSDictionary *)arguments popComplete:(void(^)(NSDictionary *arguments))popComplete;
- (void)presentViewController:(Class)vcClass animated:(BOOL)animated arguments:(NSDictionary *)arguments popComplete:(void(^)(NSDictionary *arguments))popComplete;

- (void)pop:(NSDictionary *)arguments animated:(BOOL)animated;

@end

