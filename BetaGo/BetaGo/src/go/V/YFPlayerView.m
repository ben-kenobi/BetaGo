//
//  YFPlayerView.m
//  BetaGo
//
//  Created by yf on 2019/4/9.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFPlayerView.h"
#import "YFPlayer.h"
#import "YFMatch.h"

@interface YFPlayerView()
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *detailLab;
@end

@implementation YFPlayerView

#pragma mark - actions
-(void)iconClicked{
    if(self.dele)
       [self.dele playerView:self iconClicked:self.icon];
}


#pragma mark - update

-(void)setPlayer:(YFPlayer *)player{
    _player = player;
    [self updateUI];
}
-(void)updateUI{
    self.layer.contents = (__bridge id)(self.player.bgImg.CGImage);
    [self.icon setImage:self.player.iconImg forState:0];
    self.icon.layer.cornerRadius = self.player.iconImg.w *.5;
    
    self.titleLab.text = self.player.title;
    self.detailLab.attributedText = self.player.attrDetail;
    self.titleLab.textColor = self.player.titleColor;
    self.detailLab.textColor = self.player.titleColor;
    
    //layout
    if(self.player.black){
        [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(@(dp2po(8)));
        }];
        [self.detailLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.icon.mas_trailing).offset(dp2po(6));
            make.top.equalTo(self.icon);
        }];
    }else{
        [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@(dp2po(-8)));
            make.top.equalTo(@(dp2po(8)));
        }];
        [self.detailLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.icon.mas_leading).offset(dp2po(-2));
            make.top.equalTo(self.icon);
        }];
    }
    
    
    // round status
    switch (self.player.match.roundType) {
        case RoundTypeNormal:{
            self.icon.layer.borderColor = [UIColor clearColor].CGColor;
            self.icon.layer.shadowOpacity = 0;
            if(self.player.match.curPlayer.black == self.player.black){
                [self.icon.layer addAnimation:YFGoUtil.playerPlayingAnimation forKey:@"ani"];
            }else{
                [self.icon.layer removeAllAnimations];
            }
        }break;
        case RoundTypeBlack:
        case RoundTypeWhite:{
            [self.icon.layer removeAllAnimations];
            if(self.player.match.curPlayer.black == self.player.black){
                self.icon.layer.borderColor = iGlobalFocusColor.CGColor;
                self.icon.layer.shadowOpacity = 1;
            }else{
                self.icon.layer.borderColor = [UIColor clearColor].CGColor;
                self.icon.layer.shadowOpacity = 0;
            }
        }break;
    }

}

#pragma mark - UI

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }return self;
}


-(void)initUI{
    
    
    self.icon = [[UIButton alloc]init];
    [self.icon addTarget:self action:@selector(iconClicked) forControlEvents:UIControlEventTouchUpInside];
    [UIUtil commonShadowWithColor:iGlobalFocusColor Radius:5 size:CGSizeMake(0, 1) view:self.icon opacity:0];
    self.icon.layer.borderWidth = dp2po(5);
    
    self.titleLab = [IProUtil commonLab:iBFont(dp2po(16)) color:iColor(0x33, 0x33, 0x33, 1)];
    self.detailLab = [IProUtil commonLab:iBFont(dp2po(13)) color:iColor(0x88, 0x88, 0x88, 1)];
    self.detailLab.numberOfLines = 0;
    
    //layout
    [self addSubview:self.icon];
    [self addSubview:self.titleLab];
    [self addSubview:self.detailLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.icon);
        make.top.equalTo(self.icon.mas_bottom).offset(dp2po(8));
    }];
    
}


@end
