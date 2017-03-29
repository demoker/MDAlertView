//
//  MDAlertView.h
//  MDAlertViewTest
//
//  Created by demoker on 2017/3/27.
//  Copyright © 2017年 lb. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MDScreenWidth [UIScreen mainScreen].bounds.size.width
#define MDScreenHeight [UIScreen mainScreen].bounds.size.height

#define MDColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#define MDAlertViewWidth 280
#define MDAlertViewHeight 174
#define MDMargin 8
#define MDButtonHeight 44
#define MDAlertViewTitleLabelHeight 50
#define MDAlertViewTitleColor MDColor(65, 65, 65)
#define MDAlertViewTitleFont [UIFont boldSystemFontOfSize:20]
#define MDAlertViewContentColor MDColor(102, 102, 102)
#define MDAlertViewContentFont [UIFont systemFontOfSize:16]
#define MDAlertViewContentHeight (MDAlertViewHeight - MDAlertViewTitleLabelHeight - MDButtonHeight - MDMargin * 2)
#define MDiOS7OrLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

UIKIT_EXTERN NSString * const MDAlertViewWillShowNotification;
UIKIT_EXTERN NSString * const MDAlertViewDidShowNotification;
UIKIT_EXTERN NSString * const MDAlertViewDidDismissNotification;

typedef void(^clickHandle)(void);

typedef void(^clickHandleWithIndex)(NSInteger index);

typedef NS_ENUM(NSInteger, MDAlertViewButtonType) {
    MDAlertViewButtonTypeDefault = 0,
    MDAlertViewButtonTypeCancel,
    MDAlertViewButtonTypeWarning
};

@interface UIButton (MDBlock)
- (void)addActionHandler:(clickHandleWithIndex)touchHandler;

@end

@interface MDAlertViewSingle : NSObject

@end

@interface MDAlertViewController : UIViewController


@end

@interface MDAlertView : UIView
+ (void)md_alertViewShowOneButtonWithTitle:(NSString *)title message:(NSString *)message buttonType:(MDAlertViewButtonType)buttonType buttonTitle:(NSString *)buttonTitle click:(clickHandle)click;
@end
