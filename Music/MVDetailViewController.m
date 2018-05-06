//
//  MVDetailViewController.m
//  Music
//
//  Created by qianfeng on 15-4-7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MVDetailViewController.h"
#import "Define.h"
//#import "SWLHTTPRequest.h"
#import "RelativeMVCell.h"
#import "CustomModel.h"
#import "MVPlayViewController.h"
#import "SWLRequestManager.h"
#import "MJRefresh.h"

@interface MVDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    NSMutableArray* _tableSource;
    NSInteger _offset;
}

@end

@implementation MVDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _offset = 20;
    
    [self hideTabBar];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    [titleLabel setText:self.title];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"back_btn@2x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
//    SWLHTTPRequest* request = [[SWLHTTPRequest alloc]init];
//    NSMutableString* urlStr = [NSMutableString stringWithFormat:MvUrl,self.ID];
//    [urlStr appendString:Info];
//    [request startRequestWithURLString:urlStr andTarget:self andCallBack:@selector(finishLoad:)];
    [self requestData];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableSource = [[NSMutableArray alloc]init];
    
    [_tableView registerNib:[UINib nibWithNibName:@"RelativeMVCell" bundle:nil] forCellReuseIdentifier:@"relativemvcell"];
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
}

- (void)headerRefreshing
{
    
    //[self requestData];
    NSMutableString* urlStr = [NSMutableString stringWithFormat:MvUrl,self.ID];
    [urlStr appendString:Info];
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:urlStr success:^(SWLRequest *request, NSData *data) {
        _offset = 20;
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray* array = dic[@"videos"];
        [_tableSource removeAllObjects];
        for (NSDictionary* arrDic in array) {
            CustomModel* model = [[CustomModel alloc]init];
            [model setValuesForKeysWithDictionary:arrDic];
            [_tableSource addObject:model];
        }
        
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
    
    [_tableView reloadData];
    [_tableView headerEndRefreshing];
    
}
- (void)footerRefreshing
{
    NSMutableString* urlString = [[NSMutableString alloc]initWithFormat:MvUrlMore,(long)_offset,self.ID];
    [urlString appendString:Info];
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:urlString success:^(SWLRequest *request, NSData *data) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray* array = dic[@"videos"];
        [_tableSource removeAllObjects];
        for (NSDictionary* arrDic in array) {
            CustomModel* model = [[CustomModel alloc]init];
            [model setValuesForKeysWithDictionary:arrDic];
            [_tableSource addObject:model];
        }
        if (array.count > 0) {
            _offset += 20;
        }
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
    
    [_tableView reloadData];
    [_tableView footerEndRefreshing];
}

- (void)requestData
{
    NSMutableString* urlStr = [NSMutableString stringWithFormat:MvUrl,self.ID];
    [urlStr appendString:Info];
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:urlStr success:^(SWLRequest *request, NSData *data) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray* array = dic[@"videos"];
        [_tableSource removeAllObjects];
        for (NSDictionary* arrDic in array) {
            CustomModel* model = [[CustomModel alloc]init];
            [model setValuesForKeysWithDictionary:arrDic];
            [_tableSource addObject:model];
        }
        [_tableView reloadData];
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
}

//- (void)finishLoad:(SWLHTTPRequest*)request
//{
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    NSArray* array = dic[@"videos"];
//    [_tableSource removeAllObjects];
//    for (NSDictionary* arrDic in array) {
//        CustomModel* model = [[CustomModel alloc]init];
//        [model setValuesForKeysWithDictionary:arrDic];
//        [_tableSource addObject:model];
//    }
//    [_tableView reloadData];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableSource.count == 0) {
        return 0;
    }
    return _tableSource.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RelativeMVCell* cell = [tableView dequeueReusableCellWithIdentifier:@"relativemvcell" forIndexPath:indexPath];
    if (_tableSource.count>0) {
        CustomModel* model = _tableSource[indexPath.row];
        cell.headImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.posterPic]]];
        cell.songLabel.text = model.title;
        cell.singerLabel.text = model.artistName;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomModel* model = _tableSource[indexPath.row];
    MVPlayViewController* detailVC = [[MVPlayViewController alloc]init];
    detailVC.ID = model.id;
    detailVC.urlString = model.url;
    detailVC.title = model.title;
    [self.navigationController pushViewController:detailVC animated:YES];
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
