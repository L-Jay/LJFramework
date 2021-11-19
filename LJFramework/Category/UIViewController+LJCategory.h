//
//  UIViewController+LJCategory.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LJCategory)

@property (nonatomic, assign, readonly) UIViewController *currentPresentedController;

@end

NS_ASSUME_NONNULL_END
