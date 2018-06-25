//
//  FEIIBlePeriphalManager.h
//  FEIIProjectDemo
//
//  Created by fei li on 2018/6/3.
//  Copyright © 2018年 feii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ReturnStr)(NSString *);

@interface FEIIBlePeriphalManager : NSObject

@property (nonatomic, assign) ReturnStr returnStr;
@property (nonatomic, weak) UITextView *textView;

- (void)initPeripheralManager;

- (void)writeDataToCentral:(NSString *)str;

- (instancetype)initWithTextView:(UITextView *)textView;


@end
