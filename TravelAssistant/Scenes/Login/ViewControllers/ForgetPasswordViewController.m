//
//  ForgetPasswordViewController.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import <AVUser.h>

@interface ForgetPasswordViewController ()

- (IBAction)forgetPassword:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
- (IBAction)backButton:(UIButton *)sender;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

//邮箱格式
- (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)forgetPassword:(UIButton *)sender {
    
    BOOL userSele = [self isValidateEmail:self.emailTextField.text];
    if (userSele == NO) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"邮箱格式错误" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        
        //通过邮箱重置密码
        [AVUser requestPasswordResetForEmailInBackground:self.emailTextField.text block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
//                NSLog(@"成功");
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请查看邮件" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                
                [alertController addAction:cancelAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            } else {
//                NSLog(@"失败");
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"邮箱未注册" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];

    
    }
    
    
}
- (IBAction)backButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
