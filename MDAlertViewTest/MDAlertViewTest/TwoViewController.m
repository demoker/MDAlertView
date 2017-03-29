//
//  TwoViewController.m
//  MDAlertViewTest
//
//  Created by demoker on 2017/3/28.
//  Copyright © 2017年 lb. All rights reserved.
//

#import "TwoViewController.h"
#import "MDAlertView.h"
@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [MDAlertView md_alertViewShowOneButtonWithTitle:@"提示two00" message:@"这是一个测试的测试" buttonType:MDAlertViewButtonTypeDefault buttonTitle:@"好的" click:^{
//        NSLog(@"点击‘好的’，提示框消失");
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor orangeColor];
    //在这里调用会有问题，但是在viewDidAppear：中调用不存在问题
    [MDAlertView md_alertViewShowOneButtonWithTitle:@"提示two00" message:@"这是一个测试的测试" buttonType:MDAlertViewButtonTypeDefault buttonTitle:@"好的" click:^{
        NSLog(@"点击‘好的’，提示框消失");
    }];
}
- (IBAction)back:(id)sender {
    if(self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",self.view);
    NSLog(@"当前屏幕方向：%ld", (long)[UIApplication sharedApplication].statusBarOrientation);
    
    [MDAlertView md_alertViewShowOneButtonWithTitle:@"提示two" message:@"这是一个测试的测试" buttonType:MDAlertViewButtonTypeDefault buttonTitle:@"好的" click:^{
        NSLog(@"点击‘好的’，提示框消失");
    }];
}


//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
