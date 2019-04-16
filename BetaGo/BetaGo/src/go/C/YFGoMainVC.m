
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
#import "YFGoSettingVC.h"
#import "YFMatchList.h"
#import "YFMatchListVC.h"

@interface YFGoMainVC ()<YFGoDashBoardDele>
@property (nonatomic,strong)YFChessBoradView *board;
@property (nonatomic,strong)YFMatch *match;
@property (nonatomic,strong)UIButton *doneBtn;
@property (nonatomic,strong)YFPlayersView *playersView;
@property (nonatomic,strong)YFGoDashBoard *dashBoard;
@end

@implementation YFGoMainVC

- (void)viewDidLoad {
    self.noContentType=BCNoContentnNoMatch;
    [super viewDidLoad];
    [self initUI];
    [iNotiCenter addObserver:self selector:@selector(updateUI) name:kMatchStatusChangeNoti object:0];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIUtil commonNav:self shadow:YES line:NO translucent:NO color:iColor(207, 168, 110, .8)];
    [self updateUI];
}
-(void)dealloc{
    [iNotiCenter removeObserver:self];
}
-(void)newMatchWith:(NSInteger)lines{
    self.match = [[YFMatch alloc]initMatchWith:(int)lines];
}
- (void)loadData {
    self.match = [YFMatchList.shared selectedMatch];
}

-(void)setMatch:(YFMatch *)match{
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    _match = match;
    if(match)
        [self initMatchView];
    self.loading = NO;
    self.title = match ? match.title : @"Go";
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
-(void)historyClick:(id)sender{
    YFMatchListVC *vc = [[YFMatchListVC alloc]init];
    vc.selectedCB = ^(YFMatch * _Nonnull match) {
        self.match = match;
    };
    [UIViewController pushVC:vc];
}
-(void)addClick:(id)sender{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"新建对局" message:@"选中棋盘" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *nineAct = [UIAlertAction actionWithTitle:@"9路棋盘" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self newMatchWith:9];
    }];
    UIAlertAction *elevenAct = [UIAlertAction actionWithTitle:@"11路棋盘" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self newMatchWith:11];
    }];
    UIAlertAction *nineteenAct = [UIAlertAction actionWithTitle:@"19路棋盘" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self newMatchWith:19];
    }];
    [vc addAction:nineAct];
    [vc addAction:elevenAct];
    [vc addAction:nineteenAct];
    [UIViewController.topVC presentViewController:vc animated:YES
                                       completion:0];
}

#pragma - mark YFGoDashBoardDele
-(void)dashboard:(YFGoDashBoard *)dashboard startPuaseClick:(UIButton *)btn{
    [self setPause: !self.match.pause];
}
-(void)dashboard:(YFGoDashBoard *)dashboard doneClick:(UIButton *)btn{
    [self.board confirmAddChess];
}
-(void)dashboard:(YFGoDashBoard *)dashboard settingClick:(UIButton *)btn{
    YFGoSettingVC *vc = [[YFGoSettingVC alloc]init];
    vc.match = self.match;
    [UIViewController.topVC presentViewController:vc animated:YES completion:0];
}
-(void)dashboard:(YFGoDashBoard *)dashboard saveClick:(UIButton *)btn{
    [YFMatchList.shared saveMatch:self.match];
    btn.enabled = NO;
}


-(BOOL)hasData{
    return self.match;
}
-(void)noContentNormalCB{
    [self addClick:nil];
}

-(void)onNoContent:(BOOL)show{
    if(show){
        [self.view addSubview:self.noContent];
        [self.noContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.width.height.equalTo(self.view);
        }];
        [self.view layoutIfNeeded];
    }else{
        [self.noContent removeFromSuperview];
    }
}


#pragma mark - UI

-(void)updateUI{
    [self.playersView updateUI];
    [self.dashBoard updateUI];
    [self.board updateUI];
}

-(void)initMatchView{
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

-(void)initUI{
    self.title = @"GO";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:img(@"sensitivity_icon") style:(UIBarButtonItemStylePlain) target:self action:@selector(onMenuClicked)];
    self.view.layer.contents = (__bridge id)(imgFromF(iRes(@"main_bg.jpeg")).CGImage);
    self.navigationItem.rightBarButtonItems=@[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemBookmarks) target:self action:@selector(historyClick:)],[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(addClick:)]];

}
    
#pragma mark - UIBarButtonItem Event
-(void)onMenuClicked{
    [[iAppDele mainVC] leftClick:YES];
}
@end
