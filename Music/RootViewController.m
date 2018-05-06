//
//  RootViewController.m
//  Music
//
//  Created by qianfeng on 15-3-31.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "RootViewController.h"
#import "TabBarViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"320"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)setItemWithImageName:(NSString*)imageName andTarget:(id)target andAction:(SEL)action
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)setItemsWithImageName1:(NSString *)imageName1 andTarget1:(id)target1 andAction1:(SEL)action1 andImageName2:(NSString*)imageName2 andTarget2:(id)target2 andAction:(SEL)action2
{
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 40, 40);
    [btn1 setImage:[UIImage imageNamed:imageName1] forState:UIControlStateNormal];
    [btn1 addTarget:target1 action:action1 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 0, 40, 40);
    [btn2 setImage:[UIImage imageNamed:imageName2] forState:UIControlStateNormal];
    [btn2 addTarget:target2 action:action2 forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item.width = -15;
    
    self.navigationItem.rightBarButtonItems = @[item,[[UIBarButtonItem alloc]initWithCustomView:btn2],[[UIBarButtonItem alloc]initWithCustomView:btn1]];
}

- (void)hideTabBar
{
    TabBarViewController* tab = (TabBarViewController*)self.tabBarController;
    [tab hideTabbar];
}
- (void)showTabBar
{
    TabBarViewController* tab = (TabBarViewController*)self.tabBarController;
    [tab showTabbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
