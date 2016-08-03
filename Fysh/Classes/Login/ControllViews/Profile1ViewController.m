//
//  Profile1ViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/14.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "Profile1ViewController.h"
#import "Profile2ViewController.h"

@interface Profile1ViewController ()

@end

@implementation Profile1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.menuView.hidden = YES;
    
}

- (IBAction)ClickContinuneBtn:(id)sender {
    

    Profile2ViewController *profileVC = [[Profile2ViewController alloc] init];
    
    [self.navigationController pushViewController:profileVC animated:YES];
}


@end
