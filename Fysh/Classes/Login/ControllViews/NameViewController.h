//
//  NameViewController.h
//  Fysh
//
//  Created by QUAN on 16/7/17.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "BaseViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"

@interface NameViewController : BaseViewController{
@public
    BabyBluetooth *baby;
}

@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;

@end
