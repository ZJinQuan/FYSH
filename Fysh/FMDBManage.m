//
//  FMDBManage.m
//  Bluetooth
//
//  Created by star on 15/3/30.
//  Copyright (c) 2015年 tentinet. All rights reserved.
//

#import "FMDBManage.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FyshModel.h"

@interface FMDBManage()
{
    FMDatabase *db;
}
@end

@implementation FMDBManage

-(NSString *)dbPath:(NSString *)fileName
{
    NSString *home=NSHomeDirectory();
    NSString *doc=[home stringByAppendingPathComponent:@"Documents"];
    NSString *path=[doc stringByAppendingPathComponent:fileName];
    return path;
}
-(id)init
{
    self=[super init];
    if(self)
    {
        db=[FMDatabase databaseWithPath:[self dbPath:@"FYSH.db"]];
        if(![db open])
        {
            NSLog(@"Can't open db!");
            return nil;
        }
        //在此创建表
        //f_index integer primary key autoincrement,
        [db executeUpdate:@"create table IF NOT EXISTS fysh (f_index integer primary key autoincrement,f_id Nvarchar(255),f_name Nvarchar(255),f_color Nvarchar(255),f_imagename Nvarchar(255),f_imgpath Nvarchar(255),f_distance Nvarchar(255),f_state Nvarchar(255),f_turnoff Nvarchar(255),f_longitude Nvarchar(255),f_latitude Nvarchar(255),f_address Nvarchar(255),f_isdisturb Nvarchar(1),f_timestring Nvarchar(255),catagory Nvarchar(255),ringer Nvarchar(255),oneclick Nvarchar(255))"];
        
    }
    return self;
}

+(FMDBManage *)shareIntance
{
    static dispatch_once_t pred=0;
    __strong static FMDBManage *intance=nil;
    dispatch_once(&pred,^{
        intance=[[self alloc] init];
    });
    return intance;
}

//全部列表
- (NSArray *)allFYSH {
    NSString *cmd=@"select * from fysh";
    NSMutableArray *addArray=[NSMutableArray array];
    NSMutableArray *queryArray=[self excuteQueryPlan
                                :cmd];
    for(int i=0;i<[queryArray count];i++)
    {
        NSMutableArray *obj=[queryArray objectAtIndex:i];
        FyshModel *model=[[FyshModel alloc] init];
        model.fIndex=[[obj objectAtIndex:0] integerValue];
        model.fColor = [obj objectAtIndex:1];
        model.imageName = [obj objectAtIndex:2];
        model.imgPath = [obj objectAtIndex:3];
        model.distance = [obj objectAtIndex:4];
        model.state = [obj objectAtIndex:5];
        model.fId = [obj objectAtIndex:6];
        model.fName = [obj objectAtIndex:7];
        model.turnoff = [obj objectAtIndex:8];
        model.longitude = [obj objectAtIndex:9] ;
        model.latitude =[obj objectAtIndex:10] ;
        model.address = [obj objectAtIndex:11];
        model.isdisturb = [obj objectAtIndex:12];
        model.timestring = [obj objectAtIndex:13];
        model.ringer = [obj objectAtIndex:14];
        model.oneclick = [obj objectAtIndex:15];
        [addArray addObject:model];
        model=nil;
    }
    
    return addArray;
}

//查询全部断开连接
- (NSArray *)allBreakFYSH {
    NSString *cmd=@"select * from fysh where f_turnoff = '1' ";
    NSMutableArray *addArray=[NSMutableArray array];
    NSMutableArray *queryArray=[self excuteQueryPlan
                                :cmd];
    for(int i=0;i<[queryArray count];i++)
    {
        NSMutableArray *obj=[queryArray objectAtIndex:i];
        FyshModel *model=[[FyshModel alloc] init];
        model.fIndex=[[obj objectAtIndex:0] integerValue];
        model.fColor = [obj objectAtIndex:1];
        model.imageName = [obj objectAtIndex:2];
        model.imgPath = [obj objectAtIndex:3];
        model.distance = [obj objectAtIndex:4];
        model.state = [obj objectAtIndex:5];
        model.fId = [obj objectAtIndex:6];
        model.fName = [obj objectAtIndex:7];
        model.turnoff = [obj objectAtIndex:8];
        model.longitude = [obj objectAtIndex:9] ;
        model.latitude =[obj objectAtIndex:10];
        model.address = [obj objectAtIndex:11];
        model.isdisturb = [obj objectAtIndex:12];
        [addArray addObject:model];
        model=nil;
    }
    
    return addArray;
}

-(NSMutableArray *)excuteQueryPlan:(NSString *)cmd
{
    NSMutableArray *addArray=[NSMutableArray array];
    FMResultSet *rs=[db executeQuery:cmd];
    while ([rs next]) {
        NSMutableArray *arr=[NSMutableArray arrayWithObjects:[rs stringForColumn:@"f_index"],[rs stringForColumn:@"f_color"],[rs stringForColumn:@"f_imagename"],[rs stringForColumn:@"f_imgpath"],[rs stringForColumn:@"f_distance"],[rs stringForColumn:@"f_state"],[rs stringForColumn:@"f_id"],[rs stringForColumn:@"f_name"],[rs stringForColumn:@"f_turnoff"],[rs stringForColumn:@"f_longitude"],[rs stringForColumn:@"f_latitude"],[rs stringForColumn:@"f_address"],[rs stringForColumn:@"f_isdisturb"] ,[rs stringForColumn:@"f_timestring"],[rs stringForColumn:@"ringer"],[rs stringForColumn:@"oneclick"] ,nil];
        [addArray addObject:arr];
    }
    [rs close];
    return addArray;
}



-(BOOL)exsistOfFYSH:(NSInteger)fIndex
{
    NSMutableArray *tem=[self executeQueryReturnId:[NSString stringWithFormat:@"select f_index from fysh where f_index='%ld'",(long)fIndex]];
    if([tem count]>0)
        return YES;
    return NO;
}

-(BOOL)deleteFYSH:(NSInteger)fIndex
{
    NSMutableArray *tem=[self executeQueryReturnId:[NSString stringWithFormat:@"select f_index from fysh where f_index='%ld'",(long)fIndex]];
    if([tem count]>0)
    {
        NSMutableArray *array=[tem objectAtIndex:0];
        int tag=[[array objectAtIndex:0] intValue];
        return [db executeUpdate:[NSString stringWithFormat:@"delete from fysh where f_index=%d",tag]];
    }
    return NO;
}

-(BOOL)updateFYSH:(FyshModel *)model {
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE fysh SET f_color = \'%@\', f_imagename = \'%@\', f_imgpath = \'%@\', f_distance = \'%@\', f_state = \'%@\', f_turnoff = \'%@\', f_longitude = \'%@\',f_latitude = \'%@\' , f_address = \'%@\' , f_isdisturb = \'%@\' , f_timestring = \'%@\', ringer = \'%@\', oneclick = \'%@\' WHERE f_index = %ld", model.fColor,model.imageName,model.imgPath,model.distance,model.state,model.turnoff,model.longitude,model.latitude,model.address,model.isdisturb,model.timestring,model.ringer,model.oneclick,(long)model.fIndex];
    return [db executeUpdate:updateSql];
    return YES;
}

-(BOOL)insertFYSH:(FyshModel *)model {
 
    NSString *sql;
    sql=[NSString stringWithFormat:@"insert into fysh(f_color,f_imagename,f_imgpath,f_distance,f_state,f_id,f_name,f_turnoff,f_longitude,f_latitude,f_address,f_isdisturb,f_timestring,ringer,oneclick) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@', '%@', '%@')" ,model.fColor,model.imageName,model.imgPath,model.distance,model.state,model.fId,model.fName,model.turnoff,model.longitude,model.latitude,model.address,model.isdisturb,model.timestring, model.ringer, model.oneclick];
    NSLog(@"%@",sql);
    BOOL insert=[db executeUpdate:sql];
    return insert;
}

//search db content for id
-(NSMutableArray *)executeQueryReturnId:(NSString *)cmd
{
    NSMutableArray *addArray=[NSMutableArray array];
    FMResultSet *rs=[db executeQuery:cmd];
    while ([rs next]) {
        NSMutableArray *arr=[NSMutableArray arrayWithObjects:[rs stringForColumn:@"f_index"], nil];
        [addArray addObject:arr];
    }
    [rs close];
    return addArray;
}

@end
