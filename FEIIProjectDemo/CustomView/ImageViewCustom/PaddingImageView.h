//
//  PaddingImageView.h
//  FEIIProjectDemo
//
//  Created by fei li on 2018/5/25.
//  Copyright © 2018年 feii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaddingImageView : UIView

@property (nonatomic, strong) UIImageView *imgView;

- (instancetype)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor paddColor:(UIColor *)paddingColor padWidth:(CGFloat)padWidth;

@end
