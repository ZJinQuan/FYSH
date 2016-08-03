//
//  SignUpViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/14.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "SignUpViewController.h"
#import "HomeZoneViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController


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
    
    HomeZoneViewController *homeZ = [[HomeZoneViewController alloc] init];
    
    [self.navigationController pushViewController:homeZ animated:YES];
}


@end
