//
//  RegisterViewController.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "RegisterViewController.h"
#import <AVUser.h>

@interface RegisterViewController ()
- (IBAction)backClecked:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordAgainTextField;

- (IBAction)registerButton:(UIButton *)sender;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
 
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (IBAction)backClecked:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


//邮箱格式
- (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)registerButton:(UIButton *)sender {
    
    NSString *userName = self.userTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *passwordAgain = self.passwordAgainTextField.text;
    
    if ((userName.length == 0) || (password.length == 0) || (email.length == 0) || (passwordAgain.length == 0)) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请完整填写" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {

        
        BOOL userSele = [self isValidateEmail:email];
        
        if (userSele == NO) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"邮箱格式不正确" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else {
            
            if (password.length < 6) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入有误" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                
                [alertController addAction:cancelAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            } else {
                
                if ([passwordAgain isEqualToString:password]) {
                    
                    //用户名注册
                    AVUser *user = [AVUser user];
                    user.username = userName;
                    user.password =  password;
                    user.email = email;
                    
                    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            
//                            NSLog(@"succeeded:   %d", succeeded);
//                            NSLog(@"成功！！");
                            
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            
                        } else {
//                            NSLog(@"失败！！");
//                            NSLog(@"%@", error);
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户已被注册" preferredStyle:(UIAlertControllerStyleAlert)];
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                            
                            [alertController addAction:cancelAction];
                            
                            [self presentViewController:alertController animated:YES completion:nil];
                            
                        }
                    }];
                    
                    
                    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
//                            NSLog(@"succeeded:   %d", succeeded);
//                            NSLog(@"发送邮件成功！！");
                            
                        } else {
//                            NSLog(@"失败！！");
//                            NSLog(@"%@", error);
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"已有用户注册此邮箱" preferredStyle:(UIAlertControllerStyleAlert)];
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                            
                            [alertController addAction:cancelAction];
                            
                            [self presentViewController:alertController animated:YES completion:nil];
                            
                        }
                    }];

                } else {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码不一致" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    
                    [alertController addAction:cancelAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                
                }
                
            }
            
        }

    }
        
        
}
@end
