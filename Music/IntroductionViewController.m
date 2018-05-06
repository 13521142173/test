//
//  IntroductionViewController.m
//  Music
//
//  Created by qianfeng on 15-4-6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "IntroductionViewController.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "SWLHTTPRequest.h"
#import "Define.h"
#import "IndexModel.h"
#import "NewDesCell.h"
#import "RelativeMVCell.h"
#import "SWLRequestManager.h"


@interface IntroductionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UISegmentedControl* _seg;
    UITableView* _tableView;
    NSMutableArray* _tableSource;
   // SWLHTTPRequest* _request1;
    NSMutableArray* _dataArray;
    NSMutableArray* _desArr;
    MPMoviePlayerViewController* _vc;
    NSDictionary* _dic;
    NSArray* introduceArr;
    
}

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideTabBar];
    
    _dataArray = [[NSMutableArray alloc]init];
    _desArr = [[NSMutableArray alloc]init];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    [titleLabel setText:self.title];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
    
//    [self setItemWithImageName:@"DetailBottomBar_Fav@2x" andTarget:self andAction:@selector(shareAction)];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"back_btn@2x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
//    _request1 = [[SWLHTTPRequest alloc]init];
    NSString* urlString = [NSString stringWithFormat:PlaylistString,self.ID];
//    [_request1 startRequestWithURLString:[NSString stringWithFormat:@"%@%@",urlString,Info] andTarget:self andCallBack:@selector(finishRequest1:)];
    [self requestDataWith:[NSString stringWithFormat:@"%@%@",urlString,Info]];
    
    //[self createMediaPlayer];
    [self createSegController];
    [self createTableView];
}

- (void)requestDataWith:(NSString*)url
{
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:url success:^(SWLRequest *request, NSData *data) {
        _dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray* array = _dic[@"videos"];
        [_dataArray removeAllObjects];
        for (NSDictionary* smallDic in array) {
            IndexModel* model = [[IndexModel alloc]init];
            [model setValuesForKeysWithDictionary:smallDic];
            [_dataArray addObject:model];
        }
        
        [_tableView reloadData];
        [self createMediaPlayer];
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
}

//- (void)finishRequest1:(SWLHTTPRequest*)request
//{
//    _dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    NSArray* array = _dic[@"videos"];
//    [_dataArray removeAllObjects];
//    for (NSDictionary* smallDic in array) {
//        IndexModel* model = [[IndexModel alloc]init];
//        [model setValuesForKeysWithDictionary:smallDic];
//        [_dataArray addObject:model];
//    }
//    
//    [_tableView reloadData];
//    [self createMediaPlayer];
//}

- (void)createSegController
{
    introduceArr = @[@"推荐描述",@"推荐列表"];
    _seg = [[UISegmentedControl alloc]initWithItems:introduceArr];
    [_seg setFrame:CGRectMake(WIDTH/2-140, HEIGHT/2+10, 280, 25)];
    [_seg setSelectedSegmentIndex:0];
    [_seg addTarget:self action:@selector(segValueChanged:) forControlEvents:UIControlEventValueChanged];
    _seg.tintColor = [UIColor colorWithRed:0.847 green:0.106 blue:0.149 alpha:1];
    [self.view addSubview:_seg];
}

- (void)createMediaPlayer
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/2)];
    [self.view addSubview:view];
    IndexModel* model = _dataArray[0];
    self.urlString = model.url;
    _vc = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:self.urlString]];
    _vc.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [_vc.moviePlayer prepareToPlay];
    [_vc.moviePlayer play];
    _vc.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT/2);
    _vc.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
    _vc.view.tag = 10;
    [view addSubview:_vc.view];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playBack) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
}

- (void)playBack
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    if (_vc) {
        [_vc.moviePlayer stop];
        _vc = nil;
    }
}
- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, HEIGHT/2+45, WIDTH, HEIGHT/2-45) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    UINib* nib1 = [UINib nibWithNibName:@"NewDesCell" bundle:nil];
    [_tableView registerNib:nib1 forCellReuseIdentifier:@"newdescell"];
    UINib* nib2 = [UINib nibWithNibName:@"RelativeMVCell" bundle:nil];
    [_tableView registerNib:nib2 forCellReuseIdentifier:@"relativemvcell"];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction
{
    
}
- (void)segValueChanged:(UISegmentedControl*)seg
{
    [_tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_seg.selectedSegmentIndex == 0) {
        return 300;
    }else{
        return 80;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_seg.selectedSegmentIndex == 0) {
        return 1;
    }else{
        
        return _dataArray.count;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_seg.selectedSegmentIndex == 0) {
        NewDesCell* cell = [tableView dequeueReusableCellWithIdentifier:@"newdescell" forIndexPath:indexPath];
        
        if (_dataArray.count>0) {
            cell.titleLabel.text = _dic[@"title"];
            cell.upDateLabel.text = _dic[@"updateTime"];
            cell.playCount.text = [NSString stringWithFormat:@"播放次数：%@",_dic[@"totalViews"]];
            cell.myTextLabel.text = _dic[@"description"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }else{
        RelativeMVCell* cell = [tableView dequeueReusableCellWithIdentifier:@"relativemvcell" forIndexPath:indexPath];
        if (_dataArray.count>0) {
            IndexModel* model = _dataArray[indexPath.row];
            cell.headImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.posterPic]]];
            cell.songLabel.text = model.title;
            cell.singerLabel.text = model.artistName;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_seg.selectedSegmentIndex == 0) {
        return;
    }
   // _seg.selectedSegmentIndex = 0;
    IndexModel* model = _dataArray[indexPath.row];
    _vc.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
    [_vc.moviePlayer setContentURL:[NSURL URLWithString:model.url]];
    [_vc.moviePlayer prepareToPlay];
    [_vc.moviePlayer play];
    
    
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
