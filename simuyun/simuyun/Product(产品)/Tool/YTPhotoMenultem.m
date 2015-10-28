//
//  YTPhotoMenultem.m
//  TestPhoto
//
//  Created by Luwinjay on 15/10/3.
//  Copyright © 2015年 Luwinjay. All rights reserved.
//

#import "YTPhotoMenultem.h"

@implementation YTPhotoMenultem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setContentImage:(UIImage *)contentImage{
    _contentImage = contentImage;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    
    imageView.image = contentImage;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    
    UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.frame = self.bounds;
//    [btnDelete setImage:[UIImage imageNamed:@"delete-circular.png"] forState:UIControlStateNormal];
    [btnDelete setBackgroundColor:[UIColor clearColor]];
    btnDelete.tag = self.index;
    [btnDelete addTarget:self
                  action:@selector(deletePhotoItem:)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDelete];
}
/*
 删除图片
 */
-(void)deletePhotoItem:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(photoItemView: didSelectDeleteButtonAtIndex: isCamera:)]){
        [self.delegate photoItemView:self didSelectDeleteButtonAtIndex:sender.tag isCamera:self.isCamera];
    }
}

@end
