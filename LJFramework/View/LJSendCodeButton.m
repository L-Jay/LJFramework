//
//  LJSendCodeButton.m
//  LJFramework
//
//  Created by 崔志伟 on 2021/7/30.
//

#import "LJSendCodeButton.h"
#import "NSString+LJCategory.h"
#import <Masonry/Masonry.h>

@interface LJSendCodeButton ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LJSendCodeButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self config];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    self.layer.borderColor = enabled ? self.enableBoardColor.CGColor : self.disableBoardColor.CGColor;
}

- (void)config {
    self.isChinaPhone = YES;
    _countDowmSecond = 60;
    self.enabled = NO;
    [self addTarget:self action:@selector(clickMethod) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickMethod {
    __block NSInteger second = _countDowmSecond;
    
    __weak typeof(self) weskSelf = self;
    self.doSendCode(^{
        [NSTimer scheduledTimerWithTimeInterval:1
                                        repeats:YES
                                          block:^(NSTimer * _Nonnull timer) {
            if (second == 0) {
                [timer invalidate];
                weskSelf.enabled = YES;
            }else {
                weskSelf.enabled = NO;
                NSString *title = self.countDownCallback(second--);
                [weskSelf setTitle:title forState:UIControlStateDisabled];
            }
        }];
    });
}

#pragma mark - Setter And Getter

- (void)setTextField:(UITextField *)textField {
    _textField = textField;
    
    [textField addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)textField1TextChange:(UITextField *)textField {
    if (self.isChinaPhone)
        self.enabled = [textField.text validateiPhoneNum];
    else
        self.enabled = textField.text.length > 0;
}

@end
