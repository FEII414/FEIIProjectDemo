//
//  CustomViewViewController.m
//  FEIIProjectDemo
//
//  Created by fei li on 2018/5/25.
//  Copyright © 2018年 feii. All rights reserved.
//

#import "CustomViewViewController.h"
#import "PaddingImageView.h"
#import "DottedView.h"

@interface CustomViewViewController ()

@property (nonatomic, strong) PaddingImageView *paddingView;

@property (nonatomic, strong) DottedView *dottedView;

@end

@implementation CustomViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"customBtn";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.paddingView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    [self.view addSubview:self.dottedView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark someMethods
- (void)dismiss{
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

#pragma mark lazyLoad
- (PaddingImageView *)paddingView{
    
    if (_paddingView == nil) {
        
        _paddingView = [[PaddingImageView alloc]initWithFrame:CGRectMake(10, 88, 100, 100) cornerRadius:50 borderWidth:3 borderColor:[UIColor blueColor] paddColor:[UIColor redColor] padWidth:6];
        
    }
    return _paddingView;
    
    
}

- (DottedView *)dottedView{
    
    if (_dottedView == nil) {
        
        _dottedView = [[DottedView alloc]initWithFrame:CGRectMake(20, 100, 300, 60)];
        _dottedView.backgroundColor = [UIColor blueColor];
        
        
        [_dottedView drawLineOfDashByCAShapeLayer:_dottedView lineLength:4 lineSpacing:9 lineColor:[UIColor redColor] lineDirection:false];
    }
    return _dottedView;
    
}

@end
