//
//  Manager.m
//  Music
//
//  Created by qianfeng on 15-4-8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "Manager.h"
#import "FMDatabase.h"

@implementation Manager
{
    FMDatabase* _dataBase;
}

static Manager* manager = nil;

+ (Manager*)shared
{
    if (manager == nil) {
        manager = [[Manager alloc]init];
    }
    return manager;
}

//创建数据库
- (id)init
{
    self = [super init];
    if (self) {
        //拼接一个完整的数据库文件的路径
        NSString* path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/myData.db"];
        NSLog(@"%@",path);
        //构建数据库文件
        _dataBase = [[FMDatabase alloc]initWithPath:path];
        //打开数据库，存在就打开，不存在就创建
        if ([_dataBase open]) {
            //首先确认要执行的sql语句
            NSString* createSql = @"create table if not exists favorite (uid varchar(256),name varchar(256),title varchar(256),imageName varchar(256));";
            if (![_dataBase executeQuery:createSql]) {
                NSLog(@"create dataBase error%@",_dataBase.lastError);
            }
        }
    }
    return self;
}

- (void)inserDataWithId:(NSString*)uid artistName:(NSString*)name title:(NSString*)title imageName:(NSString*)imageUrl
{
    NSString *insertSql = @"insert into favorite values(?,?,?,?)";
    if (![_dataBase executeUpdate:insertSql,uid,name,title,imageUrl]) {
        NSLog(@"insert error:%@",_dataBase.lastError);
    }
    
}
- (BOOL)isExists:(NSString *)uid{
    NSString *selectSql = @"select * from favorite where uid = ?";
    FMResultSet *set = [_dataBase executeQuery:selectSql,uid];
    return [set next];
}
- (void)deleteDataWith:(NSString *)uid{
    NSString *deleteSql = @"delete from favorite where uid = ?";
    if (![_dataBase executeUpdate:deleteSql,uid]) {
        NSLog(@"delete error:%@",_dataBase.lastError);
    }
}
- (NSArray *)selectAllData{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSString *selectSql = @"select * from favorite";
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    while ([set next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[set stringForColumnIndex:0] forKey:@"uid"];
        [dic setObject:[set stringForColumnIndex:1] forKey:@"name"];
        [dic setObject:[set stringForColumnIndex:2] forKey:@"title"];
        [dic setObject:[set stringForColumnIndex:3] forKey:@"imageUrl"];
        //NSLog(@"%@",[set stringForColumnIndex:3]);
        //NSLog(@"%@",[set stringForColumnIndex:4]);
       // [dic setObject:[set stringForColumnIndex:4] forKey:@"urlString"];
        [array addObject:dic];
    }
    return array;
}

@end
