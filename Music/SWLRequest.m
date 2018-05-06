//
//  SWLRequest.m
//  ManzuoDemo
//
//  Created by qianfeng on 15-4-14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SWLRequest.h"
#import "AFNetworking.h"

@implementation SWLRequest

//请求数据
- (void)request
{
    //使用AFNetWorking进行下载
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    //设置请求的数据是data，不要解析
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //如此设置，请求到的数据是data,不要解析
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    //发起get请求
   [ manager GET:self.url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //成功了，responseObject就是下到的data
        //回传数据
       
       self.success(self,responseObject);
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //self.failed有可能是空，失败时可以不写方法处理
        if (self.failed != nil) {
            self.failed(self);
        }
    }];
}
#pragma clang diagnostic pop

@end
