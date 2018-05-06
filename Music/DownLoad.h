//
//  DownLoad.h
//  Music
//
//  Created by qianfeng on 15-4-10.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoad : NSObject

+ (DownLoad*)download;
- (void)inserDataWithId:(NSString*)uid artistName:(NSString*)name title:(NSString*)title imageName:(NSString*)imageUrl urlString:(NSString*)urlString;
- (BOOL)isExists:(NSString*)uid;
- (void)deleteDataWith:(NSString*)uid;
- (NSArray*)selectAllData;

@end
