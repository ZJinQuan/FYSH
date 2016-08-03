//
//  BaseViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/14.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "BaseViewController.h"
#import "HelpViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(UIView *)menuView{
    
    if (_menuView == nil) {
        
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 108, 65, 100, 40)];
        
        _menuView.backgroundColor = [UIColor whiteColor];
        
        _menuView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        _menuView.layer.shadowOffset = CGSizeMake(0, 0);
        _menuView.layer.shadowOpacity=0.5;
        _menuView.layer.shadowRadius = 3;
        
        UIButton *helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 92, 40)];
        helpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [helpBtn setTitle:@"Help" forState:UIControlStateNormal];
        [helpBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [helpBtn addTarget:self action:@selector(clickHelp) forControlEvents:UIControlEventTouchUpInside];
        helpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        
        [_menuView addSubview:helpBtn];
        
        _menuView.hidden = YES;
        
    }
    return _menuView;
}

-(void) clickHelp{
    
    HelpViewController *helpVC = [[HelpViewController alloc] init];
    
    
    [self.navigationController pushViewController:helpVC animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //返回图片
    UIImage *backButtonImage = [[UIImage imageNamed:@"Back_Chevron"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo2"]];
    imageV.layer.masksToBounds = YES;
    imageV.frame = CGRectMake(0, 0, 40, 35);
    
    self.navigationItem.titleView = imageV;
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"therespot"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtn:)];
    
    rightBtn.tintColor = RGBA(97, 97, 97, 1);
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
}

-(void) clickRightBtn:(UIBarButtonItem *) sender{
    
    if (self.menuView.hidden) {
        self.menuView.hidden = NO;
    }else{
        self.menuView.hidden = YES;
    }
    
    
    
}

/**
 *  退出键盘
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.menuView.hidden = YES;
    
    UITouch *touch = [touches anyObject];
    
    if (touch.tapCount >= 1) {
        
        [self.view endEditing:YES];
        
    }
}



@end
