//
//  YTPhotoMenultem.h
//  TestPhoto
//
//  Created by Luwinjay on 15/10/3.
//  Copyright © 2015年 Luwinjay. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YTPhotoMenultem;
@protocol PhotoItemDelegate <NSObject>

- (void)photoItemView:(YTPhotoMenultem *)photoItemView didSelectDeleteButtonAtIndex:(NSInteger)index isCamera:(BOOL)camera;

@end

@interface YTPhotoMenultem : UIView

@property(nonatomic,weak)id<PhotoItemDelegate> delegate;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong) UIImage *contentImage;
@property (nonatomic, assign) BOOL isCamera;

@end