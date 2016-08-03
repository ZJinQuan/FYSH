//
//  ConnectViewController.m
//  Cushion
//
//  Created by QUAN on 16/6/30.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "ConnectViewController.h"
#import "BlueConnectViewController.h"
#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NameViewController.h"
#import "DashoardViewController.h"
#import "CircleView.h"
#import "HomeViewController.h"

#define channelOnPeropheralView @"peripheralView"

@interface ConnectViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray *peripherals;
    NSMutableArray *peripheralsAD;
    BabyBluetooth *baby;
    
    UIWebView *phoneCallWebView;
}
@property (weak, nonatomic) IBOutlet UITableView *connectView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activView;

@property (nonatomic, strong) AppDelegate *app;
@end

@implementation ConnectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _app = kAppDelegate;
    
    [self.navigationController setNavigationBarHidden:NO];
    
    //初始化其他数据 init other
    peripherals = [[NSMutableArray alloc]init];
    peripheralsAD = [[NSMutableArray alloc]init];
    
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    
    _connectView.dataSource = self;
    _connectView.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    //停止之前的连接
    //    [baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    baby.scanForPeripherals().begin();
    //baby.scanForPeripherals().begin().stop(10);
    
    AppDelegate *app = kAppDelegate;
    
    app.peripheral = nil;
    [app.characteristicsArr removeAllObjects];
    
    [_activView startAnimating];
    
    CircleView *circleV = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    circleV.backgroundColor = [UIColor whiteColor];
    
    circleV.centerX = kScreenWidth/ 2;
    circleV.y = CGRectGetMaxY(_titleLab.frame) + 20;
    
    [self.view addSubview:circleV];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [baby cancelScan];
    
}

-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            
        }
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        
        if ([peripheral.name isEqualToString:@"FYSH"]) {
            
            //停止扫描
            [weakSelf connectBlueTounch:peripheral];
            
            [weakSelf.app.connArr addObject:peripheral.identifier.UUIDString];

        }
        
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
        //找到cell并修改detaisText
        for (int i=0;i<peripherals.count;i++) {
            UITableViewCell *cell = [weakSelf.connectView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if ([cell.textLabel.text isEqualToString:peripheral.name]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu个service",(unsigned long)peripheral.services.count];
            }
        }
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        
        
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        
        
        
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    //    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
    //        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    //    }];
    
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        //最常用的场景是查找某一个前缀开头的设备
        //        if ([peripheralName hasPrefix:@"Pxxxx"] ) {
        //            return YES;
        //        }
        //        return NO;
        
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
        if (peripheralName.length >0) {
            return YES;
        }
        return NO;
    }];
    
    
    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    
    /*设置babyOptions
     
     参数分别使用在下面这几个地方，若不使用参数则传nil
     - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
     - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
     - [peripheral discoverServices:discoverWithServices];
     - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
     
     该方法支持channel版本:
     [baby setBabyOptionsAtChannel:<#(NSString *)#> scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
     */
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    
}

#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData{
    if(![peripherals containsObject:peripheral]) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        [peripherals addObject:peripheral];
        [peripheralsAD addObject:advertisementData];
        [self.connectView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark -table委托 table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return peripherals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.connectView dequeueReusableCellWithIdentifier:@"cell"];
    CBPeripheral *peripheral = [peripherals objectAtIndex:indexPath.row];
    NSDictionary *ad = [peripheralsAD objectAtIndex:indexPath.row];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
    NSString *localName;
    if ([ad objectForKey:@"kCBAdvDataLocalName"]) {
        localName = [NSString stringWithFormat:@"%@",[ad objectForKey:@"kCBAdvDataLocalName"]];
    }else{
        localName = peripheral.name;
    }
    
    cell.textLabel.text = localName;
    //信号和服务
    cell.detailTextLabel.text = @"读取中...";
    //找到cell并修改detaisText
    NSArray *serviceUUIDs = [ad objectForKey:@"kCBAdvDataServiceUUIDs"];
    if (serviceUUIDs) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu个service",(unsigned long)serviceUUIDs.count];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"0个service"];
    }
    
    //次线程读取RSSI和服务数量
    
    return cell;
}

-(void) connectBlueTounch:(CBPeripheral *)peripheral{
    
    [baby cancelScan];
    
    [peripherals addObject:peripheral];
    
    [self connectFish];
    
    if (peripheral) {
        
        baby.having(peripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
        
    }
    
    
}

-(void)connectFish{
    
    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        
        NSLog(@"%@",[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]);
        
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接失败",peripheral.name]];
    }];
    
    //设置设备断开连接的委托
    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        
        
        for (int i = 0; i < weakSelf.app.connArr.count; i++) {
            
            if ([weakSelf.app.connArr[i] isEqualToString:peripheral.identifier.UUIDString]) {
                
                [weakSelf.app.connArr removeObjectAtIndex:i];
            }
            
        }
        
        if ([weakSelf.app.disconnects isEqualToString:@"disconnects"]) {
            
            
            weakSelf.app.disconnects = @"";
            
        }else{
            
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--断开连接",peripheral.name]];
            
            if ([UIApplication sharedApplication].applicationState==UIApplicationStateBackground) {
                [[UIApplication sharedApplication] cancelAllLocalNotifications];
                
                UILocalNotification *alarm = [[UILocalNotification alloc] init];
                alarm.alertBody = [NSString stringWithFormat:@"Notify，FYSH has left。"];
                alarm.soundName = @"alarm.wav";
                alarm.alertAction = @"确定";
                [[UIApplication sharedApplication] presentLocalNotificationNow:alarm];
                
            }else{
                
                [weakSelf playsound:@"alarm.wav"];
                
            }
        }

         [[NSNotificationCenter defaultCenter] postNotificationName:@"DisconnectConnection" object:peripheral.identifier.UUIDString];
        
        AppDelegate *app = kAppDelegate;
        
        app.characteristics = nil;
        app.peripheral = nil;
        
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        
        
        for (CBService *s in peripheral.services) {
            
        }
        
        [rhythm beats];
    }];
    
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        
        if ([service.UUID.UUIDString isEqualToString:@"0000FEE9-0000-1000-8000-00805F9B34FB"]) {
            
            [weakSelf.app.peripheralArr addObject:peripheral];
            
        }
        
    }];
    
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        
        if ([characteristics.UUID.UUIDString isEqualToString:@"2A06"]) {
            
            //            [app.peripheralArr addObject:peripheral];
           
            
//            app.characteristics = characteristics;
        }
        
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        
        AppDelegate *app =kAppDelegate;
        
        
        
        if ([characteristic.UUID.UUIDString isEqualToString:@"2A06"] && characteristic.properties == CBCharacteristicPropertyWriteWithoutResponse) {
            
            
            [weakSelf.app.remindDict setObject:characteristic forKey:peripheral.identifier.UUIDString];
        }
        
        if ([characteristic.service.UUID.UUIDString isEqualToString:@"0000FEE9-0000-1000-8000-00805F9B34FB"]) {
            
            [app.characteristicsArr addObject:characteristic];
            
            app.peripheral = peripheral;

            if (app.characteristicsArr.count >= 8) {
                
                
            }
            
        }
        
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
        
        if ([descriptor.characteristic.UUID.UUIDString isEqualToString:@"D44BC439-ABFD-45A2-B575-925416129607"]) {
            
            AppDelegate *app =kAppDelegate;
            
            [weakSelf openNotification];
            
            for (int i = 0; i < app.FyshArray.count; i ++) {
                
                FyshModel *fyshM = app.FyshArray[i];
                
                if ([fyshM.fId isEqualToString:peripheral.identifier.UUIDString]) {
                    
                    if (app.FyshArray.count > 1) {
                        
                        HomeViewController *homeVC = [[HomeViewController alloc] init];
                        
                        homeVC.index = i;
                        homeVC->baby = baby;
                        
                        
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
                        
                        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                        
                    }else{
                        DashoardViewController *dashVC = [[DashoardViewController alloc] init];
                        
                        dashVC.index = i;
                        dashVC->baby = baby;
                        dashVC.isYes = YES;
                        
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dashVC];
                        
                        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                    }
                    
                }
                
            }
            
            NameViewController *nameVC = [[NameViewController alloc] init];
            
            
            nameVC.currPeripheral = peripheral;
            nameVC->baby = baby;
            
            [weakSelf.navigationController pushViewController:nameVC animated:YES];
            
            [weakSelf.activView stopAnimating];
            
        }
        
    }];
    
    //读取rssi的委托
    [baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
    }];
    
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
        //        if (<#condition#>) {
        //            [bry beatsOver];
        //        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updataService" object:nil];
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [baby setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    
}

#pragma mark 订阅通知
-(void) openNotification{
    
    for (int i = 0; i < _app.characteristicsArr.count; i++) {
        
        NSLog(@"%@---------------\n%@",_app.peripheral,  [_app.characteristicsArr objectAtIndex:i]);
        
        [baby notify:_app.peripheral
      characteristic:[_app.characteristicsArr objectAtIndex:i]
               block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                   
                   NSLog(@"notify block");
                   
                   NSLog(@"new value %@",characteristics.value);
                   
                   if (characteristics.value) {
                       
                       Byte *byte =  (Byte *)[characteristics.value bytes];
                       
                       if (byte[2] == 0xB0 && byte[3] == 0x01) { //移动命令
                           
                           for (int i = 0; i < _app.FyshArray.count; i++) {
                               
                               FyshModel *fyshM = _app.FyshArray[i];
                               
                               if ([fyshM.fId isEqualToString:peripheral.identifier.UUIDString]) {
                                   
                                   if ([fyshM.state isEqualToString:@"motion"]) {                                       
                                       
                                       AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                                       
                                   }
                                   
                                   break;
                               }
                               
                           }
                           
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"Counter" object:nil];
                           
                           int index = [[_app.counterDict valueForKey:peripheral.identifier.UUIDString] intValue];
                           
                           index++;
                           
                           [_app.counterDict setObject:[NSNumber numberWithInt:index] forKey:peripheral.identifier.UUIDString];
                           
                       }
                       
                       if (byte[2] == 0xB1) { //一键下单
                           
                           NSString *notName = @"SweepRQCode";
                           
                           if (_app.FyshArray.count == 1) {
                               notName = @"SweepRQCodeDash";
                           }
                           
                           [[NSNotificationCenter defaultCenter] postNotificationName:notName object:nil];
                       }
                       
                       if (byte[2] == 0xB2 && byte[3] == 0x01) { // 一键客服
                           [self CallPhone];
                       }
                   }
               }];
    }
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(void)CallPhone{
    
    NSString *phoneNum = @"110";// 电话号码
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    if (!phoneCallWebView) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

-(void) playsound:(NSString*)filename{
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
    
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //停止扫描
    [baby cancelScan];
    
    [self.connectView deselectRowAtIndexPath:indexPath animated:YES];
    BlueConnectViewController *vc = [[BlueConnectViewController alloc]init];
    vc.currPeripheral = [peripherals objectAtIndex:indexPath.row];
    vc->baby = self->baby;
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
