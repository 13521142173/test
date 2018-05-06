//
//  MyFavorViewController.m
//  Music
//
//  Created by qianfeng on 15-4-8.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MyFavorViewController.h"
#import "Manager.h"
#import "RelativeMVCell.h"
#import "MVPlayViewController.h"
#import "Define.h"
//#import "SWLHTTPRequest.h"
#import "SWLRequestManager.h"

@interface MyFavorViewController ()
{
    UITableView* _tableView;
    NSMutableArray* _dataSource;
    //SWLHTTPRequest* _request;
    NSDictionary* _dic;
    NSDictionary* _dic1;
}

@end

@implementation MyFavorViewController

- (void)viewWillAppear:(BOOL)animated
{
    NSArray* array = [[Manager shared]selectAllData];
    _dataSource = [[NSMutableArray alloc]initWithArray:array];
    [_tableView reloadData];
    if (_dataSource.count == 0) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-125, 200, 250, 100)];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"暂无收藏，在播放MV界面点击收藏按钮，收藏您最喜爱的MV";
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.textColor = [UIColor blackColor];
        //label.backgroundColor = [UIColor redColor];
        [self.view addSubview:label];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    [titleLabel setText:@"我的收藏"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
    
    NSArray* array = [[Manager shared]selectAllData];
    _dataSource = [[NSMutableArray alloc]initWithArray:array];
    if (_dataSource.count == 0) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-125, 200, 250, 100)];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"暂无收藏，在播放MV界面点击收藏按钮，收藏您最喜爱的MV";
        label.numberOfLines = 0;
        [self.view addSubview:label];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"RelativeMVCell" bundle:nil] forCellReuseIdentifier:@"relativemvcell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RelativeMVCell* cell = [tableView dequeueReusableCellWithIdentifier:@"relativemvcell" forIndexPath:indexPath];
    if (_dataSource.count>0) {
        NSDictionary* dic = _dataSource[indexPath.row];
        cell.headImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"imageUrl"]]]];
        cell.songLabel.text = dic[@"title"];
        cell.singerLabel.text = dic[@"name"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   _dic1 = _dataSource[indexPath.row];
//    _request = [[SWLHTTPRequest alloc]init];
    NSString* urlString = [NSString stringWithFormat:showString,_dic1[@"uid"]];
//    [_request startRequestWithURLString:[NSString stringWithFormat:@"%@%@",urlString,Info] andTarget:self andCallBack:@selector(finishRequest1:)];
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:[NSString stringWithFormat:@"%@%@",urlString,Info] success:^(SWLRequest *request, NSData *data) {
        _dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        MVPlayViewController* vc = [[MVPlayViewController alloc]init];
        vc.ID = _dic1[@"uid"];
        vc.title = _dic1[@"title"];
        vc.urlString = _dic[@"hdUrl"];
        [self.navigationController pushViewController:vc animated:YES];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
}

//- (void)finishRequest1:(SWLHTTPRequest*)request
//{
//    _dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    MVPlayViewController* vc = [[MVPlayViewController alloc]init];
//    vc.ID = _dic1[@"uid"];
//    vc.title = _dic1[@"title"];
//    vc.urlString = _dic[@"hdUrl"];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)btnClicked{
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
