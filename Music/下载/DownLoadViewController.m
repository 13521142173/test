//
//  DownLoadViewController.m
//  Music
//
//  Created by qianfeng on 15-4-10.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "DownLoadViewController.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "Define.h"
#import "DownLoad.h"
#import "RelativeMVCell.h"
#import "CustomModel.h"


@interface DownLoadViewController ()<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    ASINetworkQueue* _queue;
    UITableView* _tableView;
    NSMutableArray* _tableSource;
    ASIFormDataRequest* _request;
}

@end

@implementation DownLoadViewController

//- (void)viewWillAppear:(BOOL)animated
//{
//    NSArray* array = [[DownLoad download]selectAllData];
//    _tableSource = [[NSMutableArray alloc]initWithArray:array];
//    if (_tableSource.count == 0) {
//        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-50, 200, 100, 100)];
//        label.font = [UIFont systemFontOfSize:15];
//        label.text = @"暂无下载";
//        label.numberOfLines = 0;
//        label.textColor = [UIColor blackColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        [self.view addSubview:label];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    [titleLabel setText:@"我的下载"];
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
    
//    _request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:self.urlString]];
//    _request.delegate = self;
//    //保存路径
//    NSString* savePath = [NSString stringWithFormat:@"%@/Documents/%@.mp4",NSHomeDirectory(),self.title];
//    NSString* tempPath = [NSString stringWithFormat:@"%@.temp",savePath];
//    //下载路径
//    [_request setDownloadDestinationPath:savePath];
//    //下载临时保存路径
//    [_request setTemporaryFileDownloadPath:tempPath];
//    //下载的进度指示器
//    UIProgressView* pro = [[UIProgressView alloc]initWithFrame:CGRectMake(20, 100, WIDTH-40, 40)];
//    [self.view addSubview:pro];
//    [_request setDownloadProgressDelegate:pro];
//    //断点续传
//    [_request setAllowResumeForFileDownloads:YES];
//    //后台下载
//    _request.shouldContinueWhenAppEntersBackground = YES;
//    //高精度下载
//    [_request setShouldResetDownloadProgress:YES];
//    
//    [_request startAsynchronous];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"DownloadCell" bundle:nil] forCellReuseIdentifier:@"downloadcell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RelativeMVCell" bundle:nil] forCellReuseIdentifier:@"relativemvcell"];
    
    NSArray* array = [[DownLoad download]selectAllData];
    _tableSource = [[NSMutableArray alloc]initWithArray:array];
    if (_tableSource.count == 0) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-50, 200, 100, 100)];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"暂无下载";
        label.numberOfLines = 0;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    
    //创建队列
    _queue = [ASINetworkQueue queue];
    //创建最大并发数
    _queue.maxConcurrentOperationCount = 5;
    //高精度下载
    _queue.showAccurateProgress = YES;
    //启动队列
    [_queue go];
    for (int i = 0; i < _tableSource.count; i ++) {
        NSDictionary* dic = _tableSource[i];
        ASIHTTPRequest* request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:dic[@"urlString"]]];
                    request.delegate = self;
                    NSString* savePath = [NSString stringWithFormat:@"%@Documents/%@.mp4",NSHomeDirectory(),dic[@"title"]];
                    NSString* tempPath = [NSString stringWithFormat:@"%@.temp",savePath];
                    //保存位置
                    [request setDownloadDestinationPath:savePath];
                    //临时文件保存位置
                    [request setTemporaryFileDownloadPath:tempPath];
                    //进度条
        UIProgressView* pro1 = [[UIProgressView alloc]initWithFrame:CGRectMake(WIDTH/2-135, 120*i+99, 270, 2)];
        [_tableView addSubview:pro1];
                    //进度回调给进度条
                    [request setDownloadProgressDelegate:pro1];
                    //设置断点续传
                    [request setAllowResumeForFileDownloads:YES];
                    //设置高精度下载
                    [request setShouldResetDownloadProgress:YES];
                    //设置后台下载
                    [request setShouldContinueWhenAppEntersBackground:YES];
                    [_queue addOperation:request];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2*_tableSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        return 80;
    }else{
        return 40;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        RelativeMVCell* cell = [tableView dequeueReusableCellWithIdentifier:@"relativemvcell" forIndexPath:indexPath];
        if (_tableSource.count > 0) {
            NSDictionary* dic = _tableSource[indexPath.row/2];
            cell.headImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"imageName"]]]];
            cell.songLabel.text = dic[@"title"];
            cell.singerLabel.text = dic[@"artistName"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"download"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"download"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"下载成功");
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"下载失败");
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
