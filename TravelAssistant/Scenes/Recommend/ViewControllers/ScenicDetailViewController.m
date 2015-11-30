//
//  ScenicDetailViewController.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "ScenicDetailViewController.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import "ScenicBasicInfoModel.h"
#import "CommentModel.h"
#import "MapHelper.h"
#import "ScenicBasicInfoTableViewCell.h"
#import "ScenicDetailTableViewCell.h"
#import "ScenicReferenceTableViewCell.h"
#import "ScenicComentTableViewCell.h"
#import "ScenicBasicInfoModel.h"
#import "CommentViewController.h"



@interface ScenicDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) ScenicBasicInfoModel *scenicBasicModel;

@end

@implementation ScenicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = self.scenicModel.name;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    [self requestScenicData];
}

// 加载tableView
- (void)loadTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    footerButton.frame = CGRectMake(60, 15, self.view.frame.size.width - 120, 30);
    footerButton.layer.masksToBounds = YES;
    footerButton.layer.cornerRadius = 10;
    footerButton.layer.borderWidth = 1;
    footerButton.layer.borderColor = [UIColor orangeColor].CGColor;
    [footerButton setBackgroundColor:[UIColor clearColor]];
    [footerButton setTitle:@"查看更多评论" forState:UIControlStateNormal];
    [footerButton setTintColor:[UIColor orangeColor]];
    [footerButton addTarget:self action:@selector(didClickedFooterButton) forControlEvents:UIControlEventTouchUpInside];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    [footerView addSubview:footerButton];
    self.tableView.tableFooterView = footerView;

    [self.view addSubview:self.tableView];
   
    [self.tableView registerClass:[ScenicBasicInfoTableViewCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[ScenicDetailTableViewCell class] forCellReuseIdentifier:@"cell2"];
    [self.tableView registerClass:[ScenicReferenceTableViewCell class] forCellReuseIdentifier:@"cell3"];
    [self.tableView registerClass:[ScenicComentTableViewCell class] forCellReuseIdentifier:@"cell4"];
}
// pop回上个VC
- (void)didClickedLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 加载数据
- (void)requestScenicData {
    // 请求数据时的小菊花
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor lightGrayColor];
    self.hud.delegate = self;
    __weak typeof(self) pSelf = self;
    
    // 拼接网址并转码
    NSString *urlStr = [[NSString stringWithFormat:@"http://open.qyer.com/plan/poi/detail?app_installtime=1447226744&client_id=qyer_planner_ios&client_secret=e24e75dbf6fa3c49651f&comments_limit=3&id=%ld&ip=172.21.63.135&lat=%f&lon=%f&oauth_token=638efcf04dddd20d171f8e8a1632c230&timestamp=1447758740&track_app_channel=App Store&track_app_version=1.4.5&track_device_info=iPhone 5s&track_deviceid=E928D450-E7D0-4E20-939E-1FCCF0742DB3&track_os=ios 9.1&track_user_id=7010389&v=1",self.scenicModel.ID,self.scenicModel.lat,self.scenicModel.lng] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        pSelf.dataArray = [NSMutableArray array];
        
        NSDictionary *dict = [[responseObject valueForKey:@"data"] valueForKey:@"poi_detail"];
        // 基础信息
        
        ScenicBasicInfoModel *scenicModel = [[ScenicBasicInfoModel alloc] init];
        [scenicModel setValuesForKeysWithDictionary:dict];
        [pSelf.dataArray addObject:scenicModel];
        self.scenicBasicModel = scenicModel;
        // 评论
        NSArray *arr = [[[responseObject valueForKey:@"data"] valueForKey:@"poi_detail"] valueForKey:@"comments"];
        for (NSDictionary *dict in arr) {
            CommentModel *commentModel = [[CommentModel alloc] init];
            [commentModel setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:commentModel];
        }
        
        [pSelf hudWasHidden:pSelf.hud];
//        [self.tableView reloadData];
        [pSelf loadTableView];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        // 网络请求失败
        [pSelf hudWasHidden:pSelf.hud];
        UILabel *label = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"请求数据失败";
        [pSelf.view addSubview:label];
        
    }];

  }

// 加载更多
- (void)didClickedFooterButton {
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    commentVC.pid = self.scenicModel.pid;
    [self.navigationController showViewController:commentVC sender:self];
}


#pragma mark - tableView的代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4 ;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return self.dataArray.count - 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0:{
            ScenicBasicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.scenicBasicModel = self.dataArray[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{
            ScenicDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            cell.scenicModel = self.dataArray[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:{
            ScenicReferenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
            cell.scenicModel = self.dataArray[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 3:{
            ScenicComentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
            cell.commentModel = self.dataArray[1 + indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        default:
            break;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.view.frame.size.width, 20)];
    [view addSubview:label];
    [self.view addSubview:view];
    switch (section) {
        case 0:
            label.text = @"基础信息";
            break;
        case 1:
            label.text = @"景点介绍";
            break;
        case 2:
            label.text = @"参考评价";
            break;
        case 3:
            label.text = @"点评";
            break;
            
        default:
            break;
    }
    return view;
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}




// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0:
            return [self stringHeightWithString:self.scenicBasicModel.price fontSize:18 contentSize:CGSizeMake(self.view.frame.size.width, 2000)] + [self stringHeightWithString:self.scenicBasicModel.opentime fontSize:18 contentSize:CGSizeMake(self.view.frame.size.width - 80, 2000)] + [self stringHeightWithString:self.scenicBasicModel.wayto fontSize:18 contentSize:CGSizeMake(self.view.frame.size.width - 80, 2000)] + [self stringHeightWithString:self.scenicBasicModel.site fontSize:14 contentSize:CGSizeMake(self.view.frame.size.width, 2000)] + 60;
            break;
        case 1:
            return [self stringHeightWithString:self.scenicBasicModel.introduction fontSize:18 contentSize:CGSizeMake(self.view.frame.size.width, 2000)] + 20;
            break;
        case 2:
            return 70;
            break;
        case 3:{

            return [self stringHeightWithString:[self.dataArray[indexPath.row + 1] comment] fontSize:18 contentSize:CGSizeMake(self.view.frame.size.width - 80, 2000)] + 40;

         
        }
            break;
            
        default:
            break;
    }

    return 1;
}

#pragma mark--- MBProgressHUD代理协议
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}


// 在返回每个row的高度时，调用此方法
- (CGFloat)stringHeightWithString:(NSString *)str fontSize:(CGFloat)fontSize contentSize:(CGSize)size
{
    // 第一个参数：代表最大的范围
    // 第二个参数：代表的是 是否考虑字体，是否考虑字号
    // 第三个参数：代表的是是用什么字体什么字号
    // 第四个参数：用不到，所以基本写成nil
    CGRect stringRect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return stringRect.size.height;
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
