//
//  Profile3ViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/14.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "Profile3ViewController.h"
#import "SetupViewController.h"

@interface Profile3ViewController ()

@end

@implementation Profile3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.menuView.hidden = YES;
    
}

- (IBAction)ClickContinuneBtn:(id)sender {
    
    SetupViewController *setupVC = [[SetupViewController alloc] init];
    
    [self.navigationController pushViewController:setupVC animated:YES];
    
}

@end
