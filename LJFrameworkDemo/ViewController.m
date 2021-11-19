//
//  ViewController.m
//  LJFramework
//
//  Created by 崔志伟 on 2021/7/27.
//

#import "ViewController.h"
#import "UITableView+LJCategory.h"
#import "LJOptionTableView.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) NSArray *vcArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listArray = @[@"OptionTable"];
    self.vcArray = @[@"OptionTableViewController"];
    
    [self.tableView registerCell:UITableViewCell.class];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView reusableCell:UITableViewCell.class indexPath:indexPath];
    cell.textLabel.text = self.listArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [NSClassFromString(self.vcArray[indexPath.row]) new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
