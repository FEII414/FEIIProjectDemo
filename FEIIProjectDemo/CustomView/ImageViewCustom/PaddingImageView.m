//
//  PaddingImageView.m
//  FEIIProjectDemo
//
//  Created by fei li on 2018/5/25.
//  Copyright © 2018年 feii. All rights reserved.
//

#import "PaddingImageView.h"
@interface PaddingImageView()

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) UIColor *borderColor;
@property (nonatomic, assign) UIColor *paddingColor;
@property (nonatomic, assign) CGFloat padWidth;

@end

@implementation PaddingImageView

- (instancetype)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor paddColor:(UIColor *)paddingColor padWidth:(CGFloat)padWidth{
    
    if (self = [super initWithFrame:frame]) {
        
        _cornerRadius = cornerRadius;
        _borderWidth = borderWidth;
        _borderColor = borderColor;
        _paddingColor = paddingColor;
        _padWidth = padWidth;
        [self setupViews];
        return self;
        
    }
    return nil;
}

- (void)setupViews{
    
    self.backgroundColor = _paddingColor;
    self.layer.borderColor = _borderColor.CGColor;
    self.layer.borderWidth = _borderWidth;
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(_padWidth, _padWidth, self.frame.size.width - _padWidth*2, self.frame.size.height - _padWidth*2)];
    _imgView.backgroundColor = [UIColor grayColor];
    
    if (_cornerRadius >0) {
        
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = _cornerRadius;
        
        _imgView.layer.masksToBounds = true;
        _imgView.layer.cornerRadius = (_cornerRadius-_padWidth);
        
    }
    
    [self addSubview:_imgView];
    
}

@end
