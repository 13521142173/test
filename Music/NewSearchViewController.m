//
//  NewSearchViewController.m
//  Music
//
//  Created by qianfeng on 15-4-9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "NewSearchViewController.h"
//#import "SWLHTTPRequest.h"
#import "RelativeMVCell.h"
#import "CustomModel.h"
#import "Define.h"
#import "MVPlayViewController.h"
#import "SWLRequestManager.h"
#import "MJRefresh.h"

@interface NewSearchViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar* _searchBar;
    UIButton* _searchBtn;
    UITableView* _tableView;
    NSMutableArray* _tableSource;
    UIView* _noDataView;
    NSString* _searchText;
    NSInteger _offset;
}

@end

@implementation NewSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _offset = 20;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    [titleLabel setText:@"搜索"];
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
    
    UIView* searchBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 40)];
    searchBarView.backgroundColor = [UIColor blackColor];
    searchBarView.userInteractionEnabled = YES;
    [self.view addSubview:searchBarView];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 64, WIDTH-60, 40)];
    _searchBar.barTintColor = [UIColor blackColor];
    _searchBar.placeholder = @"请输入歌名或者歌手";
    [self.view addSubview:_searchBar];
//    _searchBar.keyboardAppearance = UIKeyboardAppearanceDefault;
//    _searchBar.keyboardType = UIKeyboardTypeDefault;
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchBtn setFrame:CGRectMake(WIDTH-50, 64, 40, 40)];
    [_searchBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchBtn];
    

    for (int i = 0; i < 20; i ++) {
        
        UIButton* btn = (UIButton*)[self.view viewWithTag:10+i];
        
        [btn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"RelativeMVCell" bundle:nil] forCellReuseIdentifier:@"relativemvcell"];
    _tableSource = [[NSMutableArray alloc]init];
    [self.view sendSubviewToBack:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, WIDTH, HEIGHT-104) ];
    _noDataView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-80, 40, 160, 160)];
    imageView.image = [UIImage imageNamed:@"Search_NoData@2x"];
    [_noDataView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-130, 220, 260, 40)];
    label.text = @"抱歉，您的筛选条件暂无结果，建议您重新输入";
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 2;
    [_noDataView addSubview:label];
    [self.view addSubview:_noDataView];
    [self.view sendSubviewToBack:_noDataView];
}

- (void)headerRefreshing
{
    NSMutableString* urlString = [[NSMutableString alloc]initWithFormat:SearchString,_searchText];
    [urlString appendString:Info];
    _offset = 20;
    [self requestDataWith:urlString];
    [_tableView headerEndRefreshing];
}
- (void)footerRefreshing
{
    NSMutableString* urlString = [[NSMutableString alloc]initWithFormat:SearchMore,(long)_offset,_searchText];
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
        if (array.count>0) {
            _offset += 20;
            [_tableView reloadData];
            [_tableView footerEndRefreshing];
        }
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
}

- (void)btnPress:(UIButton*)btn
{
    NSString* str = [btn.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _searchText = str;
    NSMutableString* urlString = [NSMutableString stringWithFormat:SearchString,str];
    [urlString appendString:Info];
//    SWLHTTPRequest* request = [[SWLHTTPRequest alloc]init];
//    [request startRequestWithURLString:urlString andTarget:self andCallBack:@selector(finishedLoad:)];
    [self requestDataWith:urlString];
    
}


- (void)btnClick
{
    if (_searchBar.text.length == 0) {
        UIAlertView* al = [[UIAlertView alloc]initWithTitle:@"输入错误" message:@"输入内容不能为空" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [al show];
        //[_searchBar becomeFirstResponder];
        return ;
    }
    //[_tableSource removeAllObjects];
    NSString* str = [_searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _searchText = str;
    NSMutableString* urlString = [NSMutableString stringWithFormat:SearchString,str];
    [urlString appendString:Info];
//    SWLHTTPRequest* request = [[SWLHTTPRequest alloc]init];
//    [request startRequestWithURLString:urlString andTarget:self andCallBack:@selector(finishedLoad:)];
    [self requestDataWith:urlString];
    
}

- (void)requestDataWith:(NSString*)urlString
{
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
        if (_tableSource.count == 0) {
            [self.view bringSubviewToFront:_noDataView];
        }else{
            [self.view bringSubviewToFront:_tableView];
            [_tableView reloadData];
        }
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
}

//- (void)finishedLoad:(SWLHTTPRequest*)request
//{
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    NSArray* array = dic[@"videos"];
//    [_tableSource removeAllObjects];
//    for (NSDictionary* arrDic in array) {
//        CustomModel* model = [[CustomModel alloc]init];
//        [model setValuesForKeysWithDictionary:arrDic];
//        [_tableSource addObject:model];
//    }
//    if (_tableSource.count == 0) {
//        [self.view bringSubviewToFront:_noDataView];
//    }else{
//        [self.view bringSubviewToFront:_tableView];
//        [_tableView reloadData];
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableSource.count == 0) {
        return 0;
    }
    return _tableSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RelativeMVCell* cell = [tableView dequeueReusableCellWithIdentifier:@"relativemvcell" forIndexPath:indexPath];
    CustomModel* model = _tableSource[indexPath.row];
    cell.headImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.posterPic]]];
    cell.songLabel.text = model.title;
    cell.singerLabel.text = model.artistName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomModel* model = _tableSource[indexPath.row];
    MVPlayViewController* vc = [[MVPlayViewController alloc]init];
    vc.ID = model.id;
    vc.title = model.title;
    vc.urlString = model.url;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.view endEditing:NO];
    return YES;
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
