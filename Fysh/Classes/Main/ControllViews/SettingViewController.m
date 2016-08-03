//
//  SettingViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/15.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "SettingViewController.h"
#import "DashoardViewController.h"
#import "IconCell.h"
#import "FMDBManage.h"
#import "HomeViewController.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *settingView;

@property (nonatomic, strong) AppDelegate *app;

@property (nonatomic, strong) NSMutableArray *setarr;
@end

@implementation SettingViewController

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.menuView.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _app = kAppDelegate;
    
    _setarr = [[NSMutableArray alloc] init];
    
    if (_fyshM) {
        [_setarr addObject:_fyshM.ringer];
        [_setarr addObject:_fyshM.oneclick];
        
    }else{
        [_setarr addObject:@"NO"];
        [_setarr addObject:@"NO"];
    }
    
    
    
    NSLog(@"%@",self.image);

    [_settingView registerNib:[UINib nibWithNibName:@"IconCell" bundle:nil] forCellReuseIdentifier:@"iconCell"];
    
    [_settingView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"settingCell"];
    
    
}
- (IBAction)clickDone:(id)sender {
    
    if ([_setting isEqualToString:@"dashoard"]) {
        
        [self clickUpdata];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [self clickInsert];
        
        if (_app.FyshArray.count > 1) {
            
            HomeViewController *homeVC = [[HomeViewController alloc] init];
            
            //        homeVC.index = i;
            homeVC->baby = baby;
            //        homeVC.isYes = YES;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            
        }else{
            
            DashoardViewController *dashVC = [[DashoardViewController alloc] init];
            
            dashVC.image = self.image;
            dashVC.isYes = YES;
            dashVC->baby = baby;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dashVC];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            
        }
        
    }

}

-(void) clickInsert{
    
    FyshModel *fyshM = [[FyshModel alloc] init];
    
    fyshM.fId = _app.peripheral.identifier.UUIDString;
    fyshM.fName = _app.fName;
    
    if (_app.imageFile) {
        
        fyshM.imgPath = _app.imageFile;
        
    }else{
        fyshM.imageName = _app.imageName;
    }
    
    fyshM.state = _state;
    fyshM.ringer = _setarr[0];
    fyshM.oneclick = _setarr[1];
    
    [[FMDBManage shareIntance] insertFYSH:fyshM];
    
    _app.FyshArray = [[NSMutableArray alloc] initWithArray:[[FMDBManage shareIntance] allFYSH]];
    
    Byte bytes[4];
    for (int i = 0; i < 4; i++) {
        bytes[i] = 0x00;
    }
    
    if ([_state isEqualToString:@"location"]) {
        
    }else if ([_state isEqualToString:@"reminder"]){
        
        bytes[0] = 0xAA;
        bytes[1] = 0x01;
        bytes[2] = 0xC0;
        bytes[3] = 0x1;
        
    }else if ([_state isEqualToString:@"motion"]){
        
        bytes[0] = 0xAA;
        bytes[1] = 0x01;
        bytes[2] = 0xC0;
        bytes[3] = 0x1;
        
    }else if ([_state isEqualToString:@"kidtoken"]){
        
    }
    
    NSData *data=[NSData dataWithBytes:&bytes length:sizeof(bytes)];
    
    for (int i = 0; i < _app.peripheralArr.count; i++) {
        
        CBPeripheral *peripheral = _app.peripheralArr[i];
        
        if ([peripheral.identifier.UUIDString isEqualToString:fyshM.fId]) {
            
            [peripheral writeValue:data forCharacteristic:_app.characteristicsArr[0] type:CBCharacteristicWriteWithoutResponse];
            
            [_app.counterDict setObject:[NSNumber numberWithInt:0] forKey:peripheral.identifier.UUIDString];
            
            break;
        }
    }
}

-(void) clickUpdata{
    
    _fyshM.ringer = _setarr[0];
    _fyshM.oneclick = _setarr[1];
    
    [[FMDBManage shareIntance] updateFYSH:_fyshM];
    
    _app.FyshArray = [[NSMutableArray alloc] initWithArray:[[FMDBManage shareIntance] allFYSH]];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
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
    
    switch (_index) {
        case 0:{
            return 2;
        }
            break;
        case 1:{
            return 4;
        }
            break;
        case 2:{
            return 4;
        }
            break;
        case 3:{
            return 2;
        }
            break;
            
        default:
            break;
    }
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"iconCell";
    
    IconCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *textArr = [NSArray array];
    NSArray *detailArr = [NSArray array];
    
    switch (_index) {
        case 0:{
            textArr = @[@"Ringer", @"One-click"];
            detailArr = @[@"Helps you Locate your item", @"Enables reorderor Customer Service"];
        }
            break;
        case 1:{
            textArr = @[@"Ringer", @"Mition counter", @"Motion alert", @"One-click"];
            detailArr = @[@"Helps you locate your item", @"Counts if you item has moved", @"Alerts you if your item has moved", @"Enables reorder or Customer Service"];
        }
            break;
        case 2:{
            textArr = @[@"Ringer", @"Mition counter", @"Motion alert", @"One-click"];
            detailArr = @[@"Helps you locate your item", @"Counts if you item has moved", @"Alerts you if your item has moved", @"Enables reorder or Customer Service"];
        }
            break;
        case 3:{
            textArr = @[@"Ringer", @"One-click"];
            detailArr = @[@"Helps you Locate your item", @"Enables reorderor Customer Service"];
        }
            break;
            
        default:
            break;
    }
    
    
    if ([_setting isEqualToString:@"dashoard"]) {
        
        if ([_fyshM.ringer isEqualToString:@"YES"] && indexPath.row == 0) {
            cell.selectBtn.selected = YES;
        }
        
        if ([_fyshM.oneclick isEqualToString:@"YES"] && indexPath.row == 1) {
            cell.selectBtn.selected = YES;
        }
        
    }
    
    
    cell.titleLab.text = textArr[indexPath.row];
    cell.detailLab.text = detailArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置其accessoryType 为CheckMark
    IconCell *cell= (IconCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.selectBtn.selected = !cell.selectBtn.selected;
    
    if (cell.selectBtn.selected) {
        
        _setarr[indexPath.row] = @"YES";
        
    }else{
        _setarr[indexPath.row] = @"NO";
    }
    

}


@end
