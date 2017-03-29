//
//  ViewController.m
//  MDAlertViewTest
//
//  Created by demoker on 2017/3/27.
//  Copyright © 2017年 lb. All rights reserved.
//

#import "ViewController.h"
#import "MDAlertView.h"
#import "TwoViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor yellowColor];
    
    [MDAlertView md_alertViewShowOneButtonWithTitle:@"提示00" message:@"这是一个测试的测试" buttonType:MDAlertViewButtonTypeDefault buttonTitle:@"好的" click:^{
        NSLog(@"点击‘好的’，提示框消失");
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",self.view);
    NSLog(@"当前屏幕方向：%ld", (long)[UIApplication sharedApplication].statusBarOrientation);
    
    [MDAlertView md_alertViewShowOneButtonWithTitle:@"提示" message:@"这是一个测试的测试" buttonType:MDAlertViewButtonTypeDefault buttonTitle:@"好的" click:^{
        NSLog(@"点击‘好的’，提示框消失");
    }];
}
- (IBAction)present:(id)sender {
    TwoViewController * two = [[TwoViewController alloc]init];
    [self presentViewController:two animated:YES completion:nil];
}
- (IBAction)push:(id)sender {
    TwoViewController * two = [[TwoViewController alloc]init];
    [self.navigationController pushViewController:two animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
