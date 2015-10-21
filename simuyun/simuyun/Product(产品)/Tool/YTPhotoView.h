//
//  YTPhotoView.h
//  TestPhoto
//
//  Created by Luwinjay on 15/10/3.
//  Copyright © 2015年 Luwinjay. All rights reserved.
//
//  上传图片视图

#import <UIKit/UIKit.h>
#import "YTPhotoMenultem.h"

@class YTPhotoMenultem,JFImagePickerController;

@protocol PhotoViewDelegate <NSObject>

@optional

-(void)addPicker:(UIViewController *)picker;

@end

@interface YTPhotoView : UIView

@property (nonatomic, strong) NSMutableArray *photos;

@property(nonatomic,strong) NSMutableArray *itemArray;

@property (nonatomic, assign) id <PhotoViewDelegate> delegate;

@end
