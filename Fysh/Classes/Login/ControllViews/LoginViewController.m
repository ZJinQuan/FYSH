//
//  LoginViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/14.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "LogViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _signUpBtn.layer.borderWidth = 1;
    _signUpBtn.layer.borderColor = RGBA(152, 288, 255, 1).CGColor;
    
}

- (IBAction)ClickLoginBtn:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1111:{
            
            SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
            
            [self.navigationController pushViewController:signUpVC animated:YES];
            
        }
            break;
        case 2222:{
            
            LogViewController *LogVC = [[LogViewController alloc] init];
            
            [self.navigationController pushViewController:LogVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

@end
