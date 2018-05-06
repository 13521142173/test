//
//  MVPlayViewController.m
//  Music
//
//  Created by qianfeng on 15-4-2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MVPlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "SWLHTTPRequest.h"
#import "Define.h"
#import "MVDetailModel.h"
#import "CustomModel.h"
#import "NewDesCell.h"
#import "RelativeMVCell.h"
#import "Manager.h"
#import "DownLoad.h"
#import "SWLRequestManager.h"
#import "DownLoadViewController.h"
#import "UMSocial.h"


@interface MVPlayViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UISegmentedControl* _seg;
    UITableView* _tableView;
    NSMutableArray* _tableSource;
    //SWLHTTPRequest* _request1;
    NSMutableArray* _dataArray;
    NSMutableArray* _desArr;
    MPMoviePlayerViewController* _vc;
    NSDictionary* _dic;
    NSArray* introduceArr;
    UIButton* _btn;
 
    NSMutableArray* downArr;
}

@end

@implementation MVPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideTabBar];
    
    downArr = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _desArr = [[NSMutableArray alloc]init];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    [titleLabel setText:self.title];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(0, 0, 40, 40);
    _btn.userInteractionEnabled = NO;
    if ([[Manager shared]isExists:self.ID]) {
        [_btn setImage:[UIImage imageNamed:@"DetailBottomBar_Fav_Sel"] forState:UIControlStateNormal];
    }else{
        [_btn setImage:[UIImage imageNamed:@"DetailBottomBar_Fav"] forState:UIControlStateNormal];
    }
    [_btn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_btn];
    
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"back_btn@2x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    [self createMediaPlayer];
    [self createSegController];
    [self createTableView];
    
//    _request1 = [[SWLHTTPRequest alloc]init];
    NSString* urlString = [NSString stringWithFormat:showString,self.ID];
//    [_request1 startRequestWithURLString:[NSString stringWithFormat:@"%@%@",urlString,Info] andTarget:self andCallBack:@selector(finishRequest1:)];
    [self requestDataWithNSString:[NSString stringWithFormat:@"%@%@",urlString,Info]];
    UIButton* shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake((WIDTH/2-165)/2, HEIGHT/2+10, 25, 25)];
    [shareBtn setBackgroundColor:[UIColor colorWithRed:0.847 green:0.106 blue:0.149 alpha:1]];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.layer.cornerRadius = 12;
    shareBtn.layer.masksToBounds = YES;
    [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [shareBtn addTarget:self action:@selector(shareActioned:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    UIButton* downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn setFrame:CGRectMake(WIDTH-25-((WIDTH/2-165)/2), HEIGHT/2+10, 25, 25)];
    [downloadBtn setBackgroundColor:[UIColor colorWithRed:0.847 green:0.106 blue:0.149 alpha:1]];
    downloadBtn.layer.cornerRadius = 12;
    downloadBtn.layer.masksToBounds = YES;
    [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downloadBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [downloadBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadBtn];
    
}

- (void)shareActioned:(UIButton*)btn
{
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_dic[@"posterPic"]]]];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMAPPKEY shareText:@"好看的MV"shareImage:image shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToSina,UMShareToQzone,UMShareToRenren,nil] delegate:nil];
}
- (void)downloadAction:(UIButton*)btn
{
    if (![[DownLoad download]isExists:self.ID]) {
        [[DownLoad download]inserDataWithId:self.ID artistName:_dic[@"artistName"] title:_dic[@"title"] imageName:_dic[@"posterPic"] urlString:_dic[@"url"]];
    }else{
        [[DownLoad download] deleteDataWith:self.ID];
    }
    
    
}

- (void)requestDataWithNSString:(NSString*)urlString
{
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:urlString success:^(SWLRequest *request, NSData *data) {
        _dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@\n%@",self.ID,_dic);
        NSArray* array = _dic[@"relatedVideos"];
        [_dataArray removeAllObjects];
        for (NSDictionary* smallDic in array) {
            CustomModel* customModel = [[CustomModel alloc]init];
            [customModel setValuesForKeysWithDictionary:smallDic];
            [_dataArray addObject:customModel];
        }
        MVDetailModel* model = [[MVDetailModel alloc]init];
        model.title = _dic[@"title"];
        model.regdate = _dic[@"regdate"];
        model.totalviews = _dic[@"totalviews"];
        [_desArr removeAllObjects];
        [_desArr addObject:model];
        
        [_tableView reloadData];
        
        _btn.userInteractionEnabled = YES;
        [manager removeRequest:request];
    } failed:^(SWLRequest *request) {
        NSLog(@"失败");
        [manager removeRequest:request];
    }];
}

//- (void)finishRequest1:(SWLHTTPRequest*)request
//{
//    _dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"%@\n%@",self.ID,_dic);
//    NSArray* array = _dic[@"relatedVideos"];
//    [_dataArray removeAllObjects];
//    for (NSDictionary* smallDic in array) {
//        CustomModel* customModel = [[CustomModel alloc]init];
//        [customModel setValuesForKeysWithDictionary:smallDic];
//        [_dataArray addObject:customModel];
//    }
//    MVDetailModel* model = [[MVDetailModel alloc]init];
//    model.title = _dic[@"title"];
//    model.regdate = _dic[@"regdate"];
//    model.totalviews = _dic[@"totalviews"];
//    [_desArr removeAllObjects];
//    [_desArr addObject:model];
//    
//    [_tableView reloadData];
//    
//    _btn.userInteractionEnabled = YES;
//}

- (void)createSegController
{
    introduceArr = @[@"MV描述",@"相关MV"];
    _seg = [[UISegmentedControl alloc]initWithItems:introduceArr];
    [_seg setFrame:CGRectMake(WIDTH/2-140, HEIGHT/2+10, 280, 25)];
    [_seg setSelectedSegmentIndex:0];
    [_seg addTarget:self action:@selector(segValueChanged:) forControlEvents:UIControlEventValueChanged];
    _seg.tintColor = [UIColor colorWithRed:0.847 green:0.106 blue:0.149 alpha:1];
    [self.view addSubview:_seg];
    
    //[self createTableView];
}

- (void)createMediaPlayer
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/2)];
    [self.view addSubview:view];
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

- (void)shareAction:(UIButton*)btn
{
    if (![[Manager shared]isExists:self.ID]) {
        //数据库
        [[Manager shared]inserDataWithId:self.ID artistName:[_dic objectForKey:@"artistName"]  title:self.title imageName:[_dic objectForKey:@"posterPic"]];
        [_btn setImage:[UIImage imageNamed:@"DetailBottomBar_Fav_Sel"] forState:UIControlStateNormal];
    }else{
        [[Manager shared] deleteDataWith:self.ID];
        [_btn setImage:[UIImage imageNamed:@"DetailBottomBar_Fav"] forState:UIControlStateNormal];
    }
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
            cell.upDateLabel.text = _dic[@"regdate"];
            cell.playCount.text = [NSString stringWithFormat:@"播放次数：%@",_dic[@"totalViews"]];
            cell.myTextLabel.text = _dic[@"description"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }else{
        RelativeMVCell* cell = [tableView dequeueReusableCellWithIdentifier:@"relativemvcell" forIndexPath:indexPath];
        if (_dataArray.count>0) {
            CustomModel* customModel = _dataArray[indexPath.row];
            cell.headImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:customModel.posterPic]]];
            cell.songLabel.text = customModel.title;
            cell.singerLabel.text = customModel.artistName;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_seg.selectedSegmentIndex == 0) {
        return;
    }
    _seg.selectedSegmentIndex = 0;
    CustomModel* model = _dataArray[indexPath.row];
    self.ID = model.id;
    self.title = model.title;
    self.urlString = model.url;
    
//    SWLHTTPRequest* request2 = [[SWLHTTPRequest alloc]init];
    NSMutableString* urlString = [NSMutableString stringWithFormat:showString,self.ID];
    [urlString appendString:Info];
//    [request2 startRequestWithURLString:urlString andTarget:self andCallBack:@selector(finishRequest1:)];
    [self requestDataWithNSString:urlString];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    [titleLabel setText:self.title];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
    
    //[self setItemWithImageName:@"DetailBottomBar_Fav@2x" andTarget:self andAction:@selector(shareAction)];
    
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
