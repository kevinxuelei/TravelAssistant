//
//  DailyNoteViewController.m
//  TravelAssistant
//
//  Created by 吕世涛 on 15/11/17.
//  Copyright © 2015年 王安贺. All rights reserved.
//

#import "DailyNoteViewController.h"
#import "DailyNoteModel.h"
#import "DataForServer.h"
#import "Macros.h"

@interface DailyNoteViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSDictionary *changedDictionary;

@end

@implementation DailyNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickedLeftBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.title = @"笔记详情";
    [self loadTextView];
}
#pragma mark--- navigationBar点击方法
// pop回上个VC,并保存更改
- (void)didClickedLeftBarButton
{
    [self.textView endEditing:YES];
    [self performSelector:@selector(saveNewText) withObject:nil afterDelay:0.5f];
}
- (void)saveNewText
{
    if (_is_Create) {
        if (![self.textView.text isEqualToString:@""]) {
            // 这是新创建的笔记
            NSDictionary *dic = self.dictionary[@"route_array"][self.index];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:dic[@"note_array"]];
            [arr addObject:self.changedDictionary];
            self.dictionary[@"route_array"][self.index][@"note_array"] = arr;
            [[DataForServer shareDataForServer] updateForArray:self.dictionary[@"objectId"] data:self.dictionary];
            
            if (![self.textView.text isEqualToString:@""]) {
                DailyNoteModel *model = [[DailyNoteModel alloc] init];
                [model setValuesForKeysWithDictionary:self.changedDictionary];
                self.block(model);
            }
        }
    } else {
        // 保存更改
        NSDictionary *dic = self.dictionary[@"route_array"][self.index];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:dic[@"note_array"]];
        [arr replaceObjectAtIndex:self.row withObject:self.changedDictionary];
        self.dictionary[@"route_array"][self.index][@"note_array"] = arr;
        [[DataForServer shareDataForServer] updateForArray:self.dictionary[@"objectId"] data:self.dictionary];
        
        if (![self.model.message isEqualToString:self.textView.text]) {
            self.model.message = self.textView.text;
            self.block(self.model);
        }
    }
    // pop
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--- 重写setter方法
- (void)setIs_Create:(BOOL)is_Create
{
    _is_Create = is_Create;
    if (self.textView == nil) {
        [self loadTextView];
    }
    if ([self.textView.text isEqualToString:@""]) {
        self.textView.text = @"（点此可以添加笔记）";
    }
}
- (void)setModel:(DailyNoteModel *)model
{
    _model = model;
    if (self.textView == nil) {
        [self loadTextView];
    }
    self.textView.text = model.message;
    self.changedDictionary = @{@"message":model.message};
}
#pragma mark--- 加载textView
- (void)loadTextView
{
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 5, kVCwidth - 30, KVCheight/2)];
    self.textView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.textView];
    // 键盘即将显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}
// 键盘即将显示
- (void)UIKeyboardWillShowNotification:(NSNotification *)note
{
    if ([self.textView.text isEqualToString:@"（点此可以添加笔记）"]) {
        self.textView.text = @"";
    }
}
// 键盘即将隐藏
- (void)UIKeyboardWillHideNotification:(NSNotification *)note
{
    self.changedDictionary = @{@"message":self.textView.text};
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
