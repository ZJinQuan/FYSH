//
//  BlueConnectViewController.h
//  Cushion
//
//  Created by QUAN on 16/7/1.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"

@interface BlueConnectViewController : BaseViewController{
@public
    BabyBluetooth *baby;
}

@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;

@end
