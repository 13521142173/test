//
//  IndexViewController.m
//  Music
//
//  Created by qianfeng on 15-3-31.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "IndexViewController.h"
#import "ReIndexCell.h"
#import "Define.h"
//#import "SWLHTTPRequest.h"
#import "HuaDongModel.h"
#import "IndexModel.h"
#import "HelpViewController.h"
#import "NewSearchViewController.h"
#import "MVPlayViewController.h"
#import "SWLRequestManager.h"

@interface IndexViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _tableSource;
    UIScrollView* _scroll;
    UILabel* _titleLabel;
    UILabel* _singerLabel;
    
    NSMutableArray* _huaDongArr;
    NSMutableArray* _desArr;
    NSMutableArray* _shouBoArr;
    NSMutableArray* _liuXingArr;
    NSMutableArray* _reBoArr;
    
//    SWLHTTPRequest* request1;
//    SWLHTTPRequest* request2;
//    SWLHTTPRequest* request3;
//    SWLHTTPRequest* request4;
    
    int currentIndex;
    NSArray* tableArr;
    
}

@end

@implementation IndexViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self showTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _huaDongArr = [[NSMutableArray alloc]init];
    _desArr = [[NSMutableArray alloc]init];
    _shouBoArr = [[NSMutableArray alloc]init];
    _liuXingArr = [[NSMutableArray alloc]init];
    _reBoArr = [[NSMutableArray alloc]init];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    [titleLabel setText:@"首页"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
    
    [self setItemsWithImageName1:@"Moive_Share_Pengyouquan" andTarget1:self andAction1:@selector(rightItemClick) andImageName2:@"Search" andTarget2:self andAction:@selector(searchClick)];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height-64-30) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.bounces = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableSource = [[NSMutableArray alloc]init];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ReIndexCell" bundle:nil] forCellReuseIdentifier:@"reindexcell"];
    
//    request1 = [[SWLHTTPRequest alloc]init];
//    [request1 startRequestWithURLString:[NSString stringWithFormat:@"%@%@",HuaDongString,Info] andTarget:self andCallBack:@selector(finishedLoad1:)];
//    request2 = [[SWLHTTPRequest alloc]init];
//    [request2 startRequestWithURLString:[NSString stringWithFormat:@"%@%@",ShouBoString,Info] andTarget:self andCallBack:@selector(finishedLoad2:)];
//    request3 = [[SWLHTTPRequest alloc]init];
//    [request3 startRequestWithURLString:[NSString stringWithFormat:@"%@%@",LiuXingString,Info] andTarget:self andCallBack:@selector(finishedLoad3:)];
//    request4 = [[SWLHTTPRequest alloc]init];
//    [request4 startRequestWithURLString:[NSString stringWithFormat:@"%@%@",ReBoString,Info] andTarget:self andCallBack:@selector(finishedLoad4:)];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
    _scroll.tag = 6;
    [_scroll setContentOffset:CGPointMake(0, 0)];
    [_scroll setContentSize:CGSizeMake(self.view.frame.size.width*4, 240)];
    [_scroll setPagingEnabled:YES];
    [_scroll setShowsHorizontalScrollIndicator:NO];
    [_scroll setBounces:NO];
    _scroll.delegate = self;
    [_tableView setTableHeaderView:_scroll];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_scroll addGestureRecognizer:tap];
    
    for (int i = 0; i < 4; i ++) {
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, 240)];
        imageView.tag = 10+i;
        imageView.image = [UIImage imageNamed:@"photoDefault"];
        [_scroll addSubview:imageView];
        
    }
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 60)];
    backView.backgroundColor = [UIColor blackColor];
    [backView setAlpha:0.5];
    [_tableView addSubview:backView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 180, 150, 30)];
    _titleLabel.textColor = [UIColor whiteColor];
    [_tableView addSubview:_titleLabel];
    
    _singerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, 150, 30)];
    _singerLabel.textColor = [UIColor redColor];
    [_tableView addSubview:_singerLabel];
    
    UIPageControl* pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, 210, 160, 30)];
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    pageControl.tag = 5;
    [_tableView addSubview:pageControl];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(270, 190, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"PlayMovie"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:btn];
    
    UIImageView* shouBo = [[UIImageView alloc]initWithFrame:CGRectMake(50, 140, 40, 40)];
    shouBo.image = [UIImage imageNamed:@"HomePagePlay"];
    [_tableView addSubview:shouBo];
    
    [self requestData];
}

- (void)requestData
{
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:[NSString stringWithFormat:@"%@%@",HuaDongString,Info] success:^(SWLRequest *request, NSData *data) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary* dic in array) {
            HuaDongModel* model = [[HuaDongModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            if ([dic[@"type"] isEqualToString:@"VIDEO"]) {
                [_huaDongArr addObject:model];
                [_desArr addObject:dic[@"description"]];
            }
        }
        [self updateScrollUI];
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
    
    [manager addGETMissionWithURL:[NSString stringWithFormat:@"%@%@",ShouBoString,Info] success:^(SWLRequest *request, NSData *data) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary* arr in dic[@"videos"]) {
            IndexModel* model = [[IndexModel alloc]init];
            [model setValuesForKeysWithDictionary:arr];
            [_shouBoArr addObject:model];
        }
        [_tableSource addObject:_shouBoArr];
        [_tableView reloadData];
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
    
    [manager addGETMissionWithURL:[NSString stringWithFormat:@"%@%@",LiuXingString,Info] success:^(SWLRequest *request, NSData *data) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary* arr in dic[@"videos"]) {
            IndexModel* model = [[IndexModel alloc]init];
            [model setValuesForKeysWithDictionary:arr];
            [_liuXingArr addObject:model];
        }
        [_tableSource addObject:_liuXingArr];
        [_tableView reloadData];
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
    
    [manager addGETMissionWithURL:[NSString stringWithFormat:@"%@%@",ReBoString,Info] success:^(SWLRequest *request, NSData *data) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary* arr in dic[@"videos"]) {
            IndexModel* model = [[IndexModel alloc]init];
            [model setValuesForKeysWithDictionary:arr];
            [_reBoArr addObject:model];
        }
        [_tableSource addObject:_reBoArr];
        [_tableView reloadData];
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
    
    [_tableView reloadData];
    
}

//- (void)finishedLoad4:(SWLHTTPRequest*)request
//{
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    for (NSDictionary* arr in dic[@"videos"]) {
//        IndexModel* model = [[IndexModel alloc]init];
//        [model setValuesForKeysWithDictionary:arr];
//        [_reBoArr addObject:model];
//    }
//    [_tableSource addObject:_reBoArr];
//    [_tableView reloadData];
//}
//
//- (void)finishedLoad3:(SWLHTTPRequest*)request
//{
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    for (NSDictionary* arr in dic[@"videos"]) {
//        IndexModel* model = [[IndexModel alloc]init];
//        [model setValuesForKeysWithDictionary:arr];
//        [_liuXingArr addObject:model];
//    }
//    [_tableSource addObject:_liuXingArr];
//    [_tableView reloadData];
//}
//
//- (void)finishedLoad2:(SWLHTTPRequest*)request
//{
//   NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    for (NSDictionary* arr in dic[@"videos"]) {
//        IndexModel* model = [[IndexModel alloc]init];
//        [model setValuesForKeysWithDictionary:arr];
//        [_shouBoArr addObject:model];
//    }
//    [_tableSource addObject:_shouBoArr];
//    [_tableView reloadData];
//}
//
//- (void)finishedLoad1:(SWLHTTPRequest*)request
//{
//    NSArray* array = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    for (NSDictionary* dic in array) {
//        HuaDongModel* model = [[HuaDongModel alloc]init];
//        [model setValuesForKeysWithDictionary:dic];
//        if ([dic[@"type"] isEqualToString:@"VIDEO"]) {
//            [_huaDongArr addObject:model];
//            [_desArr addObject:dic[@"description"]];
//        }
//    }
//    [self updateScrollUI];
//}

- (void)updateScrollUI
{
    for (int i = 0; i < _huaDongArr.count; i ++) {
        HuaDongModel* model = _huaDongArr[i];
        UIImageView* imageView = (UIImageView*)[self.view viewWithTag:10+i];
        imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.posterPic]]];
        if (i == 0) {
            _titleLabel.text = model.title;
            _singerLabel.text = _desArr[i];
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReIndexCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reindexcell" forIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    
    if (_tableSource.count == 3) {
        
        NSArray* array = _tableSource[section];
        for (int i = 0; i < array.count; i ++) {
            IndexModel* model = array[i];
            if (i == 0) {
                cell.firstImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.posterPic]]];
                cell.firstImage.userInteractionEnabled = YES;
                cell.firstImage.tag = 100*(section+1)+i;
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)];
                [cell.firstImage addGestureRecognizer:tap];
                cell.firstSinger.text = model.artistName;
                cell.des1.text = model.promoTitle;
            }else if (i == 1){
                cell.secondImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.posterPic]]];
                cell.secondImage.userInteractionEnabled = YES;
                cell.secondImage.tag = 100*(section+1)+i;
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)];
                [cell.secondImage addGestureRecognizer:tap];
                cell.secondSinger.text = model.artistName;
                cell.des2.text = model.promoTitle;
            }else if (i == 2){
                cell.thirdImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.posterPic]]];
                cell.thirdImage.userInteractionEnabled = YES;
                cell.thirdImage.tag = 100*(section+1)+i;
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)];
                [cell.thirdImage addGestureRecognizer:tap];
                cell.thirdSinger.text = model.artistName;
                cell.des3.text = model.promoTitle;
            
            }else if (i == 3){
                cell.fourthImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.posterPic]]];
                cell.fourthImage.userInteractionEnabled = YES;
                cell.fourthImage.tag = 100*(section+1)+i;
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)];
                [cell.fourthImage addGestureRecognizer:tap];
                cell.fourthSinger.text = model.artistName;
                cell.des4.text = model.promoTitle;
            
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray* array = @[@"MV首播",@"正在流行",@"今日热播"];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    label.text = array[section];
    label.textColor = [UIColor blackColor];
    [label setFont:[UIFont systemFontOfSize:20]];
    return label;
    
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        CGPoint point = scrollView.contentOffset;
        UIPageControl* pageControl = (UIPageControl*)[self.view viewWithTag:5];
        pageControl.currentPage = point.x/scrollView.frame.size.width;
//        UIScrollView* scrollView = (UIScrollView*)[self.view viewWithTag:6];
        // 获取当前是第几张图片
        currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        HuaDongModel* model = _huaDongArr[currentIndex];
        _titleLabel.text = model.title;
        _singerLabel.text = _desArr[currentIndex];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    UIPageControl* pageControl = (UIPageControl*)[self.view viewWithTag:5];
    pageControl.currentPage = point.x/scrollView.frame.size.width;
//    UIScrollView* scrollView = (UIScrollView*)[self.view viewWithTag:6];
    // 获取当前是第几张图片
    currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    HuaDongModel* model = _huaDongArr[currentIndex];
    _titleLabel.text = model.title;
    _singerLabel.text = _desArr[currentIndex];
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

- (void)btnClick:(UIButton*)btn
{
    HuaDongModel* model = _huaDongArr[currentIndex];
    MVPlayViewController* detailVC = [[MVPlayViewController alloc]init];
    detailVC.urlString = model.url;
    detailVC.title = model.title;
    detailVC.ID = model.id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)tapAction:(UITapGestureRecognizer*)tap
{
    HuaDongModel* model = _huaDongArr[currentIndex];
    MVPlayViewController* detailVC = [[MVPlayViewController alloc]init];
    detailVC.urlString = model.url;
    detailVC.title = model.title;
    detailVC.ID = model.id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tapPress:(UITapGestureRecognizer*)tap
{
    NSArray* array = _tableSource[tap.view.tag/100-1];
    IndexModel* model = array[tap.view.tag%100];
    MVPlayViewController* detailVC = [[MVPlayViewController alloc]init];
    detailVC.urlString = model.url;
    detailVC.title = model.title;
    detailVC.ID = model.id;
    [self.navigationController pushViewController:detailVC animated:YES];
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
