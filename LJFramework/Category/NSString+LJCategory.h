//
//  NSString+LJCategory.h
//  LJFramework
//
//  Created by 崔志伟 on 2021/7/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LJCategory)

- (NSURL *)toURL;

- (UIImage *)image;

#pragma mark - Validate String

- (BOOL)validateiPhoneNum;

- (BOOL)validateEmail;

- (BOOL)validateURL;

- (BOOL)validateMatchesString:(NSString *)matchStr;

#pragma mark - Cache Path

+ (NSString *)cachePathWithName:(NSString *)name;
+ (NSString *)documentPathWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
