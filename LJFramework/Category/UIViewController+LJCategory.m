//
//  UIViewController+LJCategory.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/6/10.
//

#import "UIViewController+LJCategory.h"

@implementation UIViewController (LJCategory)

- (UIViewController *)currentPresentedController {
    UIViewController *viewController = self.presentedViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    
    return viewController ?: self;
}

@end
