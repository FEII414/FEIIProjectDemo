//
//  AddMinusBtnView.h
//  FEIIProjectDemo
//
//  Created by Lieniu03 on 2018/8/20.
//  Copyright © 2018年 feii. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddMinuteBlock)(NSInteger count);

@interface AddMinusBtnView : UIView

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat minCount;
@property (nonatomic, assign) CGFloat maxCount;
@property (nonatomic, strong) UIButton *btnMinus;
@property (nonatomic, strong) UILabel *labelCount;
@property (nonatomic, strong) UIButton *btnAdd;

@property (nonatomic, copy) AddMinuteBlock blockInt;

@end
