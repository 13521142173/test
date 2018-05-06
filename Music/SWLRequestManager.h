//
//  SWLRequestManager.h
//  ManzuoDemo
//
//  Created by qianfeng on 15-4-14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SWLRequest;

@interface SWLRequestManager : NSObject

//设置最大并发数
@property (nonatomic) NSUInteger maxCurrent;

+ (SWLRequestManager*)manager;
//添加下载任务
- (void)addGETMissionWithURL:(NSString*)url success:(void (^)(SWLRequest* request,NSData* data))success failed:(void(^)(SWLRequest* request))failed;
//下载完成后，移除一个已经完成的请求
- (void)removeRequest:(SWLRequest*)request;

@end
