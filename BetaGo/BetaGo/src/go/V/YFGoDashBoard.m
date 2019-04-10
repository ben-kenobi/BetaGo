

//
//  YFGoDashBoard.m
//  BetaGo
//
//  Created by yf on 2019/4/10.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFGoDashBoard.h"
#import "YFMatch.h"
@interface YFGoDashBoard()
@property (nonatomic,strong)YFMatch *match;
@property (nonatomic,strong)UIButton *doneBtn;
@property (nonatomic,strong)UIButton *pauseBtn;
@property (nonatomic,strong)UIButton *saveBtn;
@property (nonatomic,strong)UIButton *settingBtn;
@end

@implementation YFGoDashBoard

-(void)setMatch:(YFMatch *)match{
    _match = match;
    [self updateUI];
}

-(void)updateUI{
    self.pauseBtn.selected = self.match.pause;
    self.doneBtn.enabled = self.match.curChess && !self.match.curChess.done;
}

#pragma mark - actions
-(void)onClick:(id)sender{
    if(sender == self.saveBtn){
        [self.dele dashboard:self saveClick:sender];
    }else if(sender == self.doneBtn){
        [self.dele dashboard:self doneClick:sender];
    }else if(sender == self.settingBtn){
        [self.dele dashboard:self settingClick:sender];
    }else if(sender == self.pauseBtn){
        [self.dele dashboard:self startPuaseClick:sender];
    }
}

#pragma mark - UI
-(instancetype)initWith:(YFMatch *)match{
    if(self = [super init]){
        [self initUI];
        self.match = match;
    }return self;
}
-(void)initUI{
    self.doneBtn = [IProUtil commonTextBtn:iBFont(dp2po(16)) color:iColor(0xff, 0xff, 0xff, 1) title:@"确认落子"];
    [UIUtil commonTexBtn:self.doneBtn tar:self action:@selector(onClick:)];
    
    
    self.saveBtn = [IProUtil commonTextBtn:iFont(dp2po(16)) color:iColor(0x33, 0x33, 0x33, 1) title:@"保存"];
    [UIUtil commonStrokeBtn:self.saveBtn tar:self action:@selector(onClick:)];
    self.saveBtn.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    
    self.settingBtn = [[UIButton alloc]init];
    [self.settingBtn setImage:img(@"setting_icon-1") forState:0];
    self.settingBtn.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [self.settingBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pauseBtn = [IProUtil commonTextBtn:iFont(dp2po(16)) color:iGlobalErrorColor title:@"暂停"];
    [UIUtil commonStrokeBtn:self.pauseBtn tar:self action:@selector(onClick:)];
    [self.pauseBtn setTitle:@"开始" forState:UIControlStateSelected];
    [self.pauseBtn setTitleColor:iGlobalFocusColor forState:UIControlStateSelected];
    self.pauseBtn.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    
    //layout
    [self addSubview:self.doneBtn];
    [self addSubview:self.saveBtn];
    [self addSubview:self.pauseBtn];
    [self addSubview:self.settingBtn];
    
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(dp2po(-18)));
        make.width.equalTo(@(dp2po(120)));
        make.height.equalTo(@(dp2po(48)));
        make.centerX.equalTo(@0);
    }];
    [self.pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.leading.equalTo(@(dp2po(15)));
    }];
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(dp2po(-15)));
        make.bottom.equalTo(self.mas_centerY).offset(-4);
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(dp2po(-15)));
        make.top.equalTo(self.mas_centerY).offset(4);
    }];
}
@end
