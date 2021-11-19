//
//  NSString+LJCategory.m
//  LJFramework
//
//  Created by 崔志伟 on 2021/7/28.
//

#import "NSString+LJCategory.h"

@implementation NSString (LJCategory)

- (NSURL *)toURL {
    return [NSURL URLWithString:self];
}

- (UIImage *)image {
    return [UIImage imageNamed:self];
}

#pragma mark - Validate String
- (BOOL)validateiPhoneNum
{
    return [self validateMatchesString: @"^1[3|4|5|6|7|8|9][0-9]{9}$"];
}

- (BOOL)validateEmail
{
    return [self validateMatchesString: @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

- (BOOL)validateURL
{
    return [self validateMatchesString: @"[a-zA-z]+://[^\\s]*"];
}

- (BOOL)validateMatchesString:(NSString *)matchStr
{
    NSPredicate *userTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", matchStr];
    return [userTest evaluateWithObject: self];
}

#pragma mark - Cache Path

+ (NSString *)cachePathWithName:(NSString *)name {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:name];
    
    return path;
}

+ (NSString *)documentPathWithName:(NSString *)name {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:name];
    
    return path;
}

@end
