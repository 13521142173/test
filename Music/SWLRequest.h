//
//  SWLRequest.h
//  ManzuoDemo
//
//  Created by qianfeng on 15-4-14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/*完成一次http请求，将请求到的数据回传*/
@interface SWLRequest : NSObject

//被请求网址
@property (nonatomic,copy) NSString* url;

//数据成功的回调方法
@property (nonatomic,copy) void (^success)(SWLRequest*,NSData*);
//数据请求失败的回调方法
@property (nonatomic,copy) void(^failed)(SWLRequest*);

//请求数据
- (void)request;

@end
