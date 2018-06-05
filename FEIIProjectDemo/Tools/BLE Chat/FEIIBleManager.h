//
//  FEIIBleManager.h
//  FEIIProjectDemo
//
//  Created by fei li on 2018/6/3.
//  Copyright © 2018年 feii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol FEIIBleManagerDelegate <NSObject>

@optional

- (void)connectSuccessName:(NSString *)periphalName;

- (void)scanOneReturn:(CBPeripheral *)peripheral;

@end

@interface FEIIBleManager : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, weak) id<FEIIBleManagerDelegate> delegate;
@property (nonatomic, strong) CBPeripheral *myPeripheral;


- (void)connectMyPeripheral;

//write

- (void)sendDataToPeripharl:(NSString *)str;

//
- (void)initCentralManager;

@end
