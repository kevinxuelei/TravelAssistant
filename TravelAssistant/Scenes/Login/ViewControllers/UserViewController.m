//
//  UserViewController.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "OpinionViewController.h"
#import <AVObject.h>
#import <AVUser.h>
#import <AVOSCloudSNS.h>
#import <UIButton+WebCache.h>
#import "UMSocial.h"


#define KScreen_Width [UIScreen mainScreen].bounds.size.width
#define KScreen_Height [UIScreen mainScreen].bounds.size.height

const CGFloat BackGroupHeight = 200;
const CGFloat HeadImageHeight = 60;


@interface UserViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UMSocialUIDelegate>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) UILabel *loginLabel;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIVisualEffectView *effectview;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation UserViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
//    //测试存储
//    AVObject *testObject = [AVObject objectWithClassName:@"TestObject"];
//    [testObject setObject:@"bar" forKey:@"foo"];
//    [testObject save];
    
    
    [self data];
    [self loadTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    AVUser *currentUser = [AVUser currentUser];
    
    if (currentUser.username == nil) {
        self.loginLabel.text = @"点击头像登录";
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"loginHeaderImage"] forState:(UIControlStateNormal)];
    } else {
        
        NSDictionary *dic =[currentUser objectForKey:@"authData"];
        
        NSString *type = [dic allKeys].firstObject;
//        NSLog(@"type +++++++++++++  %@", type);
        
        if ([type isEqualToString:@"qq"]) {
            
            NSDictionary *userDic = [AVOSCloudSNS userInfo:AVOSCloudSNSQQ];
            
//            NSLog(@"userDic: %@", userDic);
            
            self.loginLabel.text = userDic[@"username"];
            [self.loginButton sd_setImageWithURL:userDic[@"avatar"] forState:UIControlStateNormal];
            
            
        } else if ([type isEqualToString:@"weibo"]) {
        
            NSDictionary *userDic = [AVOSCloudSNS userInfo:AVOSCloudSNSSinaWeibo];
            
//            NSLog(@"userDic: %@", userDic);
            
            self.loginLabel.text = userDic[@"username"];
            [self.loginButton sd_setImageWithURL:userDic[@"avatar"] forState:UIControlStateNormal];
            
        
        } else {
        
            self.loginLabel.text = currentUser.username;
            [self.loginButton setBackgroundImage:[UIImage imageNamed:@"header"] forState:(UIControlStateNormal)];
        
        }
        
        
    }

}

- (void)data{

    self.array = [NSMutableArray array];
    
    NSMutableArray *arr1 = [[NSMutableArray alloc] initWithObjects:@"清空缓存", nil];
    
    [self.array addObject:arr1];
    
    NSMutableArray *arr2 = [[NSMutableArray alloc] initWithObjects:@"使用说明", @"鼓励我们", @"吐槽产品", @"推荐给朋友", nil];

    [self.array addObject:arr2];
    
}

- (void)loadTableView{

    self.table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds  style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.table.contentInset = UIEdgeInsetsMake(BackGroupHeight, 0, 0, 0);
    
    [self.view addSubview:self.table];
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    
    self.table.separatorStyle = NO;
    
    
    [self headerView];
}

- (void)headerView{
    
    self.backgroundView = [[UIImageView alloc] init];
    self.backgroundView.frame=CGRectMake(0, -BackGroupHeight, KScreen_Width, BackGroupHeight);
    self.backgroundView.image=[UIImage imageNamed:@"backgroundHeader"];
    [self.table addSubview:self.backgroundView];
    
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    self.effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.effectview.frame = CGRectMake(0, -BackGroupHeight, KScreen_Width, BackGroupHeight);
    [self.table addSubview: self.effectview];
    
    
    UIView *loginView=[[UIView alloc]init];
    loginView.backgroundColor=[UIColor clearColor];
    loginView.frame=CGRectMake(0, -BackGroupHeight , KScreen_Width, BackGroupHeight );
    [self.table addSubview:loginView];
    
    
    self.loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.loginButton.frame = CGRectMake((KScreen_Width - HeadImageHeight) / 2, 70, HeadImageHeight, HeadImageHeight);
//    self.loginButton.backgroundColor = [UIColor orangeColor];
  
    [loginView addSubview:self.loginButton];
    [self.loginButton addTarget:self action:@selector(loginClecked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.width / 2;
    self.loginButton.layer.masksToBounds = YES;
    
    
    self.loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.loginButton.frame) + 5, KScreen_Width, 20)];
    self.loginLabel.font = [UIFont systemFontOfSize:13.0];
    self.loginLabel.text = @"点击头像登录";
    self.loginLabel.textAlignment = NSTextAlignmentCenter;
    [loginView addSubview:self.loginLabel];
    self.loginLabel.textColor = [UIColor blackColor];
    
    self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:(UIControlStateNormal)];
    self.backButton.frame = CGRectMake(20, - BackGroupHeight + 20 , 25, 25);
    [self.backButton addTarget:self action:@selector(backButtonClecked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.table addSubview:self.backButton];
    
    

}

- (void)backButtonClecked:(UIButton *)but{
    self.block();
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)loginClecked:(UIButton *)but{

    AVUser *currentUser = [AVUser currentUser];
    
    if (currentUser.username == nil) {
        LoginViewController *loginView = [[LoginViewController alloc] init];
        UINavigationController *navigationLogin = [[UINavigationController alloc] initWithRootViewController:loginView];
        [self presentViewController:navigationLogin animated:YES completion:nil];
    } else {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定退出登录吗" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不退出" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //注销
            [AVUser logOut];
            [AVOSCloudSNS logout:AVOSCloudSNSSinaWeibo];
            [AVOSCloudSNS logout:AVOSCloudSNSQQ];
            
//            AVUser *currentUser1 = [AVUser currentUser];
//            NSLog(@"%@", currentUser1.username);
            self.loginLabel.text = @"点击头像登录";
            [self.loginButton setBackgroundImage:[UIImage imageNamed:@"loginHeaderImage"] forState:(UIControlStateNormal)];
            [self.loginButton sd_setImageWithURL:nil forState:UIControlStateNormal];
            
        }];
    
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

#pragma mark ---- tableView代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //下拉坐标
//    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + BackGroupHeight) / 2;
    
    if (yOffset < -BackGroupHeight) {
        
        CGRect rect = self.backgroundView.frame;
        rect.origin.y = yOffset;
        rect.size.height =  - yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = KScreen_Width + fabs(xOffset) * 2;
        
        self.backgroundView.frame = rect;
        self.effectview.frame = rect;
        self.backButton.frame = CGRectMake(15, 25 + yOffset, 25, 25);
        
    }
    
    CGFloat alpha = (yOffset + BackGroupHeight) / BackGroupHeight;
    
    alpha = fabs(alpha);
    alpha = fabs(1 - alpha);
    
    self.effectview.alpha = alpha;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.textLabel.text = self.array[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    
    return cell;

}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.array[section] count];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.view.frame.size.width - 20, 30)];
    label.font = [UIFont systemFontOfSize:13.0];
    label.alpha = 0.6;

    [sectionView addSubview:label];
    
    switch (section) {
        case 0:
            label.text = @"设置";
            break;
        case 1:
            label.text = @"帮助及反馈";
            break;
            
        default:
            break;
    }
    
    return sectionView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section == 0) {
        
        [self clear];
        
    } else if (indexPath.section == 1){
    
        switch (indexPath.row) {
            case 0:
                [self explain];
                break;
            case 1:
                [self hortative];
                break;
            case 2:
                [self opinion];
                break;
            case 3:
                [self recommend];
                break;
                
            default:
                break;
        }
    
    }

}


- (void)clear{

//    NSLog(@"清除缓存");

    
    float cache = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    
    if (cache == 0.0) {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"无缓存可清除" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
    
        NSString *title = [NSString stringWithFormat:@"是否清除%.2fM缓存", cache ];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[SDImageCache sharedImageCache] clearDisk];
            
            [self.table reloadData];
            
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}

- (void)explain{
    
//    NSLog(@"使用说明");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"正在开发，请期待" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)hortative{
    
//    NSLog(@"鼓励我们");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"正在开发，请期待" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)opinion{
    
//    NSLog(@"吐槽产品");
    OpinionViewController *opinion = [[OpinionViewController alloc] init];
    [self.navigationController pushViewController:opinion animated:YES];
    
}

- (void)recommend{
    
//    NSLog(@"推荐给朋友");
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"5652dfaa67e58e025400038a" shareText:@"来自一个神秘的软件游天下" shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToDouban,UMShareToTencent,UMShareToRenren, nil] delegate:self];
    
}




@end
