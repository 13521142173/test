//
//  SWLHTTPRequest.m
//  Music
//
//  Created by qianfeng on 15-4-1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SWLHTTPRequest.h"

@implementation SWLHTTPRequest
{
    NSURLConnection* _connection;
}

+ (SWLHTTPRequest*)requestWithURLString:(NSString*)urlString andTarget:(id)delegate andCallBack:(SEL)action
{
    SWLHTTPRequest* request = [[SWLHTTPRequest alloc]init];
    [request startRequestWithURLString:urlString andTarget:delegate andCallBack:action];
    return request;
}
- (void)startRequestWithURLString:(NSString*)urlString andTarget:(id)delegate andCallBack:(SEL)action
{
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    self.delegate = delegate;
    _action = action;
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
}
- (void)cancleRequest
{
    [_connection cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"开始连接");
    _responseData = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate performSelector:_action withObject:self];
}

@end
