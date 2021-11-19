//
//  UICollectionView+LJCategory.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/10.
//

#import "UICollectionView+LJCategory.h"

@implementation UICollectionView (LJCategory)

- (void)registerCell:(Class)name {
    [self registerClass:name forCellWithReuseIdentifier:NSStringFromClass(name)];
}

- (void)registerNibCell:(Class)name {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(name) bundle:nil];
    [self registerNib:nib forCellWithReuseIdentifier:NSStringFromClass(name)];
}

- (void)registerHeader:(Class)name {
    [self registerClass:name forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
    withReuseIdentifier:NSStringFromClass(name)];
}

- (void)registerFooter:(Class)name {
    [self registerClass:name forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
    withReuseIdentifier:NSStringFromClass(name)];
}

- (void)registerNibHeader:(Class)name {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(name) bundle:nil];
    [self registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
  withReuseIdentifier:NSStringFromClass(name)];
}

- (void)registerNibFooter:(Class)name {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(name) bundle:nil];
    [self registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
  withReuseIdentifier:NSStringFromClass(name)];
}

- (UICollectionViewCell *)reusableCell:(Class)name indexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithReuseIdentifier:NSStringFromClass(name)
                                           forIndexPath:indexPath];
}

- (UICollectionReusableView *)reusableHeaderClass:(Class)name indexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                    withReuseIdentifier:NSStringFromClass(name)
                                           forIndexPath:indexPath];
}

- (UICollectionReusableView *)reusableFooterClass:(Class)name indexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                    withReuseIdentifier:NSStringFromClass(name)
                                           forIndexPath:indexPath];
}

@end
