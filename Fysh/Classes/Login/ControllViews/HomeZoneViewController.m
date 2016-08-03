//
//  HomeZoneViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/14.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "HomeZoneViewController.h"
#import "QuietViewController.h"

@interface HomeZoneViewController ()

@end

@implementation HomeZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.menuView.hidden = YES;
    
}

- (IBAction)ClickContinuneBtn:(id)sender {
    
    QuietViewController *queitVC = [[QuietViewController alloc] init];

    [self.navigationController pushViewController:queitVC animated:YES];
}


@end
