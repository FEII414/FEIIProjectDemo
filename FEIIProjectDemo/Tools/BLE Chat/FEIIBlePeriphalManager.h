//
//  FEIIBlePeriphalManager.h
//  FEIIProjectDemo
//
//  Created by fei li on 2018/6/3.
//  Copyright © 2018年 feii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FEIIBlePeriphalManager : NSObject

- (void)initPeripheralManager;

- (void)writeDataToCentral:(NSString *)str;

@end
