//
//  LJMenuBar.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/16.
//

#import "LJMenuBar.h"
#import "LJCategorys.h"
#import <Masonry/Masonry.h>

@interface LJMenuBarCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic) CGFloat maigin;

@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selecredFont;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selecredColor;

@end

@interface LJMenuBar ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation LJMenuBar

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _spacing = 10;
        _index = 0;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                      animated:NO
                                scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJMenuBarCell *cell = (LJMenuBarCell *)[collectionView reusableCell:LJMenuBarCell.class
                                                  indexPath:indexPath];
    cell.backgroundColor = self.backgroundColor;
    cell.maigin = self.spacing;
    cell.selecredFont = self.selecredFont;
    cell.normalFont = self.normalFont;
    cell.selecredColor = self.selecredColor;
    cell.normalColor = self.normalColor;
    cell.titleLabel.text = self.titles[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex)
        self.selectedIndex(indexPath.row);
    
    [collectionView.collectionViewLayout invalidateLayout];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Setter And Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = self.spacing;
        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = self.backgroundColor;
        [_collectionView registerCell:LJMenuBarCell.class];
    }
    
    return _collectionView;
}

@end

@implementation LJMenuBarCell

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.titleLabel.font = self.selecredFont;
        self.titleLabel.textColor = self.selecredColor;
    }else {
        self.titleLabel.font = self.normalFont;
        self.titleLabel.textColor = self.normalColor;
    }
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    CGSize size = [self.contentView systemLayoutSizeFittingSize:CGSizeMake(0, attributes.frame.size.height)
                                  withHorizontalFittingPriority:UILayoutPriorityDefaultLow
                                        verticalFittingPriority:UILayoutPriorityRequired];
    attributes.frame = CGRectMake(attributes.frame.origin.x,
                                  attributes.frame.origin.y,
                                  size.width,
                                  size.height);
    
    return attributes;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = self.normalFont;
        _titleLabel.textColor = self.normalColor;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(self.maigin);
            make.right.mas_equalTo(-self.maigin);
        }];
    }
    
    return _titleLabel;
}

@end
