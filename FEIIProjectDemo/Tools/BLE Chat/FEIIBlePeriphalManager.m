//
//  FEIIBlePeriphalManager.m
//  FEIIProjectDemo
//
//  Created by fei li on 2018/6/3.
//  Copyright © 2018年 feii. All rights reserved.
//

#import "FEIIBlePeriphalManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define kPeripheralDeviceName @"FEII"
#define kServicesUUID @"4E5EA11F-455C-446F-967F-2BF5A9CCFBE9"
#define kCharacteristic @"B4CD9CAC-2C3D-4F35-ADB0-26C3C12BD37D"

#define ServiceUUID1 @"ECBD5F37-4F6A-4A4C-8442-8AA9B9BB39ED"
#define ServiceUUID2 @"AAB8925E-EA78-43A5-86BA-F7FAA9CCB209"

#define notiyCharacteristicUUID @"5C644DB2-7394-4D65-90BF-BA411A696115"
#define readwriteCharacteristicUUID @"149270A4-1D98-4097-A6AA-B0B50E5A2E46"
#define readCharacteristicUUID @"A336F6BB-9516-44F4-9102-D2D41C421AED"

@interface FEIIBlePeriphalManager()<CBPeripheralManagerDelegate>

@property (nonatomic, strong)CBPeripheralManager *peripheralManager;

@property (nonatomic, assign) NSInteger serviceNum;

@property (nonatomic, strong) CBCharacteristic *myCha;

@property (nonatomic, strong) NSTimer *timer;

//@property (nonatomic, copy) NSString *notiyCharacteristicUUID;

@end

@implementation FEIIBlePeriphalManager

- (instancetype)initWithTextView:(UITextView *)textView{
    
    if (self = [super init]) {
        _textView = textView;
        return self;
    }
    return nil;
    
}

- (void)initPeripheralManager{
    
    _peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    
}

//peripheral state
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    
    switch (peripheral.state) {
            //在这里判断蓝牙设别的状态  当开启了则可调用  setUp方法(自定义)
        case CBManagerStatePoweredOn:
            NSLog(@"powered on");
            [self setup];
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"powered off");
            
            break;
        default:
            break;
    }
    
}

//配置蓝牙
- (void)setup{
    
    //characterise字段
    CBUUID *readc = [CBUUID UUIDWithString:kCharacteristic];
    
    /*
     可以通知的Characteristic
     properties：CBCharacteristicPropertyNotify
     permissions CBAttributePermissionsReadable
     */
    CBMutableCharacteristic *notiyCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:notiyCharacteristicUUID] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    /*
     可读写的characteristics
     properties：CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead
     permissions CBAttributePermissionsReadable | CBAttributePermissionsWriteable
     */
    CBMutableCharacteristic *readwriteCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:readwriteCharacteristicUUID] properties:CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable];
    //设置description
//    CBMutableDescriptor *readwriteCharacteristicDescription1 = [[CBMutableDescriptor alloc]initWithType: [CBUUID UUIDWithString:readwriteCharacteristicUUID] value:@"name"];
//    [readwriteCharacteristic setDescriptors:@[readwriteCharacteristicDescription1]];
    /*
     只读的Characteristic
     properties：CBCharacteristicPropertyRead
     permissions CBAttributePermissionsReadable
     */
    CBMutableCharacteristic *readCharacteristic = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:readCharacteristicUUID] properties:CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable];
    //service1初始化并加入两个characteristics
    CBMutableService *service1 = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:ServiceUUID1] primary:YES];
    [service1 setCharacteristics:@[notiyCharacteristic,readwriteCharacteristic]];
    //service2初始化并加入一个characteristics
    CBMutableService *service2 = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:ServiceUUID2] primary:YES];
    [service2 setCharacteristics:@[readCharacteristic]];
    //添加后就会调用代理的- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
    [_peripheralManager addService:service1];
    [_peripheralManager addService:service2];
    
    CBMutableService *service3 = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:kServicesUUID] primary:YES];
    
    CBMutableCharacteristic *cFEii = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:kCharacteristic] properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite|CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable ];
    _myCha = cFEii;
    [service3 setCharacteristics:@[_myCha]];
    
    [_peripheralManager addService:service3];
    
    
}

//perihpheral添加了service
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error{
    if (error == nil) {
        _serviceNum++;
    }
    //因为我们添加了2个服务，所以想两次都添加完成后才去发送广播
    if (_serviceNum==3) {
        //添加服务后可以在此向外界发出通告 调用完这个方法后会调用代理的
        //(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
        [_peripheralManager startAdvertising:@{
                                              CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:ServiceUUID1],[CBUUID UUIDWithString:ServiceUUID2],[CBUUID UUIDWithString:kServicesUUID]],
                                              CBAdvertisementDataLocalNameKey : kPeripheralDeviceName
                                              }
         ];
    }
}
//peripheral开始发送advertising
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    
    _textView.text = @"in advertisiong";
//    if (_returnStr) {
//        if (error == nil) {
//            _returnStr(@"in peripheralManagerDidStartAdvertisiong");
//        }else{
//            _returnStr(@"in error");
//        }
        
//    }
//    NSLog(@"in peripheralManagerDidStartAdvertisiong");
}

//4. 对central的操作进行响应
//
//- 4.1 读characteristics请求
//
//- 4.2 写characteristics请求
//
//- 4.3 订阅和取消订阅characteristics

//订阅characteristics
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic{
    NSLog(@"订阅了 %@的数据",characteristic.UUID);
    //每秒执行一次给主设备发送一个当前时间的秒数
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendData:) userInfo:characteristic  repeats:YES];
}
//取消订阅characteristics
-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic{
    NSLog(@"取消订阅 %@的数据",characteristic.UUID);
    //取消回应
    [_timer invalidate];
}
//发送数据，发送当前时间的秒数
-(BOOL)sendData:(NSTimer *)t {
    CBMutableCharacteristic *characteristic = t.userInfo;
    NSDateFormatter *dft = [[NSDateFormatter alloc]init];
    [dft setDateFormat:@"ss"];
    NSLog(@"%@",[dft stringFromDate:[NSDate date]]);
    //执行回应Central通知数据
    return  [_peripheralManager updateValue:[[dft stringFromDate:[NSDate date]] dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:(CBMutableCharacteristic *)characteristic onSubscribedCentrals:nil];
}
//读characteristics请求
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request{
    NSLog(@"didReceiveReadRequest");
    //判断是否有读数据的权限
    if (request.characteristic.properties & CBCharacteristicPropertyRead) {
        NSData *data = request.characteristic.value;
        [request setValue:data];
        //对请求作出成功响应
        [_peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    }else{
        [_peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
}
//写characteristics请求
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests{
    NSLog(@"didReceiveWriteRequests");
    CBATTRequest *request = requests[0];
    //判断是否有写数据的权限
    if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
        //需要转换成CBMutableCharacteristic对象才能进行写值
        CBMutableCharacteristic *c =(CBMutableCharacteristic *)request.characteristic;
        c.value = request.value;
        [_peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
        
        _textView.text = [NSString stringWithFormat:@"yes data --%@",[[NSString alloc]initWithData:c.value encoding:NSUTF8StringEncoding]];
        
//        _textView.text = [NSString stringWithFormat:@"yes data --%@",[[NSString alloc] initWithData:c.value encoding:NSASCIIStringEncoding]];

    }else{
        [_peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
        _textView.text = @"no quanxian";
    }
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

- (void)writeDataToCentral:(NSString *)str{
    
    BOOL fff =  [_peripheralManager updateValue:[str dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:(CBMutableCharacteristic *)_myCha onSubscribedCentrals:nil];
    NSLog(@"%@",fff?@"yes":@"no");
    
}

@end
