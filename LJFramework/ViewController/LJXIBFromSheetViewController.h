//
//  LJXIBFromSheetViewController.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/10.
//

#import <UIKit/UIKit.h>
#import "LJBaseTranslucenceViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LJXIBFromSheetViewController : LJBaseTranslucenceViewController

@property (nonatomic) CGFloat fixedHeight;

@property (nonatomic, strong) UIView *contentView;

@end

NS_ASSUME_NONNULL_END
