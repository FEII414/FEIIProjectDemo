//
//  DottedView.h
//  FEIIProjectDemo
//
//  Created by fei li on 2018/6/25.
//  Copyright © 2018年 feii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DottedView : UIView

- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;

@end
