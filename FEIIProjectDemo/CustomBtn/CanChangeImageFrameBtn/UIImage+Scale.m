//
//  UIImage+Scale.m
//  FEIIProjectDemo
//
//  Created by fei li on 2018/5/25.
//  Copyright © 2018年 feii. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

- (UIImage *)imageToSize:(CGSize)size{
    
    //创建一个bitmap的context
    //并把它设置为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    //绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    //使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

@end
