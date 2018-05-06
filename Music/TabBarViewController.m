//
//  TabBarViewController.m
//  Music
//
//  Created by qianfeng on 15-3-31.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "TabBarViewController.h"
#import "IndexViewController.h"
#import "MVViewController.h"
#import "VchartViewController.h"
#import "PlaylistViewController.h"

@interface TabBarViewController ()
{
    UIImageView* _backView;
}

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.hidden = YES;
    
    IndexViewController* index = [[IndexViewController alloc]init];
    UINavigationController* nav1 = [[UINavigationController alloc]initWithRootViewController:index];
    
    MVViewController* mv = [[MVViewController alloc]init];
    UINavigationController* nav2 = [[UINavigationController alloc]initWithRootViewController:mv];
    
    VchartViewController* vch = [[VchartViewController alloc]init];
    UINavigationController* nav3 = [[UINavigationController alloc]initWithRootViewController:vch];
    
    PlaylistViewController* play = [[PlaylistViewController alloc]init];
    UINavigationController* nav4 = [[UINavigationController alloc]initWithRootViewController:play];
    [self setViewControllers:@[nav1,nav2,nav3,nav4]];
    
    NSArray *titleImageArray = @[@"Bottom_First",@"Bottom_MV",@"Bottom_VList",@"Bottom_MVList"];
    NSArray *titleImageArraySel = @[@"Bottom_First_Sel",@"Bottom_MV_Sel",@"Bottom_VList_Sel",@"Bottom_MVList_Sel"];
    
    _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    _backView.image = [UIImage imageNamed:@"BottomBar_Icon"];
    _backView.userInteractionEnabled = YES;
    [self.view addSubview:_backView];
    
    for (int i = 0; i < 4; i ++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake((self.view.frame.size.width-320)/2+80*i, 0, 80, 49)];
        [btn setImage:[UIImage imageNamed:titleImageArray[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:titleImageArraySel[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10+i;
        if (i == 0) {
            btn.selected = YES;
        }
        [_backView addSubview:btn];
    }
    
}

- (void)btnClick:(UIButton*)btn
{
    self.selectedIndex = btn.tag-10;
    
    for (UIButton* sender in btn.superview.subviews) {
        if ([sender isMemberOfClass:[UIButton class]]) {
            sender.selected = NO;
        }
    }
    btn.selected = YES;
}

- (void)hideTabbar
{
    _backView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 49);
}
- (void)showTabbar
{
    _backView.frame = CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49);
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
