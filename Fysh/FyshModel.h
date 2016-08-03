//
//  FIFOModel.h
//  Bluetooth
//
//  Created by star on 15/3/30.
//  Copyright (c) 2015年 tentinet. All rights reserved.
//

#import "BaseModel.h"

@interface FyshModel : BaseModel


@property (assign,nonatomic) NSInteger fIndex;
@property (copy,nonatomic)NSString *fId;
@property (copy,nonatomic)NSString *fName;
@property (copy,nonatomic)NSString *fColor;
@property (copy,nonatomic)NSString *imageName;
@property (copy,nonatomic)NSString *imgPath;
@property (copy,nonatomic)NSString *distance;
@property (copy,nonatomic)NSString *state;
@property (copy,nonatomic)NSString *turnoff;
@property (copy,nonatomic)NSString *longitude;
@property (copy,nonatomic)NSString *latitude;
@property (copy,nonatomic)NSString *address;
@property (copy,nonatomic)NSString *isdisturb;
@property (copy,nonatomic)NSString *uuid;
@property (copy,nonatomic)NSString *timestring;
@property (nonatomic, copy) NSString *ringer;
@property (nonatomic, copy) NSString *oneclick;
//- (instancetype)initWithDict:(NSDictionary *)dict;
@end
