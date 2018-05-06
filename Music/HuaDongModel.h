//
//  HuaDongModel.h
//  Music
//
//  Created by qianfeng on 15-4-1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "RootModel.h"

@interface HuaDongModel : RootModel

@property(nonatomic,strong) NSString* description;
@property (nonatomic,copy)NSNumber *hdVideoSize;
@property (nonatomic,copy)NSNumber *id;
@property (nonatomic,copy)NSNumber *status;
@property (nonatomic,copy)NSNumber *uhdVideoSize;
@property (nonatomic,copy)NSNumber *videoSize;
@property (nonatomic,copy)NSString *posterPic;
@property (nonatomic,copy)NSString *thumbnailPic;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *traceUrl;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *url;

@end
