//
//  DottedView.m
//  FEIIProjectDemo
//
//  Created by fei li on 2018/6/25.
//  Copyright © 2018年 feii. All rights reserved.
//

#import "DottedView.h"

@implementation DottedView

//Quartz 2D drawRect:绘制
- (void)drawRect:(CGRect)rect{//可以通过setNeedsDisplay方法调用
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条的样式 //设置线条起点和终点的样式为圆角
    CGContextSetLineCap(context, kCGLineCapRound);
    //绘制线的宽度
    CGContextSetLineWidth(context, 3);
    //线的颜色
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    //开始绘制
    CGContextBeginPath(context);
    //设置虚线绘制起点
    CGContextMoveToPoint(context, 10, 20);
    //lengths 的值{10,10}表示先绘制的10个点，再跳过10个点，如此反复
    CGFloat lengths[] = {10,10};
    //虚线的起始点
    CGContextSetLineDash(context, 0, lengths, 2);
    //虚线的终点
    CGContextAddLineToPoint(context, 81.0, 30);
    //绘制
    CGContextStrokePath(context);
    //关闭上下文
    CGContextClosePath(context);
    
}

- (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView {
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);
    
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    
    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {5,5};
    
    CGContextSetStrokeColorWithColor(line, [UIColor greenColor].CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);
    
    CGContextMoveToPoint(line, 0.0, 2.0);
    
    CGContextAddLineToPoint(line, 300, 2.0);
    
    CGContextStrokePath(line);
    
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    if (isHorizonal) {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame)/2, CGRectGetHeight(lineView.frame))];
    }else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame), CGRectGetHeight(lineView.frame)/2)];
    }
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //设置虚线颜色
    [shapeLayer setStrokeColor:[UIColor blackColor].CGColor];
    //设置虚线的宽度
    if (isHorizonal) {
        
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
        
    }else{
        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    //设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    if (isHorizonal) {
        
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
        
    }else{
        
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
        
    }
    [shapeLayer setPath:path];
    
    CGPathRelease(path);
    
    [lineView.layer addSublayer:shapeLayer];
    
}

@end
