
//
//  YFGoMainVC.m
//  BetaGo
//
//  Created by yf on 2019/3/7.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFGoMainVC.h"
#import "YFChessBoradView.h"
#import "YFMatch.h"
#import "YFPlayersView.h"
#import "YFGoDashBoard.h"

@interface YFGoMainVC ()<YFGoDashBoardDele>
@property (nonatomic,strong)YFChessBoradView *board;
@property (nonatomic,strong)YFMatch *match;
@property (nonatomic,strong)UIButton *doneBtn;
@property (nonatomic,strong)YFPlayersView *playersView;
@property (nonatomic,strong)YFGoDashBoard *dashBoard;
@end

@implementation YFGoMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [iNotiCenter addObserver:self selector:@selector(updateUI) name:kMatchStatusChangeNoti object:0];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIUtil commonNav:self shadow:YES line:NO translucent:NO color:iColor(207, 168, 110, .8)];
    [self updateUI];
}
-(void)dealloc{
    [iNotiCenter removeObserver:self];
}

#pragma mark - actions
-(void)setPause:(BOOL)pause{
    static __weak UIView *cover = nil;
    if(pause){
        UIView *view = [UIView viewWithColor:iColor(0xff, 0xff, 0xff, .2)];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.board);
        }];
        cover = view;
    }else{
        [cover removeFromSuperview];
    }
    self.match.pause = pause;
}

#pragma - mark YFGoDashBoardDele
-(void)dashboard:(YFGoDashBoard *)dashboard startPuaseClick:(UIButton *)btn{
    
}
-(void)dashboard:(YFGoDashBoard *)dashboard doneClick:(UIButton *)btn{
    [self.board confirmAddChess];
}
-(void)dashboard:(YFGoDashBoard *)dashboard settingClick:(UIButton *)btn{
    
}
-(void)dashboard:(YFGoDashBoard *)dashboard saveClick:(UIButton *)btn{
    
}

#pragma mark - UI

-(void)updateUI{
    [self.playersView updateUI];
    [self.dashBoard updateUI];
}


-(void)initUI{
    self.title = @"GO";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:img(@"sensitivity_icon") style:(UIBarButtonItemStylePlain) target:self action:@selector(onMenuClicked)];
    self.view.layer.contents = (__bridge id)(imgFromF(iRes(@"main_bg.jpeg")).CGImage);
    
    //init
    self.match = [[YFMatch alloc]initMatchWith:13];
    self.board = [[YFChessBoradView alloc]initWith:self.match];
    self.playersView = [[YFPlayersView alloc]initWithMatch:self.match];
    self.board.playerView = self.playersView;
    
    self.dashBoard = [[YFGoDashBoard alloc]initWith:self.match];
    self.dashBoard.dele=self;
    
   
    
    //layout --
    [self.view addSubview:self.board];
    [self.view addSubview:self.playersView];
    [self.view addSubview:self.dashBoard];
    [self.board mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.leading.trailing.equalTo(@0);
        make.width.equalTo(self.board.mas_height);
    }];
    
    [self.playersView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.bottom.equalTo(self.board.mas_top);
    }];
    [self.dashBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottomMargin);
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(self.board.mas_bottom);
    }];
    
   
    [self setPause:NO];
    
}
#pragma mark - UIBarButtonItem Event
-(void)onMenuClicked{
    [[iAppDele mainVC] leftClick:YES];
}
@end
