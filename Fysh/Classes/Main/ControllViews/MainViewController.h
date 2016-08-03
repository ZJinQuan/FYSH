//
//  MainViewController.h
//  Fysh
//
//  Created by QUAN on 16/7/15.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "BaseViewController.h"
#import "BabyBluetooth.h"

typedef enum : NSInteger {
    
    sleepStart,
    
    homeZone,
    
    timeZone,
    
    Gsender,
    
} Pattern;

@interface MainViewController : BaseViewController{
@public
    BabyBluetooth *baby;
    Pattern Pattern;
}

@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic,strong)CBPeripheral *currPeripheral;

@end
