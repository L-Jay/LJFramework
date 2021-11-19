//
//  LJWebViewController.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJWebViewController : UIViewController

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *htmlString;

@property (nonatomic, strong, class) UIColor *progressColor;
/// default 1.0
@property (nonatomic, class) CGFloat progressHeight;

- (void)addJSMethod:(NSString *)methodName complete:(void(^)(NSDictionary *params))complete;

@end

NS_ASSUME_NONNULL_END
