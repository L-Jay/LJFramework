//
//  LJMediaManager.m
//  LJFramework
//
//  Created by 崔志伟 on 2021/8/16.
//

#import "LJMediaManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import <YYCategories/YYCategories.h>
#import "UIViewController+LJCategory.h"

@interface LJMediaManager ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) BOOL isCorp;

@property (nonatomic, assign) UIViewController *viewController;

@property (nonatomic, copy) void(^selectedImage)(UIImage *image);

@end

@implementation LJMediaManager

+ (instancetype)manager {
    static LJMediaManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LJMediaManager new];
    });
    
    return manager;
}

- (void)takePhotoByViewController:(UIViewController *)viewController
                         isCamera:(BOOL)isCamera
                      cameraFront:(BOOL)isFront
                             corp:(BOOL)isCorp
                         complete:(nonnull void (^)(UIImage * _Nonnull))complete {
    if (![self checkPhotoPermission])
        return;
    
    self.viewController = viewController;
    self.isCorp = isCorp;
    self.selectedImage = complete;
    
    if (isCamera) {
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.sourceType = UIImagePickerControllerSourceTypeCamera;
        vc.cameraDevice = isFront ? UIImagePickerControllerCameraDeviceFront : UIImagePickerControllerCameraDeviceRear;
        vc.mediaTypes = @[(NSString *)kUTTypeImage];
        vc.delegate = self;
        [viewController presentViewController:vc animated:YES completion:nil];
    }else {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowTakeVideo = NO;
        imagePickerVc.allowTakePicture = NO;
        imagePickerVc.allowCameraLocation = NO;
//        imagePickerVc.allowPreview = NO;
        imagePickerVc.showSelectBtn = NO;
        imagePickerVc.allowCrop = YES;
        imagePickerVc.needCircleCrop = YES;
        imagePickerVc.circleCropRadius = (kScreenWidth-40)*0.5;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray<PHAsset *> *assets, BOOL isSelectOriginalPhoto) {
            if (complete)
                complete(photos.firstObject);
        }];
        [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSDictionary *meta = [info objectForKey:UIImagePickerControllerMediaMetadata];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image meta:meta location:nil completion:^(PHAsset *asset, NSError *error){
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                if (self.isCorp) { // 允许裁剪,去裁剪
                    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset
                                                                                                            photo:image
                                                                                                       completion:^(UIImage *cropImage, PHAsset *asset) {
                        if (self.selectedImage)
                            self.selectedImage(cropImage);
                    }];
                    imagePicker.allowPickingImage = YES;
                    imagePicker.needCircleCrop = YES;
                    imagePicker.circleCropRadius = (kScreenWidth-40)*0.5;
                    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
                } else {
                    if (self.selectedImage)
                        self.selectedImage(image);
                }
            }
        }];
    } else if ([type isEqualToString:@"public.movie"]) {
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [[TZImageManager manager] saveVideoWithUrl:videoUrl location:nil completion:^(PHAsset *asset, NSError *error) {
                if (!error) {
                    TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                    [[TZImageManager manager] getPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                        if (!isDegraded && photo) {
//                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:photo];
                        }
                    }];
                }
            }];
        }
    }
}

#pragma mark - Permission

- (BOOL)checkPhotoPermission {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
        
        return NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self checkPhotoPermission];
                });
            }
        }];
        
        return NO;
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
        
        return NO;
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self checkPhotoPermission];
        }];
        
        return NO;
    }
    
    return YES;
}

- (UIViewController *)viewController {
    if (_viewController)
        return _viewController;
    
    _viewController = [UIApplication sharedApplication].keyWindow.rootViewController.currentPresentedController;
    
    return _viewController;
}

@end
