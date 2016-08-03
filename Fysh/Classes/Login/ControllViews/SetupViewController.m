//
//  SetupViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/17.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "SetupViewController.h"
#import "ConnectViewController.h"
#import "IconCell.h"

@interface SetupViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *setupView;

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_setupView registerNib:[UINib nibWithNibName:@"IconCell" bundle:nil] forCellReuseIdentifier:@"iconCell"];
}
- (IBAction)clickContinueBtn:(id)sender {
    
    ConnectViewController *connectVC = [[ConnectViewController alloc] init];
    
    [self.navigationController pushViewController:connectVC animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.menuView.hidden = YES;
    
}

#pragma mark  UITableViewDelegate and UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"iconCell";
    
    IconCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *textArr = [NSArray arrayWithObjects:@"Bluetooth", @"Location", @"Notifications", @"Battery Saving", nil];
    NSArray *detailArr = [NSArray arrayWithObjects:@"Requird to connect with your FYSH", @"Requird to find your FYSH", @"Keep track of your FYSH easily", @"Optional", nil];
    
    cell.titleLab.text = textArr[indexPath.row];
    cell.detailLab.text = detailArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置其accessoryType 为CheckMark
    IconCell *cell= (IconCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.selectBtn.selected = !cell.selectBtn.selected;
}

@end
