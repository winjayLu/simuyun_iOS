//
//  AddressChoicePickerView.h
//  Wujiang
//
//  Created by zhengzeqin on 15/5/27.
//  Copyright (c) 2015年 com.injoinow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTCustomPickerView;
typedef void (^AddressChoicePickerViewBlock)(YTCustomPickerView *view,UIButton *btn,NSString *selectType);
@interface YTCustomPickerView : UIView

@property (copy, nonatomic)AddressChoicePickerViewBlock block;
//证件类型数组
@property (strong, nonatomic) NSArray *types;


- (void)showWithSlectedType:(NSString *)type;
@end