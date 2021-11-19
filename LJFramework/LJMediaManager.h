//
//  LJMediaManager.h
//  LJFramework
//
//  Created by 崔志伟 on 2021/8/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJMediaManager : NSObject

+ (instancetype)manager;

- (void)takePhotoByViewController:(UIViewController *)viewController
                         isCamera:(BOOL)isCamera
                      cameraFront:(BOOL)isFront
                             corp:(BOOL)isCorp
                         complete:(void(^)(UIImage *image))complete;

- (BOOL)checkPhotoPermission;

@end

NS_ASSUME_NONNULL_END
