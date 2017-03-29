//
//  MDAlertView.m
//  MDAlertViewTest
//
//  Created by demoker on 2017/3/27.
//  Copyright © 2017年 lb. All rights reserved.
//

#import "MDAlertView.h"
#import "Masonry.h"
#import <objc/runtime.h>
NSString *const MDAlertViewWillShowNotification = @"MDAlertViewWillShowNotification";
NSString *const MDAlertViewDidShowNotification = @"MDAlertViewDidShowNotification";
NSString *const MDAlertViewWillDismissNotification = @"MDAlertViewWillDismissNotification";
NSString *const MDAlertViewDidDismissNotification = @"MDAlertViewDidDismissNotification";


static const void *UIButtonBlockKey = &UIButtonBlockKey;

@implementation UIButton (MDBlock)

-(void)addActionHandler:(clickHandleWithIndex)touchHandler{
    objc_setAssociatedObject(self, UIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(actionTouched:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)actionTouched:(UIButton *)btn{
    clickHandleWithIndex block = objc_getAssociatedObject(self, UIButtonBlockKey);
    if (block) {
        block(btn.tag);
    }
}
@end


@interface MDAlertViewSingle()
@property (strong, nonatomic) UIWindow * backgroundWindow;
@property (strong, nonatomic) NSMutableArray * alertStack;
@property (weak, nonatomic) UIWindow * oldKeyWindow;
@end

@implementation MDAlertViewSingle

+ (instancetype)shareSingle{
    static MDAlertViewSingle * single = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        single = [[MDAlertViewSingle alloc]init];
    });
    return single;
}

- (UIWindow *)backgroundWindow{
    if(!_backgroundWindow){
        _backgroundWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundWindow.windowLevel = UIWindowLevelStatusBar - 1;
        _backgroundWindow.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    }
    return _backgroundWindow;
}

- (NSMutableArray *)alertStack{
    if(!_alertStack){
        _alertStack = [[NSMutableArray alloc]init];
    }
    return _alertStack;
}

@end


@interface MDAlertView ()
@property (strong, nonatomic) NSString * md_title;
@property (strong, nonatomic) NSString * md_message;
@property (copy, nonatomic) NSArray * buttons;
@property (weak, nonatomic) MDAlertViewController * md_vc;

- (void)setup;
@end


@interface MDAlertViewController ()
@property (weak, nonatomic) MDAlertView * md_alertView;
@end

@implementation MDAlertViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.md_alertView];
    [self.md_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(180);
    }];
}


- (void)showAlert{
    [[NSNotificationCenter defaultCenter] postNotificationName:MDAlertViewWillShowNotification object:self];
    
    CGFloat duration = 0.3;
    
    for (UIButton *btn in self.md_alertView.subviews) {
        btn.userInteractionEnabled = NO;
    }
    
    self.md_alertView.alpha = 0;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.md_alertView.alpha = 1.0;
        [self.md_alertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.mas_equalTo(250);
            make.height.mas_equalTo(190);
        }];
    } completion:^(BOOL finished) {
        for (UIButton *btn in self.md_alertView.subviews) {
            btn.userInteractionEnabled = YES;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MDAlertViewDidShowNotification object:self.md_alertView];
    }];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.8), @(1.05), @(1.1), @(1)];
    animation.keyTimes = @[@(0), @(0.3), @(0.5), @(1.0)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = duration;
    [self.md_alertView.layer addAnimation:animation forKey:@"bouce"];
    
}

- (void)hideAlertWithCompletion:(void(^)(void))completion{
    [[NSNotificationCenter defaultCenter] postNotificationName:MDAlertViewDidDismissNotification object:self];
    
    CGFloat duration = 0.2;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.md_alertView.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MDAlertViewDidDismissNotification object:self];
    }];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.md_alertView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    } completion:^(BOOL finished) {
        self.md_alertView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}


#pragma mark - 设备方向

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return [[self currentViewController] preferredInterfaceOrientationForPresentation];//UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return [[self currentViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[self currentViewController]supportedInterfaceOrientations];//UIInterfaceOrientationMaskPortrait;
}

- (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [[MDAlertViewSingle shareSingle] oldKeyWindow].rootViewController;
    if([vc isKindOfClass:[self class]]){
        return nil;
    }
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
            break;
        }else{
            break;
        }
        
    }
    return vc;
}

@end

@implementation MDAlertView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        
    }
    return self;
}

- (instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor whiteColor];
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = MDAlertViewTitleFont;
    titleLabel.textColor = MDAlertViewTitleColor;
    [self addSubview:titleLabel];
    
    UILabel * contentLabel = [[UILabel alloc]init];
    contentLabel.font = MDAlertViewContentFont;
    contentLabel.textColor = MDAlertViewContentColor;
    [self addSubview:contentLabel];
    
    UIView * buttonContainer = [UIView new];
    [self addSubview:buttonContainer];
    
    int i = 0;
    for(NSDictionary * buttonConfigDic in self.buttons){
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setButton:button BackgroundWithButonType:[buttonConfigDic[@"type"] intValue]];
        [button setTitle:buttonConfigDic[@"title"] forState:UIControlStateNormal];
        //点击事件，待定
        [button addActionHandler:^(NSInteger index) {
            [self dismissWithCompletion:buttonConfigDic[@"click"]];
        }];
        [buttonContainer addSubview:button];
        i++;
    }
    
    //text set value
    titleLabel.text = self.md_title;
    contentLabel.text = self.md_message;
    //layout
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(MDMargin);
        make.left.equalTo(self.mas_left).with.offset(MDMargin);
        make.right.equalTo(self.mas_right).with.offset(-MDMargin);
        make.height.mas_equalTo(MDAlertViewTitleLabelHeight);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(MDMargin);
        make.left.equalTo(self.mas_left).with.offset(MDMargin);
        make.right.equalTo(self.mas_right).with.offset(-MDMargin);
        make.height.mas_equalTo(MDAlertViewContentHeight);
    }];

    [buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).with.offset(MDMargin);
        make.left.equalTo(self.mas_left).with.offset(MDMargin);
        make.right.equalTo(self.mas_right).with.offset(-MDMargin);
        make.height.mas_equalTo(MDButtonHeight);
    }];
    
    if(buttonContainer.subviews.count >1){
        [buttonContainer.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:MDMargin leadSpacing:0 tailSpacing:0];
    }else{
        UIView * view = [buttonContainer.subviews lastObject];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(buttonContainer);
        }];
    }
    
}

- (void)configAlertViewPropertyWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons{
    self.md_title = title;
    self.md_message = message;
    self.buttons = buttons;
    
    MDAlertViewController * alertController = [[MDAlertViewController alloc]init];
    self.md_vc = alertController;
    alertController.md_alertView = self;
    
    [self show];
}

#pragma mark - public
+ (void)md_alertViewShowOneButtonWithTitle:(NSString *)title message:(NSString *)message buttonType:(MDAlertViewButtonType)buttonType buttonTitle:(NSString *)buttonTitle click :(clickHandle)click{
    MDAlertView * alertView = [[MDAlertView alloc]init];
    [alertView configAlertViewPropertyWithTitle:title message:message buttons:@[@{@"title":buttonTitle,@"type":@(buttonType),@"click":click}]];
}

- (void)show{
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    if (keywindow != [MDAlertViewSingle shareSingle].backgroundWindow) {
        [MDAlertViewSingle shareSingle].oldKeyWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    /** 注意以下三行代码的顺序，设置window frame 要在setRootController之后，参考链接:http://itangqi.me/2017/03/09/handle-orientation-changes-two/ ,因为setRoot之后获取的UIScreen的bounds是旋转之后的*/
    [[MDAlertViewSingle shareSingle].backgroundWindow makeKeyAndVisible];
    [MDAlertViewSingle shareSingle].backgroundWindow.rootViewController = self.md_vc;
    [MDAlertViewSingle shareSingle].backgroundWindow.frame = [UIScreen mainScreen].bounds;
//    [keywindow addSubview:self.md_vc.view];
    [self setup];
    
    [self.md_vc showAlert];
}


- (void)dismissWithCompletion:(void(^)(void))block{
    
    [MDAlertViewSingle shareSingle].backgroundWindow.frame = CGRectZero;
    [MDAlertViewSingle shareSingle].backgroundWindow.rootViewController = nil;
    [MDAlertViewSingle shareSingle].backgroundWindow = nil;
    
    [[MDAlertViewSingle shareSingle].oldKeyWindow makeKeyAndVisible];
    
//    UIInterfaceOrientation orien = [[UIApplication sharedApplication] statusBarOrientation];
//    if(orien == UIInterfaceOrientationPortrait){
//        
//    }else{
//       
//    }

    
    [self.md_vc hideAlertWithCompletion:^{
        block();
    }];
}

- (void)setButton:(UIButton *)btn BackgroundWithButonType:(MDAlertViewButtonType)buttonType{
    UIColor *textColor = nil;
    UIImage *normalImage = nil;
    UIImage *highImage = nil;
    switch (buttonType) {
        case MDAlertViewButtonTypeDefault:
            normalImage = [UIImage imageNamed:@"default_nor"];
            highImage = [UIImage imageNamed:@"default_high"];
            textColor = MDColor(255, 255, 255);
            break;
        case MDAlertViewButtonTypeCancel:
            normalImage = [UIImage imageNamed:@"cancel_nor"];
            highImage = [UIImage imageNamed:@"cancel_high"];
            textColor = MDColor(255, 255, 255);
            break;
        case MDAlertViewButtonTypeWarning:
            normalImage = [UIImage imageNamed:@"warn_nor"];
            highImage = [UIImage imageNamed:@"warn_high"];
            textColor = MDColor(255, 255, 255);
            break;
    }
    [btn setBackgroundImage:[self resizeImage:normalImage] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self resizeImage:highImage] forState:UIControlStateHighlighted];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
}

- (UIImage *)resizeImage:(UIImage *)image{
    return [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
}

@end
