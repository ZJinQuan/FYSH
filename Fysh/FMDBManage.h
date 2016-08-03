//
//  FMDBManage.h
//  Bluetooth
//
//  Created by star on 15/3/30.
//  Copyright (c) 2015年 tentinet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FyshModel;
@interface FMDBManage : NSObject

+(FMDBManage *)shareIntance;

//全部列表
- (NSArray *)allFYSH ;

//查询全部断开连接
- (NSArray *)allBreakFYSH;

//查询是否存在
-(BOOL)exsistOfFYSH:(NSInteger)fIndex;

//删除
-(BOOL)deleteFYSH:(NSInteger)fIndex;

//更新
-(BOOL)updateFYSH:(FyshModel *)model;

//插入
-(BOOL)insertFYSH:(FyshModel *)model;

@end
