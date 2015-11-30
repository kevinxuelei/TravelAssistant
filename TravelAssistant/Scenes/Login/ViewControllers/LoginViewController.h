//
//  LoginViewController.h
//  TravelAssistant
//
//  Created by lanou3g on 15/11/12.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginViewControllerBlock)();

@interface LoginViewController : UIViewController

@property (nonatomic, copy) LoginViewControllerBlock block;

@end
