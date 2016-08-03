//
//  DashoardViewController.h
//  Fysh
//
//  Created by QUAN on 16/7/15.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "BaseViewController.h"
#import "BabyBluetooth.h"

@interface DashoardViewController : BaseViewController{
@public
    BabyBluetooth *baby;
}

@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic,strong)CBPeripheral *currPeripheral;

@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *titileImg;

@property (nonatomic, assign) int index;

@property (nonatomic, assign) BOOL isYes;
@end
