//
//  LJStarBar.h
//  
//
//  Created by 崔志伟 on 2021/7/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJStarBar : UIView

@property (nonatomic) NSInteger level;
@property (nonatomic) NSInteger total;

@property (nonatomic) CGFloat spacing;

@property (nonatomic, copy) NSString *defaultImageName;
@property (nonatomic, copy) NSString *selectedImageName;

@property (nonatomic) BOOL canSelected;

@property (nonatomic, copy) void(^selectedComplete)(NSInteger index);

- (void)setup;

@end

NS_ASSUME_NONNULL_END
