//
//  OptionTableViewController.m
//  LJFramework
//
//  Created by 崔志伟 on 2021/9/7.
//

#import "OptionTableViewController.h"
#import "LJOptionTableView.h"
#import "LJFramework.h"

@interface OptionTableViewController ()

@property (weak, nonatomic) IBOutlet LJOptionTableView *optionTableView;

@end

@implementation OptionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LJNetwork.codeKey = @"error_code";
    LJNetwork.successCode = 0;
    [LJNetwork get:@"http://apis.juhe.cn/xzqh/query?key=b0f6256515bfc7ae93ab3a48835bf91d&fid=0"
            params:nil
      extraHeaders:nil
        modelClass:nil
           success:^(NSDictionary *model) {
        NSLog(@"%@", model);
        NSArray *array = model[@"result"];


        NSMutableArray *temp1 = @[].mutableCopy;
        NSMutableArray *temp2 = @[].mutableCopy;
        for (int i = 0; i < 9; i++) {
            if (i < 5)
                [temp1 addObject:array[arc4random()%array.count]];

            [temp2 addObject:array[arc4random()%array.count]];
        }

        self.optionTableView.hotSectionTitles = @[@"", @""];
        self.optionTableView.hotSectionValues = @[temp1, temp2];
        self.optionTableView.listData = array;
    } failure:^(NSError *error) {

    }];
    
    self.optionTableView.titleKey = @"name";
    self.optionTableView.sectionHeaderHeight = 30;
    self.optionTableView.showSectionIndex = YES;
    self.optionTableView.searchKeyArray = @[@"name"];
    self.optionTableView.sectionForHeader = ^UIView *(NSInteger index, NSString *title) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.orangeColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
        label.text = title;
        [view addSubview:label];
        
        return view;
    };
    [self.optionTableView registerCell:UITableViewCell.class
                        configCallback:^(UITableViewCell *cell, NSDictionary *model) {
        cell.textLabel.text = model[@"name"];
        cell.backgroundColor = RANDOMCOLOR;
        cell.contentView.backgroundColor = RANDOMCOLOR;
    }];
    [self.optionTableView registerItem:UICollectionViewCell.class
                        configCallback:^(UICollectionViewCell * _Nonnull cell, id  _Nonnull model) {
        UIView *view1 = [UIView new];
        view1.backgroundColor = RANDOMCOLOR;
        cell.backgroundView = view1;
        
        UIView *view2 = [UIView new];
        view2.backgroundColor = RANDOMCOLOR;
        cell.selectedBackgroundView = view2;
    }];
    self.optionTableView.configCollectionView = ^(UICollectionView *collectionView, UICollectionViewFlowLayout *flowLayout) {
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        collectionView.contentInset = UIEdgeInsetsMake(flowLayout.minimumLineSpacing,
                                                       15,
                                                       flowLayout.minimumLineSpacing,
                                                       15);
        CGFloat itemWidth = (UIScreen.mainScreen.bounds.size.width-10-30)*0.5;
        flowLayout.itemSize = CGSizeMake(itemWidth, 30);
    };
    self.optionTableView.selectedComplete = ^(NSInteger index, id model) {
        NSLog(@"%@", model);
    };
    
//    LJNetwork.codeKey = @"error_code";
//    LJNetwork.successCode = 0;
//    [LJNetwork get:@"http://www.mxnzp.com/api/address/list"
//            params:nil
//      extraHeaders:nil
//        modelClass:nil
//           success:^(id model) {
//        NSLog(@"%@", model);
//    } failure:^(NSError *error) {
//
//    }];
}

@end
