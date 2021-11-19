//
//  OGGradientView.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/4/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJGradientView : UIView

@property (nonatomic, strong) NSArray<UIColor *> *colorsArray;

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;

@end

NS_ASSUME_NONNULL_END
