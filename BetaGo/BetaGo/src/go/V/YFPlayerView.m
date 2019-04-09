//
//  YFPlayerView.m
//  BetaGo
//
//  Created by yf on 2019/4/9.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFPlayerView.h"
#import "YFPlayer.h"

@interface YFPlayerView()
@property (nonatomic,strong)UIImageView *icon;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *detailLab;
@end

@implementation YFPlayerView

-(void)setPlayer:(YFPlayer *)player{
    _player = player;
    [self updateUI];
}
-(void)updateUI{
    self.layer.contents = (__bridge id)(self.player.bgImg.CGImage);
    self.icon.image = self.player.iconImg;
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
}

#pragma mark - UI

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }return self;
}


-(void)initUI{
    
    
    self.icon = [[UIImageView alloc]init];
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
