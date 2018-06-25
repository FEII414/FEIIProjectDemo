//
//  FEIIBleChatViewController.m
//  FEIIProjectDemo
//
//  Created by fei li on 2018/6/3.
//  Copyright © 2018年 feii. All rights reserved.
//

#import "FEIIBleChatViewController.h"
#import "FEIIBleManager.h"
#import "FEIIBlePeriphalManager.h"

@interface FEIIBleChatViewController ()<FEIIBleManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITextView *textViewCenterl;
@property (nonatomic, strong) UITextView *textPeripheral;

@property (nonatomic, strong) FEIIBleManager *centerManager;
@property (nonatomic, strong) FEIIBlePeriphalManager *periManager;

@property (nonatomic, strong) NSMutableArray *arrayDatas;
@property (nonatomic, strong) UITableView *mainTable;

@end

@implementation FEIIBleChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"return" style:UIBarButtonItemStyleDone target:self action:@selector(dimiss)];
    
    [self setupViews];
    
}

- (void)setupViews{
    
    UIButton *btnCentral = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCentral.backgroundColor = [UIColor redColor];
    [btnCentral setTitle:@"central" forState:UIControlStateNormal];
    [btnCentral addTarget:self action:@selector(clickCenter:) forControlEvents:UIControlEventTouchUpInside];
    btnCentral.frame = CGRectMake(10, 88, 120, 32);
    [self.view addSubview:btnCentral];
    
    _textViewCenterl = [[UITextView alloc]initWithFrame:CGRectMake(10, 130, 300, 80)];
    _textViewCenterl.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_textViewCenterl];
    
    UIButton *btnCentralSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCentralSend.backgroundColor = [UIColor redColor];
    [btnCentralSend setTitle:@"centralSend" forState:UIControlStateNormal];
    [btnCentralSend addTarget:self action:@selector(clickCenterSend:) forControlEvents:UIControlEventTouchUpInside];
    btnCentralSend.frame = CGRectMake(10, 220, 120, 32);
    [self.view addSubview:btnCentralSend];
    
    
    UIButton *btnPeriphal = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPeriphal.backgroundColor = [UIColor redColor];
    [btnPeriphal setTitle:@"periphal" forState:UIControlStateNormal];
    [btnPeriphal addTarget:self action:@selector(clickPeriphal:) forControlEvents:UIControlEventTouchUpInside];
    btnPeriphal.frame = CGRectMake(10, 262, 120, 32);
    [self.view addSubview:btnPeriphal];
    
    _textPeripheral = [[UITextView alloc]initWithFrame:CGRectMake(10, 304, 300, 80)];
    _textPeripheral.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_textPeripheral];
    
    UIButton *btnPeriphalSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPeriphalSend.backgroundColor = [UIColor redColor];
    [btnPeriphalSend setTitle:@"periphalSend" forState:UIControlStateNormal];
    [btnPeriphalSend addTarget:self action:@selector(clickPeriphalSend:) forControlEvents:UIControlEventTouchUpInside];
    btnPeriphalSend.frame = CGRectMake(10, 394, 120, 32);
    [self.view addSubview:btnPeriphalSend];
    
    
}

- (void)clickCenter:(UIButton *)sender{
    
    _centerManager = [[FEIIBleManager alloc]initWithTextView:_textViewCenterl];
    _centerManager.delegate = self;
    [_centerManager initCentralManager];
    
    
//    [self.view addSubview:self.mainTable];
    
}

- (void)clickPeriphal:(UIButton *)sender{
    
    _periManager = [[FEIIBlePeriphalManager alloc]initWithTextView:_textPeripheral];
    [_periManager initPeripheralManager];
    
    __weak typeof(self) weakSelf = self;
    _periManager.returnStr = ^(NSString *str) {
        weakSelf.textPeripheral.text = str;
    };
    
}

- (void)clickCenterSend:(UIButton *)sender{
    
    [_centerManager sendDataToPeripharl:_textViewCenterl.text];
    
}

- (void)clickPeriphalSend:(UIButton *)sender{
    
    [_periManager writeDataToCentral:_textPeripheral.text];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CBPeripheral *per = self.arrayDatas[indexPath.row];
    _centerManager.myPeripheral = per;
    _centerManager.myPeripheral.delegate = _centerManager;
    
    [_centerManager connectMyPeripheral];
    
    [self.mainTable removeFromSuperview];

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testff"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"testff"];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    CBPeripheral *periphalName = self.arrayDatas[indexPath.row];
    cell.textLabel.text = periphalName.name;
    
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayDatas.count;
}


- (void)dimiss{
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:true];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connectSuccessName:(NSString *)periphalName{
    
    _textViewCenterl.text = [NSString stringWithFormat:@"连接上了--%@--",periphalName];
    
}


- (void)scanOneReturn:(CBPeripheral *)periphalName{
    
    [self.arrayDatas addObject:periphalName];
    [self.mainTable reloadData];
    
}

- (NSMutableArray *)arrayDatas{
    
    if (_arrayDatas == nil) {
        
        _arrayDatas = [[NSMutableArray alloc]init];
        
    }
    return _arrayDatas;
    
}

- (UITableView *)mainTable{
    
    if (_mainTable == nil) {
        _mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 400) style:UITableViewStyleGrouped];
        _mainTable.backgroundColor = [UIColor grayColor];
        
        _mainTable.dataSource = self;
        _mainTable.delegate = self;
        _mainTable.rowHeight = 44;
        
    }
    
    return _mainTable;
    
    
}

@end
