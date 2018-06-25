//
//  FEIIBleManager.m
//  FEIIProjectDemo
//
//  Created by fei li on 2018/6/3.
//  Copyright © 2018年 feii. All rights reserved.
//

#import "FEIIBleManager.h"

#define kPeripheralDeviceName @"iPhone" //
#define kServicesUUID @"4E5EA11F-455C-446F-967F-2BF5A9CCFBE9"
#define kCharacteristic @"B4CD9CAC-2C3D-4F35-ADB0-26C3C12BD37D"

#define ServiceUUID1 @"ECBD5F37-4F6A-4A4C-8442-8AA9B9BB39ED"
#define ServiceUUID2 @"AAB8925E-EA78-43A5-86BA-F7FAA9CCB209"

#define notiyCharacteristicUUID @"5C644DB2-7394-4D65-90BF-BA411A696115"
#define readwriteCharacteristicUUID @"149270A4-1D98-4097-A6AA-B0B50E5A2E46"
#define readCharacteristicUUID @"A336F6BB-9516-44F4-9102-D2D41C421AED"


@interface FEIIBleManager()

@property (nonatomic, strong) CBCentralManager *centralManager;


@property (nonatomic, strong) CBCharacteristic *readCharacteristic;

@end

@implementation FEIIBleManager


- (instancetype)initWithTextView:(UITextView *)textView{
    
    if (self = [super init]) {
        
        _textView = textView;
        return self;
        
    }
    return nil;
    
}
//write

- (void)sendDataToPeripharl:(NSString *)str{
    
    if (_readCharacteristic) {
//        NSData *data = [self dataWithString:str];
        
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"--data--%@---datalenth-%lu",data,data.length);
        
        
        [_myPeripheral writeValue:data forCharacteristic:_readCharacteristic type:CBCharacteristicWriteWithResponse];
    }
    
}

//
- (void)initCentralManager{
    
    _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    
}

//创建centralManager后的回调；
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    if (central.state == CBManagerStatePoweredOff) {
        NSLog(@"system ble powered off ,please turn on");
    }
    
    if (central.state == CBManagerStateUnauthorized) {
        NSLog(@"系统没有蓝牙授权");
    }
    
    if (central.state == CBManagerStateUnknown) {
        NSLog(@"蓝牙当前状态不明确");
    }
    if (central.state == CBManagerStateUnsupported) {
        NSLog(@"蓝牙设备不支持");
    }
    if (central.state == CBManagerStatePoweredOn) {
        //扫瞄
        [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kServicesUUID]]  options:nil];
        
    }
    
    
}

//执行扫瞄的动作，如果扫瞄到外设
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
//    if ([self.delegate respondsToSelector:@selector(scanOneReturn:)]) {
//        [self.delegate scanOneReturn:peripheral];
//    }
    
    NSLog(@"perName---%@",peripheral.name);
    
//    if ([peripheral.name isEqualToString:kPeripheralDeviceName] ) {
    
        NSLog(@"%@--connect",kPeripheralDeviceName);
        _myPeripheral = peripheral;
        _myPeripheral.delegate = self;
        
        //连接
        [_centralManager connectPeripheral:_myPeripheral options:nil];
        
//    }
    
}

//连接成功，调用
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    //停止中心设备的扫瞄，要不然你和连接好的好设进行数据沟通时，如果双又有一个外设符合你的连接条件，那么你的ios设备也会去连接这个外设，ble4,支持一对多连接，导致数据混乱
    [_centralManager stopScan];
    
    if ([self.delegate respondsToSelector:@selector(connectSuccessName:)] ) {
        
        [self.delegate connectSuccessName:_myPeripheral.name];
        
    }
    
    //一次读出所有service:
    [_myPeripheral discoverServices:nil];
    
}

//掉线
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    NSLog(@"disconnect---error-%@",error);
    if ([peripheral.name isEqualToString:kCharacteristic]) {
        [_centralManager connectPeripheral:peripheral options:nil];
    }
//    [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kServicesUUID]] options:nil];
    
}

//连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    NSLog(@"connect-failure-%@",error);
}

//连接到外设的服务后UUID回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    NSLog(@"发现服务");
    for (CBService *service in peripheral.services) {
        [_myPeripheral discoverCharacteristics:nil forService:service];
    }
    
}

//成功读取某个特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    for (int i = 0; i < service.characteristics.count; i++) {
        
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        NSLog(@"特征:uuid:%@(%@)",c.UUID.data,c.UUID);
        if ([[c UUID] isEqual:[CBUUID UUIDWithString:kCharacteristic]]) {
            NSLog(@"找到读征");
            _readCharacteristic = c;
            [peripheral setNotifyValue:true forCharacteristic:c];
        }
        
    }
    
}

//向peripheral中写入数据后回调函数
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    NSLog(@"write to success --%@",characteristic);
    
}

//获取外设发来的数据，不论是read和notify，获取数据都是从这个方法读取
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    [peripheral readRSSI];
    NSNumber *rssi = [peripheral RSSI];
//    NSNumber *rssi = [peripheral didRead];
    
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristic]]) {
        
        NSData *data = characteristic.value;
        NSString* value = [self hexadecimalString:data];
        
//        _textView.text = [NSString stringWithFormat:@"characteristic(读取到的) : %@, data : %@, value : %@", characteristic, data, value];
        _textView.text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
//        NSLog(@"characteristic(读取到的) : %@, data : %@, value : %@", characteristic, data, value);
        
    }
    
}

- (void)connectMyPeripheral{
    
    [_centralManager connectPeripheral:_myPeripheral options:nil];
    
}

//将传入的NSData类型转换成NSString并返回
- (NSString*)hexadecimalString:(NSData *)data{
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}
//将传入的NSString类型转换成ASCII码并返回
- (NSData*)dataWithString:(NSString *)string{
    unsigned char *bytes = (unsigned char *)[string UTF8String];
    NSInteger len = string.length;
    return [NSData dataWithBytes:bytes length:len];
}




@end
