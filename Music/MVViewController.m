//
//  MVViewController.m
//  Music
//
//  Created by qianfeng on 15-3-31.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MVViewController.h"
#import "HelpViewController.h"
#import "NewSearchViewController.h"
//#import "SWLHTTPRequest.h"
#import "Define.h"
#import "MVCell1.h"
#import "MVCell2.h"
#import "MVCell3.h"
#import "MVCell4.h"
#import "FenLeiModel.h"
#import "MVDetailViewController.h"
#import "SWLRequestManager.h"

@interface MVViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _tableSource;

}

@end

@implementation MVViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self showTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 35)];
    [titleLabel setText:@"分类"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
    
    [self setItemsWithImageName1:@"Moive_Share_Pengyouquan" andTarget1:self andAction1:@selector(rightItemClick) andImageName2:@"Search" andTarget2:self andAction:@selector(searchClick)];
    
//    SWLHTTPRequest* request = [[SWLHTTPRequest alloc]init];
//    [request startRequestWithURLString:[NSString stringWithFormat:@"%@%@",FenLeiString,Info] andTarget:self andCallBack:@selector(finishLoad:)];
    [self requestData];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableSource = [[NSMutableArray alloc]init];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MVCell1" bundle:nil] forCellReuseIdentifier:@"mvcell1"];
    [_tableView registerNib:[UINib nibWithNibName:@"MVCell2" bundle:nil] forCellReuseIdentifier:@"mvcell2"];
    [_tableView registerNib:[UINib nibWithNibName:@"MVCell3" bundle:nil] forCellReuseIdentifier:@"mvcell3"];
    [_tableView registerNib:[UINib nibWithNibName:@"MVCell4" bundle:nil] forCellReuseIdentifier:@"mvcell4"];
}

- (void)requestData
{
    __weak SWLRequestManager* manager = [SWLRequestManager manager];
    [manager addGETMissionWithURL:[NSString stringWithFormat:@"%@%@",FenLeiString,Info] success:^(SWLRequest *request, NSData *data) {
        NSDictionary* dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray* array = dic[@"data"];
        for (NSDictionary* arrDic in array) {
            FenLeiModel* model = [[FenLeiModel alloc]init];
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
//    NSDictionary* dic =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    NSArray* array = dic[@"data"];
//    for (NSDictionary* arrDic in array) {
//        FenLeiModel* model = [[FenLeiModel alloc]init];
//        [model setValuesForKeysWithDictionary:arrDic];
//        [_tableSource addObject:model];
//    }
//    [_tableView reloadData];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableSource.count == 0) {
        return 0;
    }else{
        return 10;
    }
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0||indexPath.row == 6) {
        MVCell1* cell = [tableView dequeueReusableCellWithIdentifier:@"mvcell1" forIndexPath:indexPath];
    
        if (_tableSource.count>0) {
            FenLeiModel* model1 = [[FenLeiModel alloc]init];
            FenLeiModel* model2 = [[FenLeiModel alloc]init];
            if (indexPath.row == 0) {
                model1 = _tableSource[0];
                model2 = _tableSource[1];
                cell.oneImage.tag = 100;
                cell.twoImage.tag = 100+1;
            }else{
                model1 = _tableSource[15];
                model2 = _tableSource[16];
                cell.oneImage.tag = 100+15;
                cell.twoImage.tag = 100+16;
            }
            UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            cell.oneImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model1.img]]];
            cell.oneImage.userInteractionEnabled = YES;
            [cell.oneImage addGestureRecognizer:tap1];
            cell.oneTitle.text = model1.title;
            
            cell.twoImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model2.img]]];
            cell.twoImage.userInteractionEnabled = YES;
            [cell.twoImage addGestureRecognizer:tap2];
            cell.twoTitle.text = model2.title;
        }
        return cell;
    }else if (indexPath.row == 1||indexPath.row == 3||indexPath.row == 5||indexPath.row == 7||indexPath.row == 9){
        MVCell2* cell = [tableView dequeueReusableCellWithIdentifier:@"mvcell2" forIndexPath:indexPath];
        if (_tableSource.count>0) {
            FenLeiModel* model1 = [[FenLeiModel alloc]init];
            FenLeiModel* model2 = [[FenLeiModel alloc]init];
            FenLeiModel* model3 = [[FenLeiModel alloc]init];
            UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            UITapGestureRecognizer* tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            if (indexPath.row == 1) {
                model1 = _tableSource[2];
                model2 = _tableSource[3];
                model3 = _tableSource[4];
                cell.oneImage.tag = 100+2;
                cell.twoImage.tag = 100+3;
                cell.threeImage.tag = 100+4;
                
            }else if (indexPath.row == 3){
                model1 = _tableSource[7];
                model2 = _tableSource[8];
                model3 = _tableSource[9];
                cell.oneImage.tag = 100+7;
                cell.twoImage.tag = 100+8;
                cell.threeImage.tag = 100+9;
            }else if(indexPath.row == 5){
                model1 = _tableSource[12];
                model2 = _tableSource[13];
                model3 = _tableSource[14];
                cell.oneImage.tag = 100+12;
                cell.twoImage.tag = 100+13;
                cell.threeImage.tag = 100+14;
            }else if (indexPath.row == 7){
                model1 = _tableSource[17];
                model2 = _tableSource[18];
                model3 = _tableSource[19];
                cell.oneImage.tag = 100+17;
                cell.twoImage.tag = 100+18;
                cell.threeImage.tag = 100+19;
            }
            else if (indexPath.row == 9){
                model1 = _tableSource[22];
                model2 = _tableSource[23];
                model3 = _tableSource[24];
                cell.oneImage.tag = 100+22;
                cell.twoImage.tag = 100+23;
                cell.threeImage.tag = 100+24;
            }
            cell.oneImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model1.img]]];
            cell.oneImage.userInteractionEnabled = YES;
            [cell.oneImage addGestureRecognizer:tap1];
            cell.oneTitle.text = model1.title;
            cell.twoImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model2.img]]];
            cell.twoImage.userInteractionEnabled = YES;
            [cell.twoImage addGestureRecognizer:tap2];
            cell.twoTitle.text = model2.title;
            cell.threeImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model3.img]]];
            cell.threeImage.userInteractionEnabled = YES;
            [cell.threeImage addGestureRecognizer:tap3];
            cell.threeTitle.text = model3.title;
        }
        return cell;
    }else if (indexPath.row == 2||indexPath.row == 8){
        MVCell3* cell = [tableView dequeueReusableCellWithIdentifier:@"mvcell3" forIndexPath:indexPath];
        if (_tableSource.count>0) {
            FenLeiModel* model1 = [[FenLeiModel alloc]init];
            FenLeiModel* model2 = [[FenLeiModel alloc]init];
            UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            if (indexPath.row == 2) {
                model1 = _tableSource[5];
                model2 = _tableSource[6];
                cell.oneImage.tag = 100+5;
                cell.twoImage.tag = 100+6;
            }else{
                model1 = _tableSource[20];
                model2 = _tableSource[21];
                cell.oneImage.tag = 100+15;
                cell.twoImage.tag = 100+16;
            }
            cell.oneImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model1.img]]];
            cell.oneImage.userInteractionEnabled = YES;
            [cell.oneImage addGestureRecognizer:tap1];
            cell.oneTitle.text = model1.title;
            cell.twoImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model2.img]]];
            cell.twoImage.userInteractionEnabled = YES;
            [cell.twoImage addGestureRecognizer:tap2];
            cell.twoTitle.text = model2.title;
        }
        return cell;
    }else{
        MVCell4* cell = [tableView dequeueReusableCellWithIdentifier:@"mvcell4" forIndexPath:indexPath];
        if (_tableSource.count>0) {
            FenLeiModel* model1 = _tableSource[10];
            FenLeiModel* model2 = _tableSource[11];
            UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            cell.oneImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model1.img]]];
            cell.oneImage.userInteractionEnabled = YES;
            cell.oneImage.tag = 100+10;
            [cell.oneImage addGestureRecognizer:tap1];
            cell.oneTitle.text = model1.title;
            
            cell.twoImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model2.img]]];
            cell.twoImage.userInteractionEnabled = YES;
            cell.twoImage.tag = 100+11;
            [cell.twoImage addGestureRecognizer:tap2];
            cell.twoTitle.text = model2.title;
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107;
}

- (void)tapClick:(UITapGestureRecognizer*)tap
{
    FenLeiModel* model = _tableSource[tap.view.tag-100];
    MVDetailViewController* detailVC = [[MVDetailViewController alloc]init];
    detailVC.ID = model.id;
    detailVC.title = model.title;
    [self.navigationController pushViewController:detailVC animated:YES];
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
