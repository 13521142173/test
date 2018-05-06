//
//  HelpViewController.m
//  Music
//
//  Created by qianfeng on 15-4-2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "HelpViewController.h"
#import "MyFavorViewController.h"
#import "UaerViewController.h"
#import "GuanYuViewController.h"
#import "DownLoadViewController.h"

@interface HelpViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSArray* _tableSource;
}

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    [titleLabel setText:@"帮助"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"back_btn@2x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableSource = @[@"我的收藏",@"我的下载",@"使用帮助",@"关于MV盒子"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableSource.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    cell.textLabel.text = _tableSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MyFavorViewController* vc = [[MyFavorViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        DownLoadViewController* vc = [[DownLoadViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        UaerViewController* vc = [[UaerViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        GuanYuViewController* vc = [[GuanYuViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
