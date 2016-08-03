//
//  NameViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/17.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "NameViewController.h"
#import "MainViewController.h"

@interface NameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;

@end

@implementation NameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.menuView.hidden = YES;
    
}

- (IBAction)ClickContinuneBtn:(id)sender {
    
    if (_nameText.text.length < 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter a name" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }else{
        AppDelegate *app = kAppDelegate;
        
        app.fName = _nameText.text;
        
        MainViewController *MainVC = [[MainViewController alloc] init];
        
        MainVC.currPeripheral = _currPeripheral;
        MainVC->baby = baby;
        
        [self.navigationController pushViewController:MainVC animated:YES];
    }

}

@end
