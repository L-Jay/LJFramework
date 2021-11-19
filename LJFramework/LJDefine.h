//
//  LJDefine.h
//  LJFramewrok
//
//  Created by 崔志伟 on 2021/6/10.
//

#ifndef LJDefine_h
#define LJDefine_h

#define LJAnimationDurationTime 0.25

#define LJRootViewController [UIApplication sharedApplication].keyWindow.rootViewController

#define LJStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define LJSafeAreaInsets [UIApplication sharedApplication].keyWindow.safeAreaInsets

#define RANDOMCOLOR [UIColor colorWithRed:arc4random()%11*0.1 green:arc4random()%11*0.1 blue:arc4random()%11*0.1 alpha:arc4random()%6*0.1+0.5]
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define IsEmpty(object) (object==nil || object.isEmpty)

typedef void(^VoidCallback)(void);

#endif /* LJDefine_h */
