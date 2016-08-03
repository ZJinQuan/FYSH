//
//  CategoryViewController.h
//  Fysh
//
//  Created by QUAN on 16/7/15.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "BaseViewController.h"
#import "BabyBluetooth.h"

@interface CategoryViewController : BaseViewController{
@public
    BabyBluetooth *baby;
}

@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic,strong)CBPeripheral *currPeripheral;

@property (nonatomic, assign) int index;

@property (nonatomic, copy) NSString *state;

@end
