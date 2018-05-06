//
//  DownLoad.m
//  Music
//
//  Created by qianfeng on 15-4-10.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "DownLoad.h"
#import "FMDatabase.h"

@implementation DownLoad
{
    FMDatabase* _dataBase;
}

static DownLoad* download = nil;
+ (DownLoad*)download
{
    if (download == nil) {
        download = [[DownLoad alloc]init];
    }
    return download;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/myDownLoad.db"];
        NSLog(@"path = %@",path);
        _dataBase = [[FMDatabase alloc]initWithPath:path];
        if ([_dataBase open]) {
            NSString *createSql = @"create table if not exists favorite (uid varchar(128),name varchar(128),title varchar(128),imageName varchar(128),string varchar(128));";
            if (![_dataBase executeUpdate:createSql]) {
                NSLog(@"create dataBase error:%@",_dataBase.lastError);
            }
        }
    }
    return self;
}
- (void)inserDataWithId:(NSString*)uid artistName:(NSString*)name title:(NSString*)title imageName:(NSString*)imageUrl urlString:(NSString*)urlString
{
    NSString* sql = @"insert into favorite values(?,?,?,?,?)";
    if (![_dataBase executeUpdate:sql,uid,name,title,imageUrl,urlString]) {
        NSLog(@"insert error %@",_dataBase.lastError);
    }
}
- (BOOL)isExists:(NSString*)uid
{
    NSString* sql = @"select * from favorite where uid = ?";
    FMResultSet* set = [_dataBase executeQuery:sql,uid];
    return [set next];
}
- (void)deleteDataWith:(NSString*)uid
{
    NSString* sql = @"delete from favorite where uid = ?";
    if (![_dataBase executeUpdate:sql,uid]) {
        NSLog(@"delete error:%@",_dataBase.lastError);
    }
}
- (NSArray*)selectAllData
{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    NSString* sql = @"select * from favorite";
    FMResultSet* set = [_dataBase executeQuery:sql];
    while ([set next]) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[set stringForColumnIndex:0] forKey:@"uid"];
        [dic setObject:[set stringForColumnIndex:1] forKey:@"artistName"];
        [dic setObject:[set stringForColumnIndex:2] forKey:@"title"];
        [dic setObject:[set stringForColumnIndex:3] forKey:@"imageName"];
        [dic setObject:[set stringForColumnIndex:4] forKey:@"urlString"];
        [array addObject:dic];
    }
    return array;
}

@end
