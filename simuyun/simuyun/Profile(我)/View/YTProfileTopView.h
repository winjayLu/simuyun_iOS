//
//  YTProfileTopView.h
//  测试头像上传
//
//  Created by Luwinjay on 15/10/4.
//  Copyright © 2015年 Luwinjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iconPhotoDelegate <NSObject>

@optional

-(void)addPicker:(UIViewController *)picker;

@end

@interface YTProfileTopView : UIView

+ (instancetype)profileTopView;

@property (nonatomic, assign) id <iconPhotoDelegate> delegate;

- (void)setIconImageWithImage:(UIImage *)image;

@end
