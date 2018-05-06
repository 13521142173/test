//
//  PlaylistViewController.m
//  Music
//
//  Created by qianfeng on 15-3-31.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "PlaylistViewController.h"
#import "HelpViewController.h"
#import "NewSearchViewController.h"
#import "Define.h"
#import "PlayListCell.h"
//#import "SWLHTTPRequest.h"
#import "PlayListModel.h"
#import "IntroductionViewController.h"
#import "SWLRequestManager.h"
#import "MJRefresh.h"


@interface PlaylistViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UISegmentedControl* _seg;
    UITableView* _tableView;
    NSMutableArray* _tableSource;
    NSInteger _offset[3];
    //SWLHTTPRequest* _request1;
    //SWLHTTPRequest* _request2;
    
}

@end

@implementation PlaylistViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self showTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < 3; i ++) {
        _offset[i] = 20;
    }
    _tableSource = [[NSMutableArray alloc]init];
    for (int i = 0; i < 3; i ++) {
        NSMutableArray* array = [[NSMutableArray alloc]init];
        [_tableSource addObject:array];
    }
        
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    [titleLabel setText:@"推荐"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
    
    [self setItemsWithImageName1:@"Moive_Share_Pengyouquan" andTarget1:self andAction1:@selector(rightItemClick) andImageName2:@"Search" andTarget2:self andAction:@selector(searchClick)];
    
    [self createSeg];
    [self createTableView];
    
}

- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 99, WIDTH, HEIGHT-49-35-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [_tableView registerNib:[UINib nibWithNibName:@"PlayListCell" bundle:nil] forCellReuseIdentifier:@"playcell"];
    
    [_tableView addHeaderWithTarget:self action:@selector(headRefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

- (void)headRefreshing
{
    NSArray* array = @[CHOICEurl,HOTurl,NEWurl];
    NSString* urlString = [NSString stringWithFormat:@"%@%@",array[_seg.selectedSegmentIndex],Info];
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:urlString success:^(SWLRequest *request, NSData *data) {
        _offset[_seg.selectedSegmentIndex] = 20;
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"dic = %@",dic);
        NSArray* array = dic[@"playLists"];
       // [_tableSource removeAllObjects];
        [((NSMutableArray*)_tableSource[_seg.selectedSegmentIndex]) removeAllObjects];
        for (NSDictionary* arrDic in array) {
            PlayListModel* model = [[PlayListModel alloc]init];
            model.id = arrDic[@"id"];
            model.playListPic = arrDic[@"playListPic"];
            model.nickName = arrDic[@"creator"][@"nickName"];
            model.smallAvatar = arrDic[@"creator"][@"smallAvatar"];
            model.integral = arrDic[@"integral"];
            model.title = arrDic[@"title"];
            model.videoCount = arrDic[@"videoCount"];
            
            [(NSMutableArray*)_tableSource[_seg.selectedSegmentIndex] addObject:model];
        }
        [_tableView reloadData];
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
    NSArray* array = @[@"CHOICE",@"HOT",@"NEW"];
    NSMutableString* str = [[NSMutableString alloc]init];
    [str appendString:[NSString stringWithFormat:TuiJianMore,array[_seg.selectedSegmentIndex],(long)_offset[_seg.selectedSegmentIndex]]];
    [str appendString:Info];
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:str success:^(SWLRequest *request, NSData *data) {
        _offset[_seg.selectedSegmentIndex] = 20;
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"dic = %@",dic);
        NSArray* array = dic[@"playLists"];
        //[_tableSource removeAllObjects];
        for (NSDictionary* arrDic in array) {
            PlayListModel* model = [[PlayListModel alloc]init];
            model.id = arrDic[@"id"];
            model.playListPic = arrDic[@"playListPic"];
            model.nickName = arrDic[@"creator"][@"nickName"];
            model.smallAvatar = arrDic[@"creator"][@"smallAvatar"];
            model.integral = arrDic[@"integral"];
            model.title = arrDic[@"title"];
            model.videoCount = arrDic[@"videoCount"];
            
            [(NSMutableArray*)_tableSource[_seg.selectedSegmentIndex] addObject:model];
        }
        if (array.count>0) {
            _offset[_seg.selectedSegmentIndex] += 20;
        }
        [_tableView reloadData];
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
    [_tableView reloadData];
    [_tableView headerEndRefreshing];
}

- (void)createSeg
{
    NSArray* array = @[@"精选",@"热门",@"最新"];
    _seg = [[UISegmentedControl alloc]initWithItems:array];
    [_seg setFrame:CGRectMake((WIDTH-300)/2, 69, 300, 25)];
    [_seg setSelectedSegmentIndex:0];
    [_seg addTarget:self action:@selector(segValueChanged:) forControlEvents:UIControlEventValueChanged];
    _seg.tintColor = [UIColor colorWithRed:0.847 green:0.106 blue:0.149 alpha:1];
    [self.view addSubview:_seg];
    
    if (_seg.selectedSegmentIndex == 0) {
//        _request1 = [[SWLHTTPRequest alloc]init];
//        [_request1 startRequestWithURLString:[NSString stringWithFormat:@"%@%@",CHOICEurl,Info] andTarget:self andCallBack:@selector(finishLoad:)];
        [self requestDataWith:[NSString stringWithFormat:@"%@%@",CHOICEurl,Info]];
    }
}

//- (void)finishLoad:(SWLHTTPRequest*)request
//{
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    //NSLog(@"dic = %@",dic);
//    NSArray* array = dic[@"playLists"];
//    [_tableSource removeAllObjects];
//    for (NSDictionary* arrDic in array) {
//        PlayListModel* model = [[PlayListModel alloc]init];
//        model.id = arrDic[@"id"];
//        model.playListPic = arrDic[@"playListPic"];
//        model.nickName = arrDic[@"creator"][@"nickName"];
//        model.smallAvatar = arrDic[@"creator"][@"smallAvatar"];
//        model.integral = arrDic[@"integral"];
//        model.title = arrDic[@"title"];
//        model.videoCount = arrDic[@"videoCount"];
//        
//        [_tableSource addObject:model];
//    }
//    [_tableView reloadData];
//}

- (void)segValueChanged:(UISegmentedControl*)seg
{
    NSArray* array = @[CHOICEurl,HOTurl,NEWurl];
//    _request2 = [[SWLHTTPRequest alloc]init];
//    [_request2 startRequestWithURLString:[NSString stringWithFormat:@"%@%@",array[seg.selectedSegmentIndex],Info] andTarget:self andCallBack:@selector(finishLoad:)];
    [self requestDataWith:[NSString stringWithFormat:@"%@%@",array[seg.selectedSegmentIndex],Info]];
}

- (void)requestDataWith:(NSString*)url
{
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:url success:^(SWLRequest *request, NSData *data) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"dic = %@",dic);
        NSArray* array = dic[@"playLists"];
        //[_tableSource removeAllObjects];
        [(NSMutableArray*)_tableSource[_seg.selectedSegmentIndex] removeAllObjects];
        for (NSDictionary* arrDic in array) {
            PlayListModel* model = [[PlayListModel alloc]init];
            model.id = arrDic[@"id"];
            model.playListPic = arrDic[@"playListPic"];
            model.nickName = arrDic[@"creator"][@"nickName"];
            model.smallAvatar = arrDic[@"creator"][@"smallAvatar"];
            model.integral = arrDic[@"integral"];
            model.title = arrDic[@"title"];
            model.videoCount = arrDic[@"videoCount"];
            
            [(NSMutableArray*)_tableSource[_seg.selectedSegmentIndex] addObject:model];
        }
        [_tableView reloadData];
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableSource.count == 0) {
        return 10;
    }
    return [(NSMutableArray*)_tableSource[_seg.selectedSegmentIndex] count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"playcell" forIndexPath:indexPath];
    if (_tableSource.count>0) {
        PlayListModel* model = ((NSMutableArray*)_tableSource[_seg.selectedSegmentIndex])[indexPath.row];;
        cell.bigImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.playListPic]]];
        cell.myTitle.text = model.title;
        cell.mvCount.text = [NSString stringWithFormat:@"%@",model.videoCount] ;
        cell.scoreTotal.text = [NSString stringWithFormat:@"%@",model.integral];
        cell.author.text = model.nickName;
        cell.smallImage.layer.cornerRadius = 15;
        cell.smallImage.layer.masksToBounds = YES;
        cell.smallImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.smallAvatar]]];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayListModel* model = ((NSMutableArray*)_tableSource[_seg.selectedSegmentIndex])[indexPath.row];
    IntroductionViewController* vc = [[IntroductionViewController alloc]init];
    vc.ID = model.id;
    vc.title = model.title;
//    NSString* string = [NSString stringWithFormat:PlaylistString,model.id];
//    vc.urlString = [NSString stringWithFormat:@"%@%@",string,Info];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)rightItemClick
{
    HelpViewController* helpVC = [[HelpViewController alloc]init];
    [self.navigationController pushViewController:helpVC animated:YES];
    [self hideTabBar];
}
- (void)searchClick
{
    NewSearchViewController* newSearch = [[NewSearchViewController alloc]init];
    [self.navigationController pushViewController:newSearch animated:YES];
    [self hideTabBar];
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
