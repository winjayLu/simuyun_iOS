//
//  TZTestCell.m
//  TZImagePickerController
//
//  Created by 谭真 on 16/1/3.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "TZTestCell.h"

@interface TZTestCell()



@end

@implementation TZTestCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
        UIImageView *delete = [[UIImageView alloc] init];
        delete.image = [UIImage imageNamed:@"redeemPhotoDelete"];
        //        delete.hidden = YES;
        [self addSubview:delete];
        self.delete = delete;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    CGSize deleteSize = self.delete.image.size;;
    self.delete.frame = CGRectMake(self.width - deleteSize.width - 5, 5, deleteSize.width, deleteSize.height);
    
}


@end
