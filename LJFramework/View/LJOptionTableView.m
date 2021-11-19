//
//  LJOptionTableView.m
//  LJFramework
//
//  Created by 崔志伟 on 2021/9/7.
//

#import "LJOptionTableView.h"
#import "UITableView+LJCategory.h"
#import "UICollectionView+LJCategory.h"
#import <Masonry/Masonry.h>

@interface LJOptionTableViewHotCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) Class itemClass;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) MASConstraint *heightConstraint;

@property (nonatomic, copy) NSArray *listArray;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic) void(^configItmeCallback)(UICollectionViewCell *cell, id model);
@property (nonatomic) void(^selectedComplete)(NSInteger index, id model);

- (instancetype)initWithItemClass:(Class)itemClass
                         nibClass:(Class)itemNibClass
                             data:(NSArray *)listArray
             configCollectionView:(void(^)(UICollectionView *collectionView, UICollectionViewFlowLayout *flowLayout))configCollectionView
                   configCallback:(void(^)(UICollectionViewCell *cell, id model))configCallback;

@end

@interface LJOptionTableView ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>

@property (nonatomic) Class cellClass;
@property (nonatomic) Class itemClass;
@property (nonatomic) Class itemNibClass;

@property (nonatomic, copy) void(^configCellCallback)(UITableViewCell *cell, id model);
@property (nonatomic, copy) void(^configItmeCallback)(UICollectionViewCell *cell, id model);

/**
 如果listArray是字典，key不为空，并且按照字母排序
 */
@property (nonatomic, copy) NSArray *keyArray;

@property (nonatomic, copy) NSArray *sectionIndexTitleArray;

@property (nonatomic, copy) NSArray *resultArray;

@end

@implementation LJOptionTableView

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initMethod];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMethod];
    }
    return self;
}

- (void)initMethod {
    self.showHotSectionIndexTitle = YES;
    
    self.dataSource = self;
    self.delegate = self;
    self.sectionIndexBackgroundColor = UIColor.clearColor;
    
    // UISearchController
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.obscuresBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *keyword = searchController.searchBar.text;


    NSMutableArray *originArray = [NSMutableArray array];
    if ([self.listData isKindOfClass:[NSDictionary class]]) {
        for (NSArray *array in [self.listData allValues]) {
            [originArray addObjectsFromArray:array];
        }
    }else {
        originArray = [self.listData mutableCopy];
    }

    NSMutableArray *preArray = @[].mutableCopy;
    BOOL innerIsString = [originArray.firstObject isKindOfClass:NSString.class];
    for (NSString *key in self.searchKeyArray) {
        NSPredicate *kVar = nil;
        if (innerIsString)
            kVar = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", keyword];
        else
            kVar = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", key, keyword];
        [preArray addObject:kVar];
    }
    
    NSCompoundPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:preArray];
    
    [originArray filterUsingPredicate:predicate];
    self.resultArray = originArray;
    [self reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return 1;
    }
    
    return self.keyArray ? self.keyArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.resultArray.count;
    }
    
    if (self.keyArray) {
        NSString *key = self.keyArray[section];
        
        if ([self.hotSectionTitles containsObject:key]) {
            return 1;
        }
        
        NSArray *sectionArray = self.listData[key];
        
        return sectionArray.count;
    }
    
    return [(NSArray *)self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.keyArray[indexPath.section];
    
    if ([self.hotSectionTitles containsObject:key] && !self.searchController.active) {
        LJOptionTableViewHotCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(LJOptionTableViewHotCell.class)];
        if (!cell) {
            cell = [[LJOptionTableViewHotCell alloc] initWithItemClass:self.itemClass
                                                              nibClass:self.itemNibClass
                                                                  data:self.hotSectionValues[indexPath.section]
                                                  configCollectionView:self.configCollectionView
                                                        configCallback:self.configItmeCallback];
            cell.tableView = tableView;
            cell.selectedComplete = self.selectedComplete;
        }
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView reusableCell:self.cellClass
                                          indexPath:indexPath];
    
    
    if (self.configCellCallback) {
        id model = [self getModelWithIndexPath:indexPath];
        self.configCellCallback(cell, model);
    }
    
    return cell;
}

- (id)getModelWithIndexPath:(NSIndexPath *)indexPath {
    // 搜索
    if (self.searchController.active) {
        return self.resultArray[indexPath.row];
    }
    
    //
    id model = nil;
    if ([self.listData isKindOfClass:[NSDictionary class]]) {
        NSString *key = self.keyArray[indexPath.section];
        NSArray *sectionArray = self.listData[key];
        
        model = sectionArray[indexPath.row];
    }else {
        model = self.listData[indexPath.row];
    }
    
    return model;
}


#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchController.active) {
        return indexPath;
    }
    
    NSString *key = self.keyArray[indexPath.section];
    if ([self.hotSectionTitles containsObject:key])
        return nil;
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedComplete) {
        id model = [self getModelWithIndexPath:indexPath];
        self.selectedComplete(indexPath.row, model);
    }
    
    self.searchController.active = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.hotSectionValues.count)
        return UITableViewAutomaticDimension;
    
    return self.fixedRowHeight > 0 ? self.fixedRowHeight : UITableViewAutomaticDimension;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.sectionIndexTitleArray && !self.searchController.active) {
        return self.sectionIndexTitleArray;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.keyArray && !self.searchController.active && self.sectionForHeader) {
        return self.sectionHeaderHeight;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.keyArray && !self.searchController.active && self.sectionForHeader) {
        return self.sectionForHeader(section, self.keyArray[section]);
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.keyArray && !self.searchController.active && self.sectionHeaderHeight > 0 && !self.sectionForHeader) {
        return self.keyArray[section];
    }
    
    return nil;
}

#pragma mark - Register

- (void)registerCell:(Class)tableViewCellClass configCallback:(void (^)(__kindof UITableViewCell *, id))configCallback {
    self.cellClass = tableViewCellClass;
    self.configCellCallback = configCallback;
    
    [self registerCell:tableViewCellClass];
}

- (void)registerNibCell:(Class)tableViewCellClass configCallback:(void (^)(__kindof UITableViewCell *, id))configCallback {
    self.cellClass = tableViewCellClass;
    self.configCellCallback = configCallback;
    
    [self registerNibCell:tableViewCellClass];
}

- (void)registerItem:(Class)collectionItemClass configCallback:(void (^)(__kindof UICollectionViewCell *, id))configCallback {
    self.itemClass = collectionItemClass;
    self.configItmeCallback = configCallback;
}

- (void)registerNibItem:(Class)collectionItemClass configCallback:(void (^)(__kindof UICollectionViewCell *, id))configCallback {
    self.itemNibClass = collectionItemClass;
    self.configItmeCallback = configCallback;
}

#pragma mark - Setter And Getter

- (void)setListData:(id)listData {
    if ([listData isKindOfClass:[NSDictionary class]]) {
        _listData = listData;
        self.keyArray = [[listData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }else if ([listData isKindOfClass:[NSArray class]] && self.showSectionIndex) {
        _listData = [self sortListData:listData];
        self.keyArray = [[_listData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }else {
        _listData = listData;
    }
    
    if (self.showSectionIndex && !self.showHotSectionIndexTitle)
        self.sectionIndexTitleArray = self.keyArray.copy;
    
    if (self.keyArray && self.hotSectionTitles.count > 0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.hotSectionTitles];
        [array addObjectsFromArray:self.keyArray];
        self.keyArray = array;
    }
    
    if (self.showSectionIndex && self.showHotSectionIndexTitle)
        self.sectionIndexTitleArray = self.keyArray.copy;
    
    self.tableHeaderView = self.searchKeyArray.count > 0 ? self.searchController.searchBar : nil;
    
    [self reloadData];
}

- (NSDictionary *)sortListData:(NSArray *)array {
    // 分组
    UILocalizedIndexedCollation *indexedCollation = [UILocalizedIndexedCollation currentCollation];
    
    NSArray *indexTitles = [indexedCollation sectionTitles];
    
    NSMutableDictionary *finalDic = [NSMutableDictionary dictionary];
   
    for (id object in array) {
        NSInteger sectionIndex;
        
        if (self.titleKey || [object isKindOfClass:NSDictionary.class])
            sectionIndex = [indexedCollation sectionForObject:[object valueForKey:self.titleKey]
                                      collationStringSelector:@selector(self)];
        else if ([object isKindOfClass:NSString.class])
            sectionIndex = [indexedCollation sectionForObject:object
                                      collationStringSelector:@selector(self)];
        else
            sectionIndex = 0;
        
        if (sectionIndex > indexTitles.count-1)
            continue;
        
        NSString *key = indexTitles[sectionIndex];
        
        NSMutableArray *sectionArray = finalDic[key];
        if (sectionArray) {
            [sectionArray addObject:object];
        }else {
            [finalDic setObject:[NSMutableArray arrayWithObject:object]
                         forKey:key];
        }
    }
    
    return finalDic;
}

@end

@implementation LJOptionTableViewHotCell

- (void)dealloc {
    @try {
        [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
    } @catch (NSException *exception) {
        NSAssert(NO, exception.reason);
    } @finally {
        
    }
}

- (instancetype)initWithItemClass:(Class)itemClass
                         nibClass:(Class)itemNibClass
                             data:(NSArray *)listArray
                   configCollectionView:(void (^)(UICollectionView *, UICollectionViewFlowLayout *))configCollectionView
                   configCallback:(void (^)(UICollectionViewCell *, id))configCallback {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self.class)]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.userInteractionEnabled = NO;
        
        self.itemClass = itemClass ?: itemNibClass;
        self.listArray = listArray;
        self.configItmeCallback = configCallback;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                 collectionViewLayout:flowLayout];
        if (configCollectionView)
            configCollectionView(self.collectionView, flowLayout);
            
        if (itemClass)
            [self.collectionView registerCell:itemClass];
        else
            [self.collectionView registerNibCell:itemNibClass];
        
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.scrollEnabled = NO;
        self.collectionView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            self.heightConstraint = make.height.mas_equalTo(44);
        }];
        
        [self.collectionView addObserver:self
                              forKeyPath:@"contentSize"
                                 options:NSKeyValueObservingOptionNew
                                 context:nil];
    }
    
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView reusableCell:self.itemClass indexPath:indexPath];
    
    if (self.configItmeCallback)
        self.configItmeCallback(cell, self.listArray[indexPath.row]);
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedComplete)
        self.selectedComplete(indexPath.row, self.listArray[indexPath.row]);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat height = self.collectionView.contentSize.height+self.collectionView.contentInset.top+self.collectionView.contentInset.bottom;
        self.heightConstraint.offset(height);
        [self.contentView layoutIfNeeded];
        [self.tableView reloadData];
    }
}

@end
