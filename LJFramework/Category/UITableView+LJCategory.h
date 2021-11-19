//
//  UITableView+LJCategory.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (LJCategory)

- (void)registerCell:(Class)name;
- (void)registerNibCell:(Class)name;

- (void)registerHeaderFooter:(Class)name;
- (void)registerNibHeaderFooter:(Class)name;

- (UITableViewCell *)reusableCell:(Class)name indexPath:(NSIndexPath *)indexPath;
- (UITableViewHeaderFooterView *)reusableHeaderFooter:(Class)class;

@end

NS_ASSUME_NONNULL_END
