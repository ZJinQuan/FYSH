//
//  Profile2ViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/14.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "Profile2ViewController.h"
#import "Profile3ViewController.h"

@interface Profile2ViewController ()

@end

@implementation Profile2ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.menuView.hidden = YES;
    
}

- (IBAction)ClickContinuneBtn:(id)sender {
    
    Profile3ViewController *profileVC = [[Profile3ViewController alloc] init];
    
    [self.navigationController pushViewController:profileVC animated:YES];

}


@end
