//
//  SettingViewController.h
//  Fysh
//
//  Created by QUAN on 16/7/15.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "BaseViewController.h"
#import "BabyBluetooth.h"

@interface SettingViewController : BaseViewController{
@public
    BabyBluetooth *baby;
}

@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic,strong)CBPeripheral *currPeripheral;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) int index;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *setting;

@property (nonatomic, strong) FyshModel *fyshM;
//@property (nonatomic, )
@end
