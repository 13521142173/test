//
//  SWLHTTPRequest.h
//  Music
//
//  Created by qianfeng on 15-4-1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWLHTTPRequest : NSObject<NSURLConnectionDataDelegate>

@property(strong) NSMutableData* responseData;
@property(assign) NSInteger tag;

@property(assign) id delegate;
@property(assign) SEL action;

+ (SWLHTTPRequest*)requestWithURLString:(NSString*)urlString andTarget:(id)delegate andCallBack:(SEL)action;
- (void)startRequestWithURLString:(NSString*)urlString andTarget:(id)delegate andCallBack:(SEL)action;
- (void)cancleRequest;
                                                                                            
@end
