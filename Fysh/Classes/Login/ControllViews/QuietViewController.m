//
//  QuietViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/14.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "QuietViewController.h"
#import "Profile1ViewController.h"

@interface QuietViewController ()

@end

@implementation QuietViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.menuView.hidden = YES;
    
}

- (IBAction)ClickContinuneBtn:(id)sender {
    
    Profile1ViewController *profileVC = [[Profile1ViewController alloc] init];
    
    [self.navigationController pushViewController:profileVC animated:YES];
}


@end
