//
//  ReIndexCell.h
//  Music
//
//  Created by qianfeng on 15-4-10.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReIndexCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImage;
@property (weak, nonatomic) IBOutlet UILabel *firstSinger;
@property (weak, nonatomic) IBOutlet UILabel *secondSinger;
@property (weak, nonatomic) IBOutlet UILabel *thirdSinger;
@property (weak, nonatomic) IBOutlet UILabel *fourthSinger;
@property (weak, nonatomic) IBOutlet UILabel *des1;
@property (weak, nonatomic) IBOutlet UILabel *des2;
@property (weak, nonatomic) IBOutlet UILabel *des3;
@property (weak, nonatomic) IBOutlet UILabel *des4;

@end
