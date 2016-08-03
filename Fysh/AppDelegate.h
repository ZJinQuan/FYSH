//
//  AppDelegate.h
//  Fysh
//
//  Created by QUAN on 16/7/14.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) CBCharacteristic *characteristics;

@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) NSMutableArray *peripheralArr;

@property (nonatomic, strong) NSMutableArray *characteristicsArr;

@property (nonatomic, strong) NSMutableArray *FyshArray;

@property (nonatomic, strong) NSMutableArray *connArr;

@property (nonatomic, strong) NSMutableDictionary *counterDict;

@property (nonatomic, strong) NSMutableDictionary *remindDict;

@property (nonatomic, copy) NSString *fName; //名字

@property (nonatomic, copy) NSString *imageName; //图片名字

@property (nonatomic, copy) NSString *imageFile; //照相图片路径

@property (copy,nonatomic)NSString *state; //状态

@property (nonatomic, copy) NSString *disconnects;

@end

