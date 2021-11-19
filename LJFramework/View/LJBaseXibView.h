//
//  ETBaseXibView.h
//  LJFramewrok
//
//  Created by cuizhiwei on 2017/9/14.
//  Copyright © 2017年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 自定义带有xib的view继承此类(在xib活storyboard中使用)
 */
IB_DESIGNABLE
@interface LJBaseXibView : UIView

@property (nonatomic, weak) UIView *contentView;

@end
