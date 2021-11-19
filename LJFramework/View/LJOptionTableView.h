//
//  LJOptionTableView.h
//  LJFramework
//
//  Created by 崔志伟 on 2021/9/7.
//

#import <UIKit/UIKit.h>

@interface LJOptionTableView : UITableView

/// 固定高度，大于0生效
@property (nonatomic) CGFloat fixedRowHeight;

/// 是否显示索引
@property (nonatomic) BOOL showSectionIndex;
/// 是否显示热门索引，默认YES
@property (nonatomic) BOOL showHotSectionIndexTitle;

/// 热门section title，与hotSectionValues一一对应，为空穿@“”，不显示section title
@property (nonatomic, copy) NSArray *hotSectionTitles;
/// 热门section value，与hotSectionTitles一一对应
@property (nonatomic, copy) NSArray *hotSectionValues;

/// 用于搜索，遍历所有的key
@property (nonatomic, copy) NSArray *searchKeyArray;

/// 用于分组排序
@property (nonatomic, copy) NSString *titleKey;


/// 在其他数据配置完成后最后配置
/// 列表数据，id型，可以为字典，数组，取值使用KVC，内部元素可以为model，
/// 如果显示索引，字典按照key排序并索引，数组根据pinyinKey/pinyinsuoKey建立索引
@property (nonatomic, copy) id listData;

@property (nonatomic, copy) UIView *(^sectionForHeader)(NSInteger index,  NSString *title);

@property (nonatomic, copy) void(^configCollectionView)(UICollectionView *collectionView, UICollectionViewFlowLayout *flowLayout);

@property (nonatomic, copy) void(^selectedComplete)(NSInteger index, id model);

- (void)registerCell:(Class)tableViewCellClass configCallback:(void(^)(__kindof UITableViewCell *cell, id model))configCallback;
- (void)registerNibCell:(Class)tableViewCellClass configCallback:(void(^)(__kindof UITableViewCell *cell, id model))configCallback;

- (void)registerItem:(Class)collectionItemClass configCallback:(void(^)(__kindof UICollectionViewCell *cell, id model))configCallback;
- (void)registerNibItem:(Class)collectionItemClass configCallback:(void(^)(__kindof UICollectionViewCell *cell, id model))configCallback;

#pragma mark - other

@property (nonatomic, strong, readonly) UISearchController *searchController;

@end
