//
//  LJSendCodeButton.h
//  LJFramework
//
//  Created by 崔志伟 on 2021/7/30.
//

#import <UIKit/UIKit.h>

@interface LJSendCodeButton : UIButton

@property (nonatomic) BOOL isChinaPhone;

@property (nonatomic, strong) UIColor *enableBoardColor;
@property (nonatomic, strong) UIColor *disableBoardColor;

@property (nonatomic) NSInteger countDowmSecond;

/// 监听手机号的UITextField
@property (nonatomic) UITextField *textField;

/// 返回倒计时title
@property (nonatomic, copy) NSString *(^countDownCallback)(NSInteger second);

@property (nonatomic, copy) void(^doSendCode)(void(^successCallback)(void));

@end
