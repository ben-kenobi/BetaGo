
//
//  YFPlayer.m
//  BetaGo
//
//  Created by yf on 2019/4/9.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFPlayer.h"
#import "YFChessFragment.h"
#import "YFChess.h"
@implementation YFPlayer

+(instancetype)playerWith:(BOOL)black{
    YFPlayer *player = [[self alloc]init];
    player.black = black;
    return player;
}


#pragma mark - UI properties
-(UIImage *)iconImg{
    YFChess *chess = [YFChess chessWith:self.black];
    return [chess.bgimg roundImg:dp2po(46) boderColor:iCommonSeparatorColor borderW:dp2po(.5)];
}
-(UIImage *)bgImg{
    return nil;
}
-(NSString *)title{
    return self.black ? @"黑方" : @"白方";
}
-(UIColor *)titleColor{
    return self.black ? iColor(0x33, 0x33, 0x33, 1) : iColor(0xee, 0xee, 0xee, 1);
}

-(NSAttributedString *)attrDetail{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 8;
    paragraphStyle.alignment=NSTextAlignmentLeft;
    
    NSString *str = iFormatStr(@"落子数：%ld\n提子数：%ld\n总时长：%@",self.playCount,self.getCount,[YFGoUtil durationDesc:self.playDuration*1000]);
    
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
    return mstr;
}


#pragma mark - datas
-(void)beginRound{
    self.beginTime = [[NSDate date]timeIntervalSince1970];
}

-(void)endRoundWith:(NSArray<YFChessFragment *> *)list{
    self.playDuration += [[NSDate date]timeIntervalSince1970] - self.beginTime;
    self.playCount += 1;
    [self getChess:list];
}

-(void)getChess:(NSArray<YFChessFragment *> *)list{
    for(YFChessFragment *frag in list){
        if(!frag.free){
            self.getCount += frag.list.count;
        }
    }
}
-(void)setPause:(BOOL)pause{
    if(pause){
        self.playDuration += [[NSDate date]timeIntervalSince1970] - self.beginTime;
    }else{
        [self beginRound];
    }
}

-(NSTimeInterval)beginTime{
    if(_beginTime > 0) return _beginTime;
    return [[NSDate date] timeIntervalSince1970];
}


#pragma mark - overrided
- (id)initWithCoder:(NSCoder *)coder
{
    if(self = [super init]){
        self.playCount = [coder decodeIntegerForKey:@"playCount"];
        self.getCount = [coder decodeIntegerForKey:@"getCount"];
        self.playDuration = [coder decodeDoubleForKey:@"playDuration"];
        self.black = [coder decodeBoolForKey:@"black"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:self.playCount forKey:@"playCount"];
    [coder encodeInteger:self.getCount forKey:@"getCount"];
    [coder encodeDouble:self.playDuration forKey:@"playDuration"];
    [coder encodeBool:self.black forKey:@"black"];
}
@end
