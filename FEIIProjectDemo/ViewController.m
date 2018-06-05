//
//  ViewController.m
//  FEIIProjectDemo
//
//  Created by fei li on 2018/5/25.
//  Copyright © 2018年 feii. All rights reserved.
//

#import "ViewController.h"
#import "CustomBtnViewController.h"
#import "CustomViewViewController.h"
#import "TextViewEmojiViewController.h"
#import "TestScrollHeadViewController.h"
#import "FEIIBleChatViewController.h"

#define kScreenWidth [[UIScreen mainScreen]bounds].size.width
#define kScreenHeight [[UIScreen mainScreen]bounds].size.height

#define kCustomComponent 0
#define kTextViewEmoji 1
#define kSomeTest 2
#define kTools 3

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *dataArraySetion;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark initVIews
- (void)setupViews{
    
    [self.view addSubview:self.mainTable];
    
}

#pragma mark someMethods
- (void)gotoCustomBtn{
    
    CustomBtnViewController *gotoVC = [[CustomBtnViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:gotoVC];
    [self presentViewController:nav animated:true completion:nil];
//    [self.navigationController pushViewController:nav animated:true];
    
}

- (void)gotoCustomViews{
    
    CustomViewViewController *gotoVC = [[CustomViewViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:gotoVC];
    [self presentViewController:nav animated:true completion:nil];

    
}

- (void)gotoTextViewsEmoji{
    
    TextViewEmojiViewController *gotoVC = [[TextViewEmojiViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:gotoVC];
    [self presentViewController:nav animated:true completion:nil];
    
    
}
    
- (void)gotoScrollHeader{
    
    
    TestScrollHeadViewController *gotoVC = [[TestScrollHeadViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:gotoVC];
    [self presentViewController:nav animated:true completion:nil];
    
}

- (void)gotoBleChat{
    
    
    FEIIBleChatViewController *gotoVC = [[FEIIBleChatViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:gotoVC];
    [self presentViewController:nav animated:true completion:nil];
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == kCustomComponent) {
        
        if (indexPath.row == 0) {
            [self gotoCustomBtn];
        }
        if (indexPath.row == 1) {
            [self gotoCustomViews];
        }
        
    }
    
    if (indexPath.section == kTextViewEmoji) {
        
        if (indexPath.row == 0) {
            [self gotoTextViewsEmoji];
        }
        
    }
    
    if (indexPath.section == kSomeTest) {
        
        if (indexPath.row == 0) {
            [self gotoScrollHeader];
        }
        
    }
    
    if (indexPath.section == kTools) {
        
        if (indexPath.row == 0) {
            [self gotoBleChat];
        }
        
    }
    
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArraySetion.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary *dic = self.dataArraySetion[section];
    NSArray *array = dic[@"array"];
    return array.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 30;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    
    NSDictionary *dic = self.dataArraySetion[section];
    NSString *title = dic[@"title"];
    label.text = title;
    
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"myCell"];
        
    }
    
    NSDictionary *dic = self.dataArraySetion[indexPath.section];
    NSArray *array = dic[@"array"];
    cell.textLabel.text = array[indexPath.row][@"title"];
    
    return cell;
    
}

#pragma mark lazyLoad
- (UITableView *)mainTable{
    
    if (_mainTable == nil) {
        
        _mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _mainTable.backgroundColor = [UIColor grayColor];
        
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        
    }
    return _mainTable;
    
}

- (NSMutableArray *)dataArraySetion{
    
    if (_dataArraySetion == nil) {
        
        _dataArraySetion = [[NSMutableArray alloc]init];
        
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        
        NSDictionary *dic =@{@"title":@"button"};
        [dataArray addObject:dic];
        dic =@{@"title":@"view"};
        [dataArray addObject:dic];
        NSDictionary *dicSetion =@{@"title":@"customComponent",@"array":dataArray};
        [_dataArraySetion addObject:dicSetion];
        
        
        dataArray = [[NSMutableArray alloc]init];
        dic =@{@"title":@"textViewEmoji"};
        [dataArray addObject:dic];
        dicSetion =@{@"title":@"textViewEmoji",@"array":dataArray};
        [_dataArraySetion addObject:dicSetion];
        
        
        dataArray = [[NSMutableArray alloc]init];
        dic =@{@"title":@"scrollHeader"};
        [dataArray addObject:dic];
        dicSetion =@{@"title":@"sometest",@"array":dataArray};
        [_dataArraySetion addObject:dicSetion];
        
        
        dataArray = [[NSMutableArray alloc]init];
        dic =@{@"title":@"blechat"};
        [dataArray addObject:dic];
        dicSetion =@{@"title":@"tools",@"array":dataArray};
        [_dataArraySetion addObject:dicSetion];
        
    }
    return _dataArraySetion;
    
}

@end
