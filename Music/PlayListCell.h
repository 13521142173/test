//
//  PlayListCell.h
//  Music
//
//  Created by qianfeng on 15-4-6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
@property (weak, nonatomic) IBOutlet UILabel *myTitle;
@property (weak, nonatomic) IBOutlet UILabel *mvCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreTotal;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UIImageView *smallImage;

@end
