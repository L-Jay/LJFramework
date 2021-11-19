//
//  UIView+LJCategory.m
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/6/11.
//

#import "UIView+LJCategory.h"

@implementation UIView (LJCategory)

#pragma mark - Coordinate
- (CGFloat)minX {
    return self.frame.origin.x;
}

- (void)setMinX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)minY {
    return self.frame.origin.y;
}

- (void)setMinY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)maxX {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setMaxX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x - frame.size.width;
    self.frame = frame;
}

- (CGFloat)maxY {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMaxY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGPoint)centerBounds {
    return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

- (void)setCenterBounds:(CGPoint)centerBounds
{
    
}

- (CGFloat)moveMinX
{
    return 0;
}

- (void)setMoveMinX:(CGFloat)moveMinX
{
    self.centerX += moveMinX-self.minX;
}

- (CGFloat)moveMinY
{
    return 0;
}

- (void)setMoveMinY:(CGFloat)moveMinY
{
    self.centerY += moveMinY-self.minY;
}

- (CGFloat)moveMaxX
{
    return 0;
}

- (void)setMoveMaxX:(CGFloat)moveMaxX
{
    self.centerX += moveMaxX-self.maxX;
}

- (CGFloat)moveMaxY
{
    return 0;
}

- (void)setMoveMaxY:(CGFloat)moveMaxY
{
    self.centerY += moveMaxY-self.maxY;
}

#pragma mark - Property Extend
- (void)setController:(UIViewController *)controller
{
    
}

- (UIViewController *)controller
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    
    return nil;
}

#pragma mark - Instance Methods
- (void)removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)removeAllSubviewsWith:(Class)Class
{
    for (UIView *view in self.subviews)
        if ([view isKindOfClass:Class]) {
            [view removeFromSuperview];
        }
}

#pragma mark - Subview Methods
- (UIView *)subviewWithClass:(Class)Class
{
    if ([self isKindOfClass:Class])
        return self;
    
    for (UIView *subview in self.subviews) {
        UIView *view = [subview subviewWithClass:Class];
        if (view)
            return view;
    }
    
    return nil;
}

- (UIView *)superviewWithClass:(Class)Class
{
    if ([self isKindOfClass:Class])
        return self;
    else if (self.superview)
        return [self.superview superviewWithClass:Class];
    else
        return nil;
}

- (UIView *)subviewAtIndex:(NSInteger)index
{
    if (self.subviews.count > index)
        return [self.subviews objectAtIndex:index];
    
    return nil;
}

#pragma mark - Animations
- (void)startAnimation:(LJViewAnimation)animation
{
    CATransition *transtion = [CATransition animation];
    transtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];;
    
    CGFloat duration = 0.25;
    NSString *animationType = nil;
    NSString *animationSubType = nil;
    
    switch (animation) {
        case LJViewAnimationFade:
            animationType = kCATransitionFade;
            break;
        case LJViewAnimationRipple:
            animationType = @"rippleEffect";
            duration = 0.5;
            break;
        case LJViewAnimationSuckEffect:
            animationType = @"suckEffect";
            break;
        case LJViewAnimationFlipFromLeft:
            animationType = @"oglFlip";
            animationSubType = kCATransitionFromLeft;
            break;
        case LJViewAnimationFlipFromRight:
            animationType = @"oglFlip";
            animationSubType = kCATransitionFromRight;
            break;
        case LJViewAnimationFlipFromBottm:
            animationType = @"oglFlip";
            animationSubType = kCATransitionFromBottom;
            break;
        case LJViewAnimationFlipFromTop:
            animationType = @"oglFlip";
            animationSubType = kCATransitionFromTop;
            break;
        case LJViewAnimationPageCurlFromLeft:
            animationType = @"pageCurl";
            animationSubType = kCATransitionFromLeft;
            break;
        case LJViewAnimationPageCurlFromRight:
            animationType = @"pageCurl";
            animationSubType = kCATransitionFromRight;
            break;
        case LJViewAnimationPageCurlFromBottom:
            animationType = @"pageCurl";
            animationSubType = kCATransitionFromBottom;
            break;
        case LJViewAnimationPageCurlFromTop:
            animationType = @"pageCurl";
            animationSubType = kCATransitionFromTop;
            break;
        case LJViewAnimationPageUnCurlFromLeft:
            animationType = @"pageUnCurl";
            animationSubType = kCATransitionFromLeft;
            break;
        case LJViewAnimationPageUnCurlFromRight:
            animationType = @"pageUnCurl";
            animationSubType = kCATransitionFromRight;
            break;
        case LJViewAnimationPageUnCurlFromBottom:
            animationType = @"pageUnCurl";
            animationSubType = kCATransitionFromBottom;
            break;
        case LJViewAnimationPageUnCurlFromTop:
            animationType = @"pageUnCurl";
            animationSubType = kCATransitionFromTop;
            break;
        case LJViewAnimationMoveInFromLeft:
            animationType = kCATransitionMoveIn;
            animationSubType = kCATransitionFromLeft;
            break;
        case LJViewAnimationMoveInFromRight:
            animationType = kCATransitionMoveIn;
            animationSubType = kCATransitionFromRight;
            break;
        case LJViewAnimationMoveInFromBottom:
            animationType = kCATransitionMoveIn;
            animationSubType = kCATransitionFromBottom;
            break;
        case LJViewAnimationMoveInFromTop:
            animationType = kCATransitionMoveIn;
            animationSubType = kCATransitionFromTop;
            break;
        case LJViewAnimationPushFromLeft:
            animationType = kCATransitionPush;
            animationSubType = kCATransitionFromLeft;
            break;
        case LJViewAnimationPushFromRight:
            animationType = kCATransitionPush;
            animationSubType = kCATransitionFromRight;
            break;
        case LJViewAnimationPushFromBottom:
            animationType = kCATransitionPush;
            animationSubType = kCATransitionFromBottom;
            break;
        case LJViewAnimationPushFromTop:
            animationType = kCATransitionPush;
            animationSubType = kCATransitionFromTop;
            break;
        case LJViewAnimationRevealFromLeft:
            animationType = kCATransitionReveal;
            animationSubType = kCATransitionFromLeft;
            break;
        case LJViewAnimationRevealFromRight:
            animationType = kCATransitionReveal;
            animationSubType = kCATransitionFromRight;
            break;
        case LJViewAnimationRevealFromBottom:
            animationType = kCATransitionReveal;
            animationSubType = kCATransitionFromBottom;
            break;
        case LJViewAnimationRevealFromTop:
            animationType = kCATransitionReveal;
            animationSubType = kCATransitionFromTop;
            break;
        case LJViewAnimationCubeFromLeft:
            animationType = @"cube";
            animationSubType = kCATransitionFromLeft;
            break;
        case LJViewAnimationCubeFromRight:
            animationType = @"cube";
            animationSubType = kCATransitionFromRight;
            break;
        case LJViewAnimationCubeFromBottom:
            animationType = @"cube";
            animationSubType = kCATransitionFromBottom;
            break;
        case LJViewAnimationCubeFromTop:
            animationType = @"cube";
            animationSubType = kCATransitionFromTop;
            break;
        default:
            animationType = kCATransitionFade;
            break;
    }
    
    transtion.duration = duration;
    transtion.type = animationType;
    transtion.subtype = animationSubType;
    [self.layer addAnimation:transtion forKey:nil];
    transtion = nil;
}
@end

@implementation UIView (LJXib)

+ (instancetype)loadXibView {
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return viewArray.firstObject;
}

@end
