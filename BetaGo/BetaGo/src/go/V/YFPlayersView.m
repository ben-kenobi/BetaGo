//
//  YFPlayersView.m
//  BetaGo
//
//  Created by yf on 2019/4/9.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFPlayersView.h"
#import "YFPlayerView.h"


@interface YFPlayersView()
@property (nonatomic,copy)NSArray<YFPlayerView *> *playersView;
@property (nonatomic,strong)YFMatch *match;
@end

@implementation YFPlayersView

-(void)updateUI{
    for(YFPlayerView *view in self.playersView){
        [view updateUI];
    }
}
-(UIView *)playerViewBy:(BOOL)black{
    return black ? self.playersView[0] : self.playersView[1];
}
#pragma mark - UI
-(instancetype)initWithMatch:(YFMatch *)match{
    if(self = [super init]){
        self.match = match;
        [self initUI];
    }return self;
}
-(void)initUI{
    NSMutableArray<YFPlayerView *> *playersView = [NSMutableArray array];
    YFPlayerView *lastview = nil;
    for(int i=0;i<self.match.players.count;i++){
        YFPlayerView *view = [[YFPlayerView alloc]init];
        view.player = self.match.players[i];
        [playersView addObject:view];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(self);
            if(lastview){
                make.leading.equalTo(lastview.mas_trailing);
                make.width.equalTo(lastview);
            }else
                make.leading.equalTo(@0);
        }];
        
        lastview = view;
        if(i < self.match.players.count-1){
            UIView *line = [UIView viewWithColor:iColor(0x33, 0x33, 0x33, .4)];
            [self addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(lastview);
                make.width.equalTo(@2);
                make.top.equalTo(@20);
                make.bottom.equalTo(@-20);
            }];
        }
    }
    [lastview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@0);
    }];
    
    self.playersView = playersView;
}





@end
