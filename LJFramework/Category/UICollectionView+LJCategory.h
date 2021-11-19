//
//  UICollectionView+LJCategory.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (LJCategory)

- (void)registerCell:(Class)name;
- (void)registerNibCell:(Class)name;

- (void)registerHeader:(Class)name;
- (void)registerFooter:(Class)name;

- (void)registerNibHeader:(Class)name;
- (void)registerNibFooter:(Class)name;

- (UICollectionViewCell *)reusableCell:(Class)name indexPath:(NSIndexPath *)indexPath;
- (UICollectionReusableView *)reusableHeaderClass:(Class)name indexPath:(NSIndexPath *)indexPath;
- (UICollectionReusableView *)reusableFooterClass:(Class)name indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
