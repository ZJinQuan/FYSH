//
//  HomeViewController.h
//  Fysh
//
//  Created by QUAN on 16/7/19.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "BaseViewController.h"
#import "BabyBluetooth.h"

@interface HomeViewController : BaseViewController{
@public
    BabyBluetooth *baby;
}

@property (nonatomic, assign) int index;

@property (nonatomic, assign) BOOL isYes;

@end
