//
//  TextViewEmojiViewController.m
//  FEIIProjectDemo
//
//  Created by fei li on 2018/5/27.
//  Copyright © 2018年 feii. All rights reserved.
//

#import "TextViewEmojiViewController.h"
#import "FEIKeyBoard.h"

#define kScreenWidth [[UIScreen mainScreen]bounds].size.width
#define kScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface TextViewEmojiViewController ()

@property (nonatomic, strong) FEIKeyBoard *kerBoard;

@end

@implementation TextViewEmojiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"textViewEmoji";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 88, 120, 44);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget: self  action:@selector(clickComent:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"comment" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    UIButton *btnEnd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEnd.frame = CGRectMake(120+44+20, 88, 120, 44);
    btnEnd.backgroundColor = [UIColor redColor];
    [btnEnd addTarget: self  action:@selector(clickEnd:) forControlEvents:UIControlEventTouchUpInside];
    [btnEnd setTitle:@"end" forState:UIControlStateNormal];
    [self.view addSubview:btnEnd];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark someMethods
- (void)clickComent:(UIButton *)sender{
    
    if (_kerBoard == nil) {
        FEIKeyBoard *keyBoard = [[FEIKeyBoard alloc]initWithController:self];
        
        _kerBoard = keyBoard;
    }
    
}
- (void)clickEnd:(UIButton *)sender{
    
    if (_kerBoard) {
        [_kerBoard onlyShowToolBar];
    }
//    [self.view endEditing:true];
    
}

- (void)dismiss{
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

@end
