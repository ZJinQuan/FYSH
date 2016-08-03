//
//  ProfileViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/22.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCell.h"

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *profileView;

@end

@implementation ProfileViewController

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    self.menuView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_profileView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"profileCell"];
}

#pragma mark  UITableViewDataSource and UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"profileCell";
    
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *titleArr = @[@"Username", @"E-mail", @"Password", @"Home Wifi", @"Quiet Hours", @"Birthday", @"Phone", @"Favorite Color"];
    
    NSArray *deleArr = @[@"EmilyA", @"abc@getfysh.com", @"***********", @"Not Set", @"MM/DD/YY", @"Not Set", @"Not Set",@"Not Set"];
    
    cell.titleLab.text = titleArr[indexPath.row];
    
    cell.delieLab.text = deleArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

@end
