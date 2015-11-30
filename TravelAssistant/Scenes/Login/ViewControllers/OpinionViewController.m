//
//  OpinionViewController.m
//  TravelAssistant
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "OpinionViewController.h"
#import <AVObject.h>

@interface OpinionViewController ()

@property (strong, nonatomic) IBOutlet UIView *opinionView;
@property (strong, nonatomic) IBOutlet UIView *emailView;

@property (weak, nonatomic) IBOutlet UITextView *opinionText;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;


@end

@implementation OpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationView];
    [self userOpinionView];
}

- (void)userOpinionView{

    self.opinionView.layer.borderWidth = 0.3;
    self.emailView.layer.borderWidth = 0.3;
    
}

- (void)navigationView{
    
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,25,25)];
    [rightButton setImage:[UIImage imageNamed:@"finish"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonClecked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,25,25)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonClecked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)leftBarButtonClecked:(UIBarButtonItem *)leftBarButton{

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)rightBarButtonClecked:(UIBarButtonItem *)rightBarButton{
    
    NSString *opintion = self.opinionText.text;
    NSString *email = self.emailTextField.text;
    
    
    
    if ((opintion.length == 0) || (email.length == 0)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写完整" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        
        BOOL userSele = [self isValidateEmail:email];
        if (userSele == NO) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"邮箱格式错误" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            
            AVObject *userOpintion = [AVObject objectWithClassName:@"UserOpintion"];
            [userOpintion saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [userOpintion setObject:opintion forKey:@"opintion"];
                [userOpintion setObject:email forKey:@"email"];
                [userOpintion saveInBackground];
                
            }];
        
    [self.navigationController popViewControllerAnimated:YES];
        
        }
        
    }
    
    
    
}

//邮箱格式
- (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)viewWillAppear:(BOOL)animated{

    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
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
