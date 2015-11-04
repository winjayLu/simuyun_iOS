//
//  YTPhotoView.m
//  TestPhoto
//
//  Created by Luwinjay on 15/10/3.
//  Copyright © 2015年 Luwinjay. All rights reserved.
//
//  上传图片视图

#import "YTPhotoView.h"
#import "YTPhotoMenultem.h"
#import "UIWindow+YUBottomPoper.h"
#import "JFImagePickerController.h"

#define MaxItemCount 6
#define ItemWidth 31
#define ItemHeight 31

@interface YTPhotoView() <UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoItemDelegate,JFImagePickerDelegate>
@property(nonatomic,weak) UIScrollView *photoScrollView;
@property (nonatomic, weak) UIScrollView *shareMenuScrollView;
@property(nonatomic,weak)UIButton *btnviewphoto;
@property (nonatomic, strong) JFImagePickerController *picker;
@property (nonatomic, strong) NSMutableArray *CameraPhotos;
@end


@implementation YTPhotoView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  初始化方法
 */
- (void)setup{
    
    
    // 初始化滚动视图
    UIScrollView *photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    photoScrollView.contentSize = CGSizeMake(600, 54);
    [self addSubview:photoScrollView];
    self.photoScrollView = photoScrollView;
    
    [self initlizerScrollView];
}


/**
 *  弹出下方菜单
 */
-(void)openMenu{
    [self.window  showPopWithButtonTitles:@[@"拍        摄",@"相册选取"] styles:@[YUDefaultStyle, YUDefaultStyle] whenButtonTouchUpInSideCallBack:^(int index  ) {
        switch (index) {
            case 0:
                // 拍摄
                [self takePhoto];
                break;
            case 1:
                // 相册选取
                [self localPhoto];
                break;
            default:
                break;
        }
    }];
}
/**
 *  打开相机
 */
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
//        // 设置拍照后的图片可被编辑
//        picker.allowsEditing = YES;
//        // 前置摄像头
//        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.sourceType = sourceType;
        [self.delegate addPicker:picker];
        
    }
}

/**
 *  拍照成功
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // 关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self.CameraPhotos addObject:image];

    [ASSETHELPER.selectdCameraPhoto addObject:@(self.CameraPhotos.count)];

    [self reloadDataImage];
    
}

/**
 *  将图片保存至相册
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{

}


/**
 *  打开相册
 */
-(void)localPhoto{
    
    JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    picker.pickerDelegate = self;
    [self.delegate addPicker:picker];
    self.picker = picker;
}

#pragma mark - JFImagePickerDelegate 相册的代理方法
/**
 *  成功选取照片
 */
- (void)imagePickerDidFinished:(JFImagePickerController *)picker
{
    [self.photos removeAllObjects];
    [self.photos addObjectsFromArray:picker.assets];
    [self reloadDataImage];
    [self imagePickerDidCancel:picker];
}
- (void)imagePickerDidCancel:(JFImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [JFImagePickerController clear];
}

-(void)reloadDataImage{

    [self initlizerScrollView];
}

-(void)initlizerScrollView{
    // 清空原有图片
    [self.photoScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemArray removeAllObjects];
    int i = 0;
    
    CGFloat maginTop = (self.height - ItemHeight) * 0.5;
    CGFloat maginleft = 10;
    // 相册中的照片
    for(;i< self.photos.count;i++){
        YTPhotoMenultem *photoItem = [[YTPhotoMenultem alloc]initWithFrame:CGRectMake(maginleft + i * (ItemWidth + maginleft ), maginTop , ItemWidth, ItemHeight)];
        photoItem.delegate = self;
        photoItem.index = i;
        ALAsset *asset = self.photos[i];
        [[JFImageManager sharedManager] thumbWithAsset:asset resultHandler:^(UIImage *result) {
            if (result != nil) {
                photoItem.contentImage = result;
            }
        }];
        [self.photoScrollView addSubview:photoItem];
        [self.itemArray addObject:photoItem];
    }
    // 相机中的照片
    for (int j = 0; j < self.CameraPhotos.count; j++) {
        YTPhotoMenultem *photoItem = [[YTPhotoMenultem alloc]initWithFrame:CGRectMake(maginleft + (i + j) * (ItemWidth + maginleft ), maginTop, ItemWidth, ItemHeight)];
        photoItem.isCamera = YES;
        photoItem.delegate = self;
        photoItem.index = i + j;
        photoItem.contentImage = self.CameraPhotos[j];
        [self.photoScrollView addSubview:photoItem];
        [self.itemArray addObject:photoItem];
    }
    
    if(self.photos.count + self.CameraPhotos.count < MaxItemCount){
        UIButton *btnphoto=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnphoto setFrame:CGRectMake(maginleft + (ItemWidth + maginleft) * (self.photos.count + self.CameraPhotos.count), maginTop, ItemWidth, ItemHeight)];
        [btnphoto setImage:[UIImage imageNamed:@"addImage.png"] forState:UIControlStateNormal];
        [btnphoto setImage:[UIImage imageNamed:@"addImage.png"] forState:UIControlStateSelected];
        //给添加按钮加点击事件
        [btnphoto addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
        [self.photoScrollView addSubview:btnphoto];
    }
    
    NSInteger count = MIN(self.photos.count +1 + self.CameraPhotos.count, MaxItemCount);
    [self.photoScrollView setContentSize:CGSizeMake(maginleft + (ItemWidth + maginleft)*count, 0)];
}




- (void)dealloc {
    self.shareMenuScrollView = nil;
    [JFImagePickerController clear];
}


#pragma mark - MessagePhotoItemDelegate

-(void)photoItemView:(YTPhotoMenultem *)messagePhotoItemView didSelectDeleteButtonAtIndex:(NSInteger)index isCamera:(BOOL)camera{
    if (camera) {
        [self.CameraPhotos removeObjectAtIndex:index - self.photos.count];
//        [ASSETHELPER.selectdCameraPhoto removeObjectAtIndex:index - self.photos.count];
    } else {
        [self.photos removeObjectAtIndex:index];
#warning 记录2各状态出错
//        [ASSETHELPER.selectdPhotos removeObjectAtIndex:index];
//        [ASSETHELPER.selectdAssets removeObjectAtIndex:index];
    }
    [self initlizerScrollView];
}

#pragma mark - lazy

- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (NSMutableArray *)itemArray
{
    if (!_itemArray) {
        _itemArray = [[NSMutableArray alloc] init];
    }
    return _itemArray;
}

- (NSMutableArray *)CameraPhotos
{
    if (!_CameraPhotos) {
        _CameraPhotos = [[NSMutableArray alloc] init];
    }
    return _CameraPhotos;
}

- (NSMutableArray *)totalPhotos
{
    if (!_totalPhotos) {
        _totalPhotos = [[NSMutableArray alloc] init];
    }
    return _totalPhotos;
}



@end
