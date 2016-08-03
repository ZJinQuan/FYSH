//
//  LogViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/14.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "LogViewController.h"
#import "SetupViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

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
