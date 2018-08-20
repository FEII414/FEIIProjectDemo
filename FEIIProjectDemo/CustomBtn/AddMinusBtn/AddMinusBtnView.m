//
//  AddMinusBtnView.m
//  FEIIProjectDemo
//
//  Created by Lieniu03 on 2018/8/20.
//  Copyright © 2018年 feii. All rights reserved.
//

#import "AddMinusBtnView.h"

@implementation AddMinusBtnView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _count = 0;
        _minCount = 0;
        _maxCount = MAXFLOAT;
        [self setupViews];
        return self;
        
    }
    return nil;
    
}

- (void)setupViews{
 
    _btnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnMinus.backgroundColor = [UIColor greenColor];
    _btnMinus.frame = CGRectMake(0, 0, 20, 20);
    [_btnMinus addTarget:self action:@selector(clickMinus:) forControlEvents:UIControlEventTouchUpInside];
    _btnMinus.enabled = false;
    [self addSubview:_btnMinus];
    
    _labelCount = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 50, 20)];
    _labelCount.layer.borderWidth = 0.5;
    _labelCount.layer.borderColor = [UIColor redColor].CGColor;
    _labelCount.text = @"0";
    _labelCount.textColor = [UIColor whiteColor];
    _labelCount.font = [UIFont systemFontOfSize:14];
    _labelCount.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_labelCount];
    
    _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnAdd.backgroundColor = [UIColor blueColor];
    _btnAdd.frame = CGRectMake(80, 0, 20, 20);
    [self addSubview:_btnAdd];
    [_btnAdd addTarget:self action:@selector(clickAdd:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickMinus:(UIButton*)sender{
    
    sender.enabled = false;
    _count --;
    if (_count < _minCount) {
        _count = _minCount;
    }
    
    if (_btnAdd.enabled == false) {
        _btnAdd.enabled = true;
        _btnAdd.backgroundColor = [UIColor blueColor];
    }
    
    _labelCount.text = [NSString stringWithFormat:@"%ld",_count];
    if (_blockInt) {
        _blockInt(_count);
    }
    
    if (_count <= _minCount) {
        sender.backgroundColor = [UIColor greenColor];
    }else{
        sender.enabled = true;
    }
    
}

- (void)clickAdd:(UIButton*)sender{
    
    sender.enabled = false;
    _count ++;
    if (_btnMinus.enabled == false) {
        _btnMinus.enabled = true;
        _btnMinus.backgroundColor = [UIColor blueColor];
    }
    
    _labelCount.text = [NSString stringWithFormat:@"%ld",_count];
    if (_blockInt) {
        _blockInt(_count);
    }
    
    if (_count > _maxCount) {
        sender.backgroundColor = [UIColor greenColor];
    }else{
        sender.enabled = true;
    }
    
}

@end
