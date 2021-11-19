//
//  UITextView+LJCategory.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/7/21.
//

#import "UITextView+LJCategory.h"

@implementation UITextView (LJCategory)

- (void)setPlaceholder:(NSString *)text color:(UIColor *)color {
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = text;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = color;
    placeHolderLabel.font = self.font;
    [placeHolderLabel sizeToFit];
    [self addSubview:placeHolderLabel];
    
    [self setValue:placeHolderLabel forKey:[NSString stringWithFormat:@"%@%@%@",
                                            [self holderKey1],
                                            [self holderKey2],
                                            [self holderKey3]
                                            ]];
}

- (NSString *)holderKey1 {
    return @"_place";
}

- (NSString *)holderKey2 {
    return @"holder";
}

- (NSString *)holderKey3 {
    return @"Label";
}

@end
