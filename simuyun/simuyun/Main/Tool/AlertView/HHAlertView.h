//
//  MrLoadingView.h
//  MrLoadingView
//
//  Created by ChenHao on 2/11/15.
//  Copyright (c) 2015 xxTeam. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  button index
 */
typedef NS_ENUM(NSInteger, HHAlertButton){
    HHAlertButtonOk,
    HHAlertButtonCancel
};
/*
 *the style of the logo
 */
typedef NS_ENUM(NSInteger, HHAlertStyle){
//    HHAlertStyleDefault,
    HHAlertStyleJpush

};

typedef NS_ENUM(NSInteger, HHAlertEnterStyle){
    HHAlertEnterStyleCenter,
};

/**
 *  the block to tell user whitch button is clicked
 *
 *  @param button button
 */
typedef void (^selectButton)(HHAlertButton buttonindex);




@interface HHAlertView : UIView

/**
 *  the singleton of the calss
 *
 *  @return the singleton
 */
+ (instancetype)shared;

/**
 *  dismiss the alertview
 */
- (void)hide;



/**
 *  show the alertview and use Block to know which button is clicked
 *
 *  @param HHAlertStyle style
 *  @param view         view
 *  @param title        title
 *  @param detail       etail
 *  @param cancel       cancelButtonTitle
 *  @param ok           okButtonTitle
 */
- (void)showAlertWithStyle:(HHAlertStyle)HHAlertStyle
                 imageName:(NSString *)imagename
                     Title:(NSString *)title
                    detail:(NSString *)detail
              cancelButton:(NSString *)cancel
                  Okbutton:(NSString *)ok
                     block:(selectButton)block;



@end
