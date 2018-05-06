//
//  VchartViewController.m
//  Music
//
//  Created by qianfeng on 15-3-31.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "VchartViewController.h"
#import "Define.h"
#import "HelpViewController.h"
#import "NewSearchViewController.h"
//#import "SWLHTTPRequest.h"
#import "VchartCell.h"
#import "VchartModel.h"
#import "MVPlayViewController.h"
#import "MJRefresh.h"
#import "SWLRequestManager.h"


@interface VchartViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataArray;
//    SWLHTTPRequest* _request;
//    SWLHTTPRequest* _request1;
    NSInteger _selectBtn;
    NSInteger _offset[5];
}

@end

@implementation VchartViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self showTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < 5; i ++) {
        _offset[i] = 20;
    }
    _dataArray  = [[NSMutableArray alloc]init];
    for (int i = 0; i < 5; i ++) {
        NSMutableArray* array = [[NSMutableArray alloc]init];
        [_dataArray addObject:array];
    }
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    [titleLabel setText:@"榜单"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
    
    [self setItemsWithImageName1:@"Moive_Share_Pengyouquan" andTarget1:self andAction1:@selector(rightItemClick) andImageName2:@"Search" andTarget2:self andAction:@selector(searchClick)];
    
    UIView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 44)];
    view.backgroundColor = [UIColor blackColor];
    [view setUserInteractionEnabled:YES];
    [self.view addSubview:view];
    
    NSArray* array = @[@"日本",@"欧美",@"内地",@"韩国",@"港台"];
    CGFloat space = (WIDTH-44*5)/4;
    for (int i = 0; i < 5; i ++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*(space+44), 0, 44, 44)];
        btn.tag = 100+i;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        if (i == 2) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal] ;
            _selectBtn = 2;
        }else{
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        }
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,108, WIDTH, HEIGHT-108-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerNib:[UINib nibWithNibName:@"VchartCell" bundle:nil] forCellReuseIdentifier:@"vchartcell"];
    //[_tableView setTableHeaderView:view];
    
//    _request = [[SWLHTTPRequest alloc]init];
//    [_request startRequestWithURLString:[NSString stringWithFormat:@"%@%@",MLurl,Info] andTarget:self andCallBack:@selector(finishLoad:)];
    [self requestData];
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

- (void)requestData
{
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:[NSString stringWithFormat:@"%@%@",MLurl,Info] success:^(SWLRequest *request, NSData *data) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray* array = dic[@"videos"];
        [(NSMutableArray*)_dataArray[_selectBtn] removeAllObjects];
        for (NSDictionary* Dic in array) {
            VchartModel* model = [[VchartModel alloc]init];
            [model setValuesForKeysWithDictionary:Dic];
            [(NSMutableArray*)_dataArray[_selectBtn] addObject:model];
        }
        [_tableView reloadData];
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
}

- (void)headerRefreshing
{
    NSMutableString* str = [[NSMutableString alloc]init];
    if (_selectBtn == 0) {
        [str appendString:[NSString stringWithFormat:@"%@%@",JPurl,Info]];
    }else if (_selectBtn == 1){
        [str appendString:[NSString stringWithFormat:@"%@%@",USurl,Info]];
    }else if (_selectBtn == 2){
        [str appendString:[NSString stringWithFormat:@"%@%@",MLurl,Info]];
    }else if (_selectBtn == 3){
        [str appendString:[NSString stringWithFormat:@"%@%@",KRurl,Info]];
    }else if (_selectBtn == 4){
        [str appendString:[NSString stringWithFormat:@"%@%@",HTurl,Info]];
    }
    
//    [_request1 startRequestWithURLString:str andTarget:self andCallBack:@selector(finishedLoad:)];
    
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:str success:^(SWLRequest *request, NSData *data) {
        _offset[_selectBtn] = 20;
        //[((NSMutableArray*)_dataArray[_selectBtn]) removeAllObjects];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray* array = dic[@"videos"];
        [((NSMutableArray*)_dataArray[_selectBtn]) removeAllObjects];
        for (NSDictionary* Dic in array) {
            VchartModel* model = [[VchartModel alloc]init];
            [model setValuesForKeysWithDictionary:Dic];
            [((NSMutableArray*)_dataArray[_selectBtn]) addObject:model];
        }
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
    
    [_tableView reloadData];
    [_tableView headerEndRefreshing];
}
//- (void)finishedLoad:(SWLHTTPRequest*)request
//{
//    _offset[_selectBtn] = 20;
//    //[((NSMutableArray*)_dataArray[_selectBtn]) removeAllObjects];
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    NSArray* array = dic[@"videos"];
//    [((NSMutableArray*)_dataArray[_selectBtn]) removeAllObjects];
//    for (NSDictionary* Dic in array) {
//        VchartModel* model = [[VchartModel alloc]init];
//        [model setValuesForKeysWithDictionary:Dic];
//        [((NSMutableArray*)_dataArray[_selectBtn]) addObject:model];
//    }
//    
//}

- (void)footerRefreshing
{
    NSMutableString* str = [[NSMutableString alloc]init];
    if (_selectBtn == 0) {
        [str appendString:[NSString stringWithFormat:VChartMore,@"JP",(long)_offset[0]]];
    }else if (_selectBtn == 1){
        [str appendString:[NSString stringWithFormat:VChartMore,@"US",(long)_offset[1]]];
    }else if (_selectBtn == 2){
        [str appendString:[NSString stringWithFormat:VChartMore,@"ML",(long)_offset[2]]];
    }else if (_selectBtn == 3){
        [str appendString:[NSString stringWithFormat:VChartMore,@"KR",(long)_offset[3]]];
    }else if (_selectBtn == 4){
        [str appendString:[NSString stringWithFormat:VChartMore,@"HT",(long)_offset[4]]];
    }
    
    [str appendString:Info];
//    SWLHTTPRequest* request = [[SWLHTTPRequest alloc]init];
//    [request startRequestWithURLString:str andTarget:self andCallBack:@selector(finishedLoading:)];
    
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:str success:^(SWLRequest *request, NSData *data) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray* array = dic[@"videos"];
        
        for (NSDictionary* Dic in array) {
            VchartModel* model = [[VchartModel alloc]init];
            [model setValuesForKeysWithDictionary:Dic];
            [((NSMutableArray*)_dataArray[_selectBtn]) addObject:model];
        }
        if (array.count>0) {
            _offset[_selectBtn] += 20;
            // [_tableView reloadData];
        }
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
    
    [_tableView reloadData];
    [_tableView footerEndRefreshing];
}
//- (void)finishedLoading:(SWLHTTPRequest*)request
//{
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    NSArray* array = dic[@"videos"];
//    
//    for (NSDictionary* Dic in array) {
//        VchartModel* model = [[VchartModel alloc]init];
//        [model setValuesForKeysWithDictionary:Dic];
//        [((NSMutableArray*)_dataArray[_selectBtn]) addObject:model];
//    }
//    if (array.count>0) {
//        _offset[_selectBtn] += 20;
//       // [_tableView reloadData];
//    }
////    [_tableView footerEndRefreshing];
//}

//- (void)finishLoad:(SWLHTTPRequest*)request
//{
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    NSArray* array = dic[@"videos"];
//    [(NSMutableArray*)_dataArray[_selectBtn] removeAllObjects];
//    for (NSDictionary* Dic in array) {
//        VchartModel* model = [[VchartModel alloc]init];
//        [model setValuesForKeysWithDictionary:Dic];
//        [(NSMutableArray*)_dataArray[_selectBtn] addObject:model];
//    }
//    [_tableView reloadData];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((NSMutableArray*)_dataArray[_selectBtn] == 0) {
        return 10;
    }
    return [(NSMutableArray*)_dataArray[_selectBtn] count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VchartCell* cell = [tableView dequeueReusableCellWithIdentifier:@"vchartcell" forIndexPath:indexPath];
    if ((NSMutableArray*)_dataArray[_selectBtn]>0) {
        VchartModel* model = ((NSMutableArray*)_dataArray[_selectBtn])[indexPath.row];
        cell.rankLabel.text = [NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)];
        cell.scoreLabel.text = model.score;
        cell.backImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.posterPic]]];
        cell.songLabel.text = model.title;
        cell.singerLabel.text = model.artistName;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VchartModel* model = ((NSMutableArray*)_dataArray[_selectBtn])[indexPath.row];
    MVPlayViewController* vc = [[MVPlayViewController alloc]init];
    vc.title = model.title;
    vc.ID = model.id;
    vc.urlString = model.url;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)btnClick1:(UIButton*)btn
{
    _selectBtn = btn.tag-100;
    NSArray* array = @[JPurl,USurl,MLurl,KRurl,HTurl];
    for (UIButton* sender in btn.superview.subviews) {
        if ([sender isKindOfClass:[UIButton class]]) {
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    NSString* urlString = [NSString stringWithFormat:@"%@%@",array[btn.tag-100],Info];
//    [_request startRequestWithURLString:urlString andTarget:self andCallBack:@selector(finishLoad:)];
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:urlString success:^(SWLRequest *request, NSData *data) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray* array = dic[@"videos"];
        [(NSMutableArray*)_dataArray[_selectBtn] removeAllObjects];
        for (NSDictionary* Dic in array) {
            VchartModel* model = [[VchartModel alloc]init];
            [model setValuesForKeysWithDictionary:Dic];
            [(NSMutableArray*)_dataArray[_selectBtn] addObject:model];
        }
        [_tableView reloadData];
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
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
