//
//  SWLRequestManager.m
//  ManzuoDemo
//
//  Created by qianfeng on 15-4-14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SWLRequestManager.h"
#import "SWLRequest.h"

@implementation SWLRequestManager
{
    //字典，管理当前正在下载的任务
    NSMutableDictionary* _currentMissionDict;
    //数组，作为栈，管理正在等待的任务
    NSMutableArray* _waitMissionArray;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentMissionDict = [[NSMutableDictionary alloc]init];
        _waitMissionArray = [[NSMutableArray alloc]init];
        self.maxCurrent = 5;
    }
    return self;
}

//创建单例对象
+ (SWLRequestManager*)manager
{
    static SWLRequestManager* manager;
    if (manager == nil) {
        manager = [[SWLRequestManager alloc]init];
    }
    return manager;
}

//添加下载任务
- (void)addGETMissionWithURL:(NSString*)url success:(void (^)(SWLRequest* request,NSData* data))success failed:(void(^)(SWLRequest* request))failed
{
    if (_currentMissionDict[url]) {
        return;
    }
    
    //创建一个请求任务
    SWLRequest* request = [[SWLRequest alloc]init];
    //储存任务的相关属性
    request.url = url;
    request.success = success;
    request.failed = failed;
    
    //判断正在执行的任务是否达到最大并行数
    if (_currentMissionDict.count < self.maxCurrent) {
        //将新任务添加到正在执行的并行序列
        [request request];
        //正在执行的任务添加到字典中进行管理
        [_currentMissionDict setObject:request forKey:request.url];
        
    }else{
        //将新任务添加到栈中进行管理
        [self pushStack:request];
    }
}

//下载完成后，移除一个已经完成的请求
- (void)removeRequest:(SWLRequest*)request
{
    [_currentMissionDict removeObjectForKey:request.url];
    //查看有没有等待的请求
    SWLRequest* nextRequest = [self popStack];
    if (nextRequest == nil) {
        return;
    }
    //启动请求
    [nextRequest request];
    [_currentMissionDict setObject:nextRequest forKey:nextRequest.url];
}


#pragma mark 栈操作
- (void)pushStack:(SWLRequest*)request
{
    //去除重复的任务
    for (SWLRequest* waitRequest in _waitMissionArray) {
        if ([waitRequest.url isEqualToString:request.url] == YES) {
            [_waitMissionArray removeObject:waitRequest];
            break;
        }
    }
    //栈是古代盛衣服的木盆，先进后出
    [_waitMissionArray addObject:request];
}

//出栈
- (SWLRequest*)popStack
{
    if (_waitMissionArray.count == 0) {
        return nil;
    }
    SWLRequest* request = _waitMissionArray.lastObject;
    [_waitMissionArray removeLastObject];
    return request;
}

@end







