//
//  DashoardViewController.m
//  Fysh
//
//  Created by QUAN on 16/7/15.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "DashoardViewController.h"
#import "ConnectViewController.h"
#import "FyshModel.h"
#import "FMDBManage.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "SettingViewController.h"
#import "HelpViewController.h"
#import "ALActionSheetView.h"
#import "QRCodeReaderViewController.h"

@interface DashoardViewController ()<UIActionSheetDelegate, QRCodeReaderDelegate>

@property (nonatomic, strong) AppDelegate *app;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UIView *dashView;
@property (weak, nonatomic) IBOutlet UILabel *indexLab;

@property (nonatomic, assign) int indexL;

@property (nonatomic, strong) FyshModel *fyshM;

@property (nonatomic, assign) NSInteger *notf;
@end

@implementation DashoardViewController

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    self.menuView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    _app = kAppDelegate;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    
    label.text = @"Dashboard";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor darkGrayColor];
    self.navigationItem.titleView = label;
    
    
//    _titileImg.image = _image;
    
    _titileImg.layer.cornerRadius = 150 /2;
    _titileImg.layer.masksToBounds = YES;
    _dashView.layer.cornerRadius = 250 / 2;
    
    
    self.fyshM = _app.FyshArray[_index];
    
    _nameLab.text = _fyshM.fName;
    
    if (![_fyshM.imgPath  isEqualToString: @"(null)"]) {
        _titileImg.image = [UIImage imageWithContentsOfFile:_fyshM.imgPath];
    }else{
        _titileImg.image = [UIImage imageNamed:_fyshM.imageName];
    }
    
    
    
    if ([_fyshM.state isEqualToString:@"location"] || [_fyshM.state isEqualToString:@"kidtoken"]) {
        _indexLab.hidden = YES;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendNotify:)];
 
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [_titileImg addGestureRecognizer:tapGesture];
    
    [self setUpMenuView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DisconnectConnection:) name:@"DisconnectConnection" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(counter) name:@"Counter" object:nil];
    
    if (_isYes) {
        self.dashView.backgroundColor = RGBA(151, 228, 255, 1);
        self.indexLab.backgroundColor = RGBA(151, 228, 255, 1);
    }
    
    _notf = 0;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SweepRQCodeDash:) name:@"SweepRQCodeDash" object:nil];
}

-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    _indexLab.text = [NSString stringWithFormat:@"%d",[_app.counterDict[_fyshM.fId] intValue]];
    
}

-(void) SweepRQCodeDash:(NSNotification *) notf{
    
    QRCodeReaderViewController *QRcodeVC = [[QRCodeReaderViewController alloc] init];
    
    QRcodeVC.title = @"QR Code";
    
    QRcodeVC.modalPresentationStyle = UIModalPresentationFormSheet;
    QRcodeVC.delegate = self;
    
    __weak typeof (self) wSelf = self;
    [QRcodeVC setCompletionWithBlock:^(NSString *resultAsString) {
        [wSelf.navigationController popViewControllerAnimated:YES];
        [[[UIAlertView alloc] initWithTitle:@"" message:resultAsString delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
    }];
    
    [self.navigationController pushViewController:QRcodeVC animated:YES];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result{
    
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) counter{
    
    _indexLab.text = [NSString stringWithFormat:@"%d",[_app.counterDict[_fyshM.fId] intValue]];
    
}

-(void) DisconnectConnection:(NSNotification *)notf{
    
    if ([_fyshM.fId isEqualToString:notf.object]) {
        self.dashView.backgroundColor = [UIColor lightGrayColor];
        self.indexLab.backgroundColor = [UIColor lightGrayColor];
    }
}

-(void) setUpMenuView{
    
    self.menuView.height = 200;

    NSArray *arr = @[@"Profile", @"Settings", @"Help", @"Deactivate", @"Delete"];
    
    for (int i = 0; i < 5; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * 40, 92, 40)];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        if (i == 4) {
            
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(clickMenuV:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.menuView addSubview:btn];
    }
}

-(void) clickMenuV:(UIButton *)sender{
    
    switch (sender.tag) {
        case 0:{
            
            ProfileViewController *profileVC = [[ProfileViewController alloc] init];
            
            [self.navigationController pushViewController:profileVC animated:YES];
        }
            break;
        case 1:{
            SettingViewController *settingVC=[[SettingViewController alloc]init];
            
            settingVC.setting = @"dashoard";
            
            settingVC.fyshM = _fyshM;
            
            [self.navigationController pushViewController:settingVC animated:YES];
            
        }
            break;
        case 2:{
            HelpViewController *helpVC=[[HelpViewController alloc]init];
            
            
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 3:{ //Deactive
            
            [self deActive:nil];
            
        }
            break;
        case 4:{ //Delete
            
            [self deleteFysh];
        }
            break;
            
        default:
            break;
    }
    
    
    self.menuView.hidden = YES;
}

-(void)deleteFysh{
    
    ALActionSheetView *actionSheet = [ALActionSheetView showActionSheetWithTitle:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete"otherButtonTitles:nil handler:^(ALActionSheetView *actionSheetView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSLog(@"删除");
            FyshModel *model;
            model=_app.FyshArray[_index];
            [[FMDBManage shareIntance] deleteFYSH:model.fIndex];
            
            _app.disconnects = @"disconnects";
            
            _app.FyshArray=[[NSMutableArray alloc] initWithArray:[[FMDBManage shareIntance] allFYSH]];
            [self.navigationController popViewControllerAnimated:true];
            
            for (int i = 0; i < _app.peripheralArr.count; i++) {
                
                CBPeripheral *perip = _app.peripheralArr[i];
                
                if ([_fyshM.fId isEqualToString:perip.identifier.UUIDString]) {
                    
                    [baby cancelPeripheralConnection:perip];
                    
                    break;
                }
            }
        }
    }];
    [actionSheet show];
}



-(void)sendNotify:(id)sender{
    
    
    if ([_fyshM.oneclick isEqualToString:@"NO"]) {
        return;
    }
    
    Byte bytes[1];
    
    if (_notf == 0) {

        bytes[0]=0x02;

        _notf++;
    }else{
        
        bytes[0]=0x00;
        
        _notf = 0;
    }
    
    NSData *data=[NSData dataWithBytes:&bytes length:sizeof(bytes)];
    
    for (int i = 0; i < _app.peripheralArr.count; i++) {
        
        CBPeripheral *perip = _app.peripheralArr[i];
        
        if ([_fyshM.fId isEqualToString:perip.identifier.UUIDString]) {
            //<CBCharacteristic: 0x15e52dc0, UUID = 2A06, properties = 0x4, value = (null), notifying = NO>
            //<CBCharacteristic: 0x156653b0, UUID = 2A06, properties = 0x4, value = (null), notifying = NO>
            
            [perip writeValue:data forCharacteristic:[_app.remindDict objectForKey:perip.identifier.UUIDString] type:CBCharacteristicWriteWithoutResponse];
            
            break;
        }
        
    }
}

-(void)deActive:(id)sender{
    
    Byte bytes[4];
    
    bytes[0] = 0xAA;
    bytes[1] = 0x01;
    bytes[2] = 0xC0;
    bytes[3] = 0x8;
    
    NSData *data=[NSData dataWithBytes:&bytes length:sizeof(bytes)];
    
    for (int i = 0; i < _app.peripheralArr.count; i++) {
        
        CBPeripheral *peripheral = _app.peripheralArr[i];
        
        if ([peripheral.identifier.UUIDString isEqualToString:_fyshM.fId]) {
            
            [peripheral writeValue:data forCharacteristic:_app.characteristicsArr[0] type:CBCharacteristicWriteWithoutResponse];
            
            _app.disconnects = @"disconnects";
            
            break;
        }
    }
}

-(void) clickInsert{
    
    FyshModel *fyshM = [[FyshModel alloc] init];
    
    fyshM.fId = _app.peripheral.identifier.UUIDString;
    fyshM.fName = _app.fName;
    fyshM.imageName = _app.imageName;
    
    [[FMDBManage shareIntance] insertFYSH:fyshM];
    
    _app.FyshArray = [[NSMutableArray alloc] initWithArray:[[FMDBManage shareIntance] allFYSH]];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.menuView.hidden = YES;
    
    UITouch *touch = [touches anyObject];
    
    if (touch.tapCount >= 5) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"睡眠", @"home Zone", @"time Zone",@"G-sensor", nil];
        sheet.tag = 1001;
        [sheet showInView:self.view];
        
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    Byte bytes[4];
    for (int i = 0; i < 4; i++) {
        bytes[i] = 0x00;
    }
    
    bytes[0] = 0xAA;
    bytes[1] = 0x01;
    bytes[2] = 0xC0;
    
    
    switch (buttonIndex) {
        case 0:{

            bytes[3] = 0x8;
        }
            
            break;
        case 1:{
            bytes[3] = 0x4;
        }
            
            break;
        case 2:{
            bytes[3] = 0x2;
        }
            
            break;
        case 3:{
            bytes[3] = 0x1;
        }
            
            break;
            
        default:
            break;
    }

    NSData *data=[NSData dataWithBytes:&bytes length:sizeof(bytes)];
    
    for (int i = 0; i < _app.peripheralArr.count; i++) {
        
        CBPeripheral *peripheral = _app.peripheralArr[i];
        
        if ([peripheral.identifier.UUIDString isEqualToString:_fyshM.fId]) {
            
            [peripheral writeValue:data forCharacteristic:_app.characteristicsArr[0] type:CBCharacteristicWriteWithoutResponse];

            [_app.counterDict setObject:[NSNumber numberWithInt:0] forKey:peripheral.identifier.UUIDString];
            
            break;
        }
    }
}

- (IBAction)clickAddSevser:(id)sender {
    
    ConnectViewController *connectVC = [[ConnectViewController alloc] init];
    
    [self.navigationController pushViewController:connectVC animated:YES];

}

@end
