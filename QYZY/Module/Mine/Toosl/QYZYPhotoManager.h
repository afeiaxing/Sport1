//
//  QYZYPhotoManager.h
//  QYZY
//
//  Created by jspatches on 2022/10/2.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    PhotoCamera = 0,
    PhotoAlbum,
}SelectPhotoType;

@protocol QYZYPhotoDelegate <NSObject>
//照片选取成功
- (void)selectPhotoManagerDidFinishImage:(UIImage *)image;
//照片选取失败
- (void)selectPhotoManagerDidError:(NSError *)error;

@end

@interface QYZYPhotoManager : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

//代理对象
@property(nonatomic, weak)__weak id<QYZYPhotoDelegate>delegate;
//是否开启照片编辑功能
@property(nonatomic, assign)BOOL canEditPhoto;
//跳转的控制器 可选参数
@property(nonatomic, weak)__weak UIViewController *superVC;

//照片选取成功回调
@property(nonatomic, strong)void (^successHandle)(QYZYPhotoManager *manager, UIImage *image);
//照片选取失败回调
@property(nonatomic, strong)void (^errorHandle)(NSString *error);

//开始选取照片
- (void)startSelectPhotoWithImageName:(NSString *)imageName;
- (void)startSelectPhotoWithType:(SelectPhotoType )type andImageName:(NSString *)imageName;

@end
