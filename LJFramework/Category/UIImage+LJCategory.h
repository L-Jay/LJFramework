//
//  UIImage+LJCategory.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LJCategory)

+ (UIImage *_Nullable)imageWithColor:(UIColor *_Nonnull)color;

+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors imgSize:(CGSize)imgSize;

@end

NS_ASSUME_NONNULL_END
