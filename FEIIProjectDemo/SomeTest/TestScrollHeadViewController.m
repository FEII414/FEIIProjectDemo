//
//  TestScrollHeadViewController.m
//  FEIIProjectDemo
//
//  Created by fei li on 2018/5/30.
//  Copyright © 2018年 feii. All rights reserved.
//

#import "TestScrollHeadViewController.h"
#define kScreenWidth [[UIScreen mainScreen]bounds].size.width
#define kScreenHeight [[UIScreen mainScreen]bounds].size.height
@interface TestScrollHeadViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
    
    @property (nonatomic, assign) BOOL type;
    @property (nonatomic, strong) UITableView *mainTable;
    @property (nonatomic, assign) CGPoint leftP;
    @property (nonatomic, assign) CGPoint rightP;
@property (nonatomic, strong) UICollectionView *mainCollection;

@end

@implementation TestScrollHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismiss{
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}
    
- (void)setupViews{
    
    
    UIScrollView *mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight)];
    mainScroll.backgroundColor = [UIColor redColor];
    mainScroll.contentSize = CGSizeMake(0, kScreenHeight+44+kScreenHeight-44-64);
    mainScroll.bounces = NO;
    
    [self.view addSubview:mainScroll];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor blueColor];
    [mainScroll addSubview:view];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 44)];
    view2.backgroundColor = [UIColor greenColor];
    [mainScroll addSubview:view2];
    
    UITableView *mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view2.frame), kScreenWidth, kScreenHeight-64-44) style:UITableViewStylePlain];
    mainTable.backgroundColor = [UIColor grayColor];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.rowHeight = 44;
    
    [mainScroll addSubview:mainTable];
    self.mainTable = mainTable;
    
    
    [mainScroll addSubview:self.mainCollection];
    
    
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_type){
        return 20;
    }
    
    return 26;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
    
}
    
    - (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitle:@"click" forState:UIControlStateNormal];
        btn.frame = CGRectMake(20, 5, 100, 30);
        [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        return view;
        
    }
    
    - (void)clickBtn{
        
//        [self.mainTable setContentOffset:CGPointMake(0, 200)];
//
//        return;
        _type = !_type;
        
        if(_type){
            _leftP = self.mainTable.contentOffset;
        }else{
            _rightP = self.mainTable.contentOffset;
        }
        
//        if(_type){
//            [self.mainTable setContentOffset:_rightP];
//        }else{
//            [self.mainTable setContentOffset:_leftP];
//        }
        
        [self.mainTable reloadData];
        [self.mainTable layoutIfNeeded];
        if(_type){
            [self.mainTable setContentOffset:_rightP];
        }else{
            [self.mainTable setContentOffset:_leftP];
        }
        
//        [self.mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }
    
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_type){
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    NSArray *array = [NSArray arrayWithObjects:[UIColor redColor],[UIColor magentaColor],[UIColor cyanColor], nil];
    
    cell.backgroundColor = array[indexPath.row%array.count];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
        return cell;}
    else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell111"];
        if(cell == nil){
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell111"];
            
        }
        NSArray *array = [NSArray arrayWithObjects:[UIColor redColor],[UIColor magentaColor],[UIColor cyanColor], nil];
        
        cell.backgroundColor = [UIColor yellowColor];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        
        return cell;
        
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return 3000;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TestCell *cell = [_mainCollection dequeueReusableCellWithReuseIdentifier:@"testCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (UICollectionView *)mainCollection{
    
    if (_mainCollection == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.itemSize = CGSizeMake(20, 20);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _mainCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
        _mainCollection.dataSource = self;
        _mainCollection.delegate = self;
        _mainCollection.pagingEnabled = true;
        
        [_mainCollection registerClass:[TestCell class] forCellWithReuseIdentifier:@"testCell"];
        
    }
    
    return _mainCollection;
    
}

@end


@implementation TestCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        return self;
    }
    return nil;
    
}

- (void)setupViews{
    
    
    UIImageView *vie = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    vie.backgroundColor = [UIColor redColor];
    vie.layer.masksToBounds = true;
    vie.layer.cornerRadius = 10;
    [self.contentView addSubview:vie];
    
}


@end
