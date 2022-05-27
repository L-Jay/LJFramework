# LJFramework

LJFramework是iOS开发基础组件，包含网络请求、页面跳转路由封装、自定义UI控件、常用类别扩展等。

## 添加依赖
```ruby
pod 'LJFramework', :git => "git@github.com:L-Jay/LJFramework.git"
```

## 网络请求

```objective-c
// baseUrl配置，https://www.xxx.com
LJNetwork.baseUrl = @"https://www.xxx.com";

// 状态码配置，例如code、errorCode等
LJNetwork.codeKey = @"code";

// 状态码成功值配置，例如0、200等
LJNetwork.successCode = 200;

// 状态码描述配置，例如message、errorMessage等
LJNetwork.messageKey = @"message";

// 默认请求头配置，例如token、version等
[LJNetwork.headers addEntriesFromDictionary:@{
  @"token": token,
  @"version":version,
}];

// 统一错误处理回调，例如token过期、服务器错误等
[LJNetwork hanleAllError:^(NSError * _Nonnull error) {
  // 登录过期
  if (error.code == xxx) {
    [xxx logout];
  }
}];

// get请求
[LJNetwork get:@"/xxx"
            params:@{@"key": @"value",}
      extraHeaders:nil
        modelClass:Model.class
           success:^(Model *model) {
        // do something
    } failure:^(NSError *error) {
        // do something
}];

// post请求
[LJNetwork post:@"/login"
             params:@{@"token": token}
       extraHeaders:nil
         modelClass:nil
            success:^(NSDictionary *model) {
        // do something
    } failure:^(NSError *error) {
        // do something
}];
```

## 路由配置

```objective-c
// 获取登录态
LJRouterManager.getLoginStatus = ^BOOL{
    return LoginManager.loginData;
};

// 注册需要登录才可以跳转的页面，跳转前先判断登录态，未登录调用doLogin回调函数
LJRouterManager.verifyLoginViewControllers = @[
    ViewController1.class,
    ViewController2.class,
    ViewController3.class,
];

// 未登录回调函数，例如弹出登录页，返回Future<bool>类型，true表示登录成功，false取消登录
LJRouterManager.doLogin = ^(void (^loginResult)(void)) {
    // 跳转登录页
    [LoginManager showLogin:^{
        loginResult();
    }];
};

// Push
[self pushViewController:ViewController.class
                animated:YES
               arguments:nil
             popComplete:nil];

// Present
[self presentViewController:ViewController.class
                   animated:YES
                  arguments:nil  
                popComplete:^(NSDictionary *arguments) {
        
}];

// Pop(同时兼容Push、Present)
[self pop:@{@"index":@(indexPath.row)} animated:YES];

// 获取页面传递参
/*
@interface UIViewController (LJRouterManager)

@property (nonatomic, copy) NSDictionary *arguments;

@end*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = [self.arguments[@"index"] integerValue];
    self.name = self.arguments[@"name"];
}
```
## 选项TableView（支持热门、历史）
```Objective-c
self.tableView = [LJOptionTableView new];

// 配置
self.tableView.sectionHeaderHeight = 30;
self.tableView.fixedRowHeight = 50;
self.tableView.showSectionIndex = YES;
self.tableView.showHotSectionIndexTitle = NO;
self.tableView.sectionIndexColor = UIColor.blue;
self.tableView.searchController.searchBar.placeholder = @"请输入名称或代码";
self.tableView.titleKey = @"countryNameEn";
self.tableView.searchKeyArray = @[@"countryNameEn", @"countryCode"];
self.tableView.sectionForHeader = ^UIView *(NSInteger index, NSString *title) {
    UIView *view = [UIView new];
    view.backgroundColor = UIColor.gary;
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    label.text = title;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(view);
    }];
    
    return view;
};
[self.tableView registerNibCell:ChooseCountryTableViewCell.class
                    configCallback:^(ChooseCountryTableViewCell *cell, CountryCodeListItem *model) {
    cell.nameLabel.text = model.countryNameEn;
    cell.codeLabel.text = [NSString stringWithFormat:@"+%@", model.countryCode];
    cell.separatorInset = UIEdgeInsetsZero;
}];
[self.tableView registerNibItem:OGSChooseCountryCollectionViewCell.class
              configCallback:^(OGSChooseCountryCollectionViewCell *cell, OGSCountryCodeListItem *model) {
    cell.nameLabel.text = [NSString stringWithFormat:@"%@(+%@)", model.countryNameEn, model.countryCode];
}];
self.tableView.configCollectionView = ^(UICollectionView *collectionView, UICollectionViewFlowLayout *flowLayout) {
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    collectionView.contentInset = UIEdgeInsetsMake(flowLayout.minimumLineSpacing,
                                                   15,
                                                   flowLayout.minimumLineSpacing,
                                                   15);
    CGFloat itemWidth = (UIScreen.mainScreen.bounds.size.width-10-30)*0.5;
    flowLayout.itemSize = CGSizeMake(itemWidth, 30);
};
self.tableView.selectedComplete = ^(NSInteger index, OGSCountryCodeListItem *model) {
    @strongify(self)
    self.selectedComplete(model.countryCode);
    self.tableView.searchController.active = NO;
    [self.view endEditing:YES];
    [self disMiss];
};
```
## 获取验证码按钮

```objective-c
self.sendCodeButton.textField = self.phoneTextField;
self.sendCodeButton.countDownCallback = ^NSString * _Nonnull(NSInteger second) {
    return [NSString stringWithFormat:@"%lds后重试", second];
};
self.sendCodeButton.doSendCode = ^(void (^successCallback)(void)) {
    @strongify(self)
    [self fetchCode:successCallback];
};

- (void)fetchCode:(void (^)(void))successCallback {
    if (SVProgressHUD.isVisible)
        return;
    
    [SVProgressHUD show];
    [LJNetwork post:@"/code"
             params:@{
                @"phone": self.phoneTextField.text,
             }
       extraHeaders:nil
         modelClass:OGSBaseResponseModel.class
            success:^(id model) {
                [SVProgressHUD showSuccessWithStatus:@"获取验证码成功"];
            successCallback();
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.message];
    }];
}
```

## 菜单栏（可滑动）

```objective-c
NSArray *titles = @[@"消费", @"充值", @"赠送/兑换"];
_menuBar = [LJMenuBar new];
_menuBar.backgroundColor = UIColor.whiteColor;
_menuBar.spacing = 16;
_menuBar.titles = titles;
[self.view addSubview:_menuBar];
@weakify(self)
_menuBar.selectedIndex = ^(NSInteger index) {
    @strongify(self)
        
[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
    atScrollPosition:UICollectionViewScrollPositionNone
            animated:YES];
};
```

## 其他

| 文件 | 描述 |
|------|------|
|   Categorys   |   NSObject、NSString、UIView、UIImage、UIButton、UITableView、UICollectionView、UITextView、UIViewController   |
|   LJStarBar   |  星级条    |
|   LJBottomBar   |  兼容全面屏底部容器View    |
|   LJBaseXibView    |  自定义Xib View父类    |
|  LJGradientView   |  渐变View    |
|  LJViewPropertyInXib   |  Xib选项卡View扩张属性    |
|  LJAutoTextView   |  输入框，自定义高低    |
|   LJBaseTranslucenceViewController  |  半透明弹层基础类    |
|  LJXIBFromSheetViewController   |  Xib底部弹窗    |
|  LJBaseFromSheetViewController  |  底部弹窗基础类    |
|  LJXIBFromCenterViewController  |  中间弹窗基础类    |
|  LJWebViewController  |  WebView    |