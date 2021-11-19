//
//  NSObject+LJCategory.m
//  LJFramework
//
//  Created by 崔志伟 on 2021/7/27.
//

#import "NSObject+LJCategory.h"

@implementation NSObject (LJCategory)

- (BOOL)isEmpty {
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self length] == 0;
    }else if ([self isKindOfClass:[NSAttributedString class]]) {
        return [(NSAttributedString *)self length] == 0;
    }else if ([self isKindOfClass:[NSArray class]]) {
        return [(NSArray *)self count] == 0;
    }else if ([self isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)self allKeys].count == 0;
    }
    
    return self;
}

@end

