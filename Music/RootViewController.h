//
//  RootViewController.h
//  Music
//
//  Created by qianfeng on 15-3-31.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

- (void)setItemWithImageName:(NSString*)imageName andTarget:(id)target andAction:(SEL)action;
- (void)setItemsWithImageName1:(NSString *)imageName1 andTarget1:(id)target1 andAction1:(SEL)action1 andImageName2:(NSString*)imageName2 andTarget2:(id)target2 andAction:(SEL)action2;
- (void)hideTabBar;
- (void)showTabBar;

@end
