//
//  UINavigationController+Origen.m
//  MDAlertViewTest
//
//  Created by demoker on 2017/3/29.
//  Copyright © 2017年 lb. All rights reserved.
//

#import "UINavigationController+Origen.h"

@implementation UINavigationController (Origen)
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
