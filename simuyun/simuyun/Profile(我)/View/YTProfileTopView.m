//
//  YTProfileTopView.m
//  测试头像上传
//
//  Created by Luwinjay on 15/10/4.
//  Copyright © 2015年 Luwinjay. All rights reserved.
//

#import "YTProfileTopView.h"
#import "UIWindow+YUBottomPoper.h"

@interface YTProfileTopView() <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

/**
 *  头像单击事件
 */
- (IBAction)iconClick:(UITapGestureRecognizer *)sender;


@end

@implementation YTProfileTopView



/**
 *  头像单击事件
 */
- (IBAction)iconClick:(UITapGestureRecognizer *)sender
{
    NSLog(@"sss");
    [self.window  showPopWithButtonTitles:@[@"拍        摄",@"相册选取"] styles:@[YUDefaultStyle, YUDefaultStyle] whenButtonTouchUpInSideCallBack:^(int index  ) {
        switch (index) {
            case 0:
                // 拍摄
                [self takePhoto:UIImagePickerControllerSourceTypeCamera];
                break;
            case 1:
                // 相册选取
                [self takePhoto:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                break;
            default:
                break;
        }
    }];
    
}


/**
 *  打开相册或相机
 */
- (void)takePhoto:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    // 设置拍照后的图片可被编辑
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    // 前置摄像头
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    // 调用代理方法
    [self.delegate addPicker:imagePicker];
}

/**
 *  拍照成功
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // 关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    // 设置图片到iconView上
    [self setIconImageWithImage:image];
}



/**
 *  给iconView设置图片
 */
- (void)setIconImageWithImage:(UIImage *)image
{
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius = self.iconImage.frame.size.width * 0.5;
    self.iconImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.iconImage.layer.shouldRasterize = YES;
    self.iconImage.clipsToBounds = YES;
    // 判断是否是更换图片
    if(image == nil) {
        self.iconImage.image = [UIImage imageNamed:@"avatar_default_big"];
        return;
    }
    
    self.iconImage.image = image;
//    [UIView animateWithDuration:2 animations:^{
//        self.iconImage.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:1.25 animations:^{
//            self.iconImage.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
//        }];
//    }];

}



+ (instancetype)profileTopView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTProfileTopView" owner:nil options:nil] firstObject];
}

@end
