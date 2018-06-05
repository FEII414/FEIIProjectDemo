//
//  CustomBtnViewController.m
//  FEIIProjectDemo
//
//  Created by fei li on 2018/5/25.
//  Copyright © 2018年 feii. All rights reserved.
//

#import "CustomBtnViewController.h"
#import "UIImage+Scale.h"
#import "ChangeImageFrameButton.h"

#define kScreenWidth [[UIScreen mainScreen]bounds].size.width
#define kScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface CustomBtnViewController ()

@property (nonatomic, strong) UIButton *imgCategoryBtn;
@property (nonatomic, assign) NSInteger imgCategorySize;
@property (nonatomic, assign) BOOL imgCategoryAdd;

@property (nonatomic, strong) ChangeImageFrameButton *changeBtn;

@end

@implementation CustomBtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"customBtn";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imgCategoryBtn];
    _imgCategorySize = 10;
    _imgCategoryAdd = true;
    
    [self.view addSubview:self.changeBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    
    UIImageView *iamge = [[UIImageView alloc]initWithFrame:CGRectMake(50, 200, 200, 200)];
    iamge.image = [[UIImage imageNamed:@"fat"] imageToSize:CGSizeMake(200, 200)];
    [self.view addSubview:iamge];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark someMethods
-(void)clickImgCategory{
    
    if (_imgCategoryAdd) {
        _imgCategorySize += 10;
        if (_imgCategorySize > 50) {
            _imgCategoryAdd = false;
        }
    }else{
        _imgCategorySize -= 10;
        if (_imgCategorySize < 10) {
            _imgCategoryAdd = true;
        }
    }
    
    UIImage *image = [UIImage imageNamed:@"fat"];
    [_imgCategoryBtn setImage:[image imageToSize:CGSizeMake(_imgCategorySize, _imgCategorySize*2)] forState:UIControlStateNormal];
    
}

- (void)dismiss{
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

#pragma mark lazyLoad
- (UIButton *)imgCategoryBtn{
    
    if (_imgCategoryBtn == nil) {
        
        _imgCategoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imgCategoryBtn.frame = CGRectMake(0,88,kScreenWidth , 44);
        _imgCategoryBtn.backgroundColor = [UIColor grayColor];
        
        UIImage *image = [UIImage imageNamed:@"fat"];
        [_imgCategoryBtn setImage:[image imageToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [_imgCategoryBtn setTitle:@"Im imgCategory change image frame" forState:UIControlStateNormal];
        _imgCategoryBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        
        [_imgCategoryBtn addTarget:self action:@selector(clickImgCategory) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _imgCategoryBtn;
    
}

- (ChangeImageFrameButton *)changeBtn{
    
    if (_changeBtn == nil) {
        
        _changeBtn = [ChangeImageFrameButton buttonWithType:UIButtonTypeCustom];
        _changeBtn.backgroundColor = [UIColor grayColor];
        _changeBtn.frame = CGRectMake(0,CGRectGetMaxY(self.imgCategoryBtn.frame)+20,kScreenWidth , 44);
        
        [_changeBtn setImage:[UIImage imageNamed:@"fat"] forState:UIControlStateNormal];
        [_changeBtn setTitle:@"Im override change image frame" forState:UIControlStateNormal];
        
        
    }
    return _changeBtn;
    
}

@end
