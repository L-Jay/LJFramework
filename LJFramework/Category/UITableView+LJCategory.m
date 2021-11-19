//
//  UITableView+LJCategory.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/6/10.
//

#import "UITableView+LJCategory.h"

@implementation UITableView (LJCategory)

- (void)registerCell:(Class)name {
    [self registerClass:name forCellReuseIdentifier:NSStringFromClass(name)];
}

- (void)registerNibCell:(Class)name {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(name) bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:NSStringFromClass(name)];
}

- (void)registerHeaderFooter:(Class)name {
    [self registerClass:name forHeaderFooterViewReuseIdentifier:NSStringFromClass(name)];
}

- (void)registerNibHeaderFooter:(Class)name {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(name) bundle:nil];
    [self registerNib:nib forHeaderFooterViewReuseIdentifier:NSStringFromClass(name)];
}

- (UITableViewCell *)reusableCell:(Class)name indexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(name) forIndexPath:indexPath];
}

- (UITableViewHeaderFooterView *)reusableHeaderFooter:(Class)class {
    return [self dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(class)];
}

@end
