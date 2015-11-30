//
//  LoginViewController.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import <AVUser.h>
#import <AVOSCloudSNS.h>

@interface LoginViewController ()

- (IBAction)leftButtonClecked:(UIButton *)sender;
- (IBAction)rightButtonClecked:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UIButton *weiboxButton;
@property (strong, nonatomic) IBOutlet UIButton *qqButton;

- (IBAction)weiboxLoginClecked:(UIButton *)sender;
- (IBAction)qqLoginClecked:(UIButton *)sender;



- (IBAction)loginButton:(UIButton *)sender;
- (IBAction)forgetPasswordButton:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self loginView];
    
}

- (void)loginView{
   
    
    self.weiboxButton.layer.cornerRadius = self.weiboxButton.frame.size.width / 2;
    self.weiboxButton.layer.masksToBounds = YES;
   
    
    self.qqButton.layer.cornerRadius = self.weiboxButton.frame.size.width / 2;
    self.qqButton.layer.masksToBounds = YES;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (IBAction)leftButtonClecked:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)rightButtonClecked:(UIButton *)sender {
    
    RegisterViewController *reg = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:reg animated:YES];
    
}

//邮箱格式
- (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)weiboxLoginClecked:(UIButton *)sender {
    
    // 如果安装了微博，直接跳转到微博应用，否则跳转至网页登录
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if (error) {
//            NSLog(@"failed to get authentication from weibo. error: %@", error.description);
        } else {
            [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformWeiBo block:^(AVUser *user, NSError *error) {
                if (error) {
                    
                    [self alert:[error localizedDescription]];
                    
                    
                } else {
                
//                    [self loginSucceedWithUser:user authData:object];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                
                }
            }];
        }
    } toPlatform:AVOSCloudSNSSinaWeibo];
    
}



- (void)alert:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//- (void)loginSucceedWithUser:(AVUser *)user authData:(NSDictionary *)authData{
//    
//    NSLog(@"authData:  %@", authData);
//    
//    NSLog(@"username:  %@", authData[@"username"]);
//
//    
//}

- (IBAction)qqLoginClecked:(UIButton *)sender {
    
    // 如果安装了QQ，则跳转至应用，否则跳转至网页
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if (error) {
//            NSLog(@"failed to get authentication from weibo. error: %@", error.description);
        } else {
            [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformQQ block:^(AVUser *user, NSError *error) {
                
                if (error) {
                    [self alert:[error localizedDescription]];
                    
                    
                } else {
                    
//                    [self loginSucceedWithUser:user authData:object];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }
                
            }];
        }
    } toPlatform:AVOSCloudSNSQQ];
    
}

- (IBAction)loginButton:(UIButton *)sender {
    
    NSString *userName = self.userTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if ((userName.length == 0) || (password.length == 0)) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写完整" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        BOOL userSele = [self isValidateEmail:userName];
        if (userSele == NO) {
            
            //用户名登录
            [AVUser logInWithUsernameInBackground:userName password:password block:^(AVUser *user, NSError *error) {
                if (user != nil) {
                    
//                    NSLog(@"登录成功！！！");
                    
//                    AVUser *currentUser = [AVUser currentUser];
//                    NSLog(@"%@", currentUser.username);
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    if (self.block != nil) {
                        self.block();
                    }
                    
                } else {
                    
//                    AVUser *currentUser = [AVUser currentUser];
//                    NSLog(@"%@", currentUser.username);
//                    NSLog(@"登录失败！！！！");
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码错误" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    
                    [alertController addAction:cancelAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                }
            }];
            
        } else {
            
            
            //邮箱登录
            [AVUser logInWithUsernameInBackground:userName password:password block:^(AVUser *user, NSError *error) {
                if (user != nil) {
//                    NSLog(@"登录成功！！！");
//                    
//                    AVUser *currentUser = [AVUser currentUser];
//                    NSLog(@"%@", currentUser.username);
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    
//                    NSLog(@"登录失败！！！！");
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码错误" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    
                    [alertController addAction:cancelAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                }
            }];
            
            
        }

    
    }
    
    
    

    
}

- (IBAction)forgetPasswordButton:(UIButton *)sender {
    
    ForgetPasswordViewController *forget = [[ForgetPasswordViewController alloc] init];
    [self presentViewController:forget animated:YES completion:nil];
    
}
@end
