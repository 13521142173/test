//
//  CustomModel.h
//  Music
//
//  Created by qianfeng on 15-4-3.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "RootModel.h"

@interface CustomModel : RootModel

@property(strong,nonatomic) NSString* artistName;
@property(strong,nonatomic) NSString* id;
@property(strong,nonatomic) NSString* posterPic;
@property(strong,nonatomic) NSString* title;
@property(strong,nonatomic) NSString* url;

@end
