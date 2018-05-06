//
//  Manager.h
//  Music
//
//  Created by qianfeng on 15-4-8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Manager : NSObject

+ (Manager*)shared;
- (void)inserDataWithId:(NSString*)uid artistName:(NSString*)name title:(NSString*)title imageName:(NSString*)imageUrl;
- (BOOL)isExists:(NSString*)uid;
- (void)deleteDataWith:(NSString*)uid;
- (NSArray*)selectAllData;

@end
