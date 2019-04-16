
//
//  YFMatchListVC.m
//  BetaGo
//
//  Created by yf on 2019/4/16.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFMatchListVC.h"
#import "YFMatchList.h"
#import "YFMatchListCell.h"
#import "YFMatchInfoVC.h"

NSString *celliden = @"celliden";

@interface YFMatchListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tv;
@property (nonatomic,strong)YFMatchList *vm;
@end

@implementation YFMatchListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.vm = YFMatchList.shared;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tv reloadData];
}

#pragma mark - UITableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.vm.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFMatchListCell *cell = (YFMatchListCell*)[tableView dequeueReusableCellWithIdentifier:celliden];
    cell.match=[self.vm getBy:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [UIViewController popVC];
    if(self.selectedCB)
        self.selectedCB([self.vm getBy:indexPath]);
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    YFMatchInfoVC *vc = [[YFMatchInfoVC alloc]init];
    vc.match = [self.vm getBy:indexPath];
    [UIViewController pushVC:vc];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.vm rmAt:indexPath];
    [self.tv reloadData];
}



#pragma mark - UI

-(void)initUI{
    self.view.backgroundColor=iColor(0xFB, 0xFB, 0xFB, 1);
    self.title = @"棋局列表";
    
    self.tv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tv.bounces=YES;
    self.tv.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tv.tableFooterView=[[UIView alloc]init];
    self.tv.delegate=self;
    self.tv.dataSource=self;
    self.tv.backgroundColor=iColor(0xFB, 0xFB, 0xFB, 1);
    [self.tv registerClass:[YFMatchListCell class] forCellReuseIdentifier:celliden];
    self.tv.rowHeight=UITableViewAutomaticDimension;
    self.tv.estimatedRowHeight=60;
    
    // layout ------
    [self.view addSubview:self.tv];
    [self.tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
}

@end
