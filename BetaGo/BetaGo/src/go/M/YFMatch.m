//
//  YFMatch.m
//  BetaGo
//
//  Created by yf on 2019/3/7.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFMatch.h"
#import "YFChessFragment.h"


@implementation YFMatch
-(instancetype)initMatchWith:(int)lines{
    if(self = [super init]){
        self.ID = [NSUUID UUID].UUIDString;
        self.createTime = [NSDate date];
        self.lastSavedTime = [NSDate date];
        self.remark = @"";
        self.title = self.ID;
        self.board = [[YFChessBoard alloc]initWithLines:lines];
        self.players = @[[YFPlayer playerWith:YES],[YFPlayer playerWith:NO]];
        
        //TODO TEST
        //test begin
        for(int i=0;i<0;i++){
            [self beginNextRound];
            [self canPlayThisRoundAt:i y:0];
            [self doneThisRound:NO];
        }
        self.showRound=YES;
        self.needConfirm=YES;
        self.needWarning=YES;
        self.canDelete=YES;
        self.needFeedback=YES;
        self.canMove = YES;
      //test end
    }return self;
}


#pragma mark - actions
-(void)setShowRound:(BOOL)showRound{
    _showRound=showRound;
}


-(void)statusChange{
    [iNotiCenter postNotificationName:kMatchStatusChangeNoti object:0];
}


#pragma mark - round
-(void)beginNextRound{
    self.round += 1;
    switch (self.roundType) {
        case RoundTypeNormal:
            self.curChess = [YFChess chessWith:self.round%2];
            break;
        case RoundTypeBlack:
            self.curChess = [YFChess chessWith:YES];
            break;
        case RoundTypeWhite:
            self.curChess = [YFChess chessWith:NO];
            break;
    }
    self.curChess.round = self.round;
    self.curChess.board = self.board;
    [self statusChange];
}
-(BOOL)canPlayThisRoundAt:(int)x y:(int)y{
    self.curChess.x = x; self.curChess.y =y;
    return [self canPlayChess:self.curChess at:x y:y];
}
-(NSArray<YFChessFragment *> *)doneThisRound:(BOOL)cal{
    NSArray<YFChessFragment *> * rmary = [self move:self.curChess toX:self.curChess.x y:self.curChess.y cal:cal];
    [self.curPlayer endRoundWith:rmary];
    [self.nextPlayer beginRound];
    self.curChess.done = YES;
    if(self.needFeedback){
        [YFGoUtil feedbackWhenChessDone];
    }
    [self statusChange];
    return rmary;
}
-(void)updateRoundType:(RoundType)type{
    if(self.roundType == type)
        _roundType = RoundTypeNormal;
    else
        _roundType = type;
    [self statusChange];
}


-(void)prevRound{
    
}

-(void)setPause:(BOOL)pause{
    _pause = pause;
    //暂停时暂时结束当前用户
    [self.curPlayer setPause:pause];
    [self statusChange];
}

-(NSInteger)curRound{
    NSInteger round = self.round;
    //当前已经下完，则算下一轮
    if(self.curChess.done){
        round += 1;
    }
    round = MAX(1, round);//还未开始也算第一轮
    return round;
}
-(YFPlayer *)curPlayer{
    switch (self.roundType) {
        case RoundTypeNormal:
            return self.players[(self.curRound-1)%self.players.count];
        case RoundTypeBlack:
            return self.players[0];
        case RoundTypeWhite:
            return self.players[1];
    }
    
}
-(YFPlayer *)nextPlayer{
    switch (self.roundType) {
        case RoundTypeNormal:
             return self.players[(self.curRound)%self.players.count];
        case RoundTypeBlack:
            return self.players[0];
        case RoundTypeWhite:
            return self.players[1];
    }
}
-(YFPlayer *)playerBy:(YFChess *)chess{
    NSInteger idx = chess.black ? 0 : 1;
    return self.players[idx];
}

#pragma mark - move
-(BOOL)canPlayChess:(YFChess *)chess at:(int)x y:(int)y{
    x = MIN(MAX(0, x),self.board.numOfLines-1);
    y = MIN(MAX(0, y),self.board.numOfLines-1);
    
    int ox = chess.x;
    int oy = chess.y;
    
    if(![self.board canPlayAtX:x y:y]) return NO;
    
    
    BOOL can = NO;
    do{
        NSArray<YFChessFragment *> * rmary = [self move:chess toX:x y:y cal:YES];
        for(YFChessFragment *frag in rmary){
            if(!frag.free){
                can = YES;
                break;
            }
        }
        if(can) break;
        
        YFChessFragment *frag = [[YFChessFragment alloc]init];
        frag.needWarning = self.needWarning;
        [frag calLibertyAt:chess board:self.board];
        can = frag.free;
    }while (0);
    if(chess.done)
        [self move:chess toX:ox y:oy cal:NO];
    else
        [self.board rmChess:chess];
    return can;
    
}

-(NSArray<YFChessFragment *> *)confirmMove:(YFChess *)chess toX:(int)x y:(int)y{
    NSArray<YFChessFragment *> *rmary = [self move:chess toX:x y:y cal:YES];
    [[self playerBy:chess] getChess:rmary];
    [self statusChange];
    return rmary;
}

-(NSArray<YFChessFragment *> *)move:(YFChess *)chess toX:(int)x y:(int)y cal:(BOOL)cal{
    [self.board rmChess:chess];
    chess.x = x;chess.y = y;
    [self.board addChess:chess];
    if(cal)
        return [self calculateLibertyNrmDead:chess];
    return nil;
}




#pragma mark - calculate
/**
 计算当前落子是否会产生提子
 @return 返回需要提子的数组
 */
-(NSArray<YFChessFragment *> *)calculateLibertyNrmDead:(YFChess *)ochess{
    NSMutableArray<YFChessFragment *> *mary = [NSMutableArray array];
    NSArray<YFChess *> * sibChesses = [self.board findSiblingChessBy:ochess];
    
    //迭代当前子四周的其他棋子，找出其他棋子的相连子，
    for(int i=0;i<sibChesses.count;i++){
        YFChess *chess = sibChesses[i];
        if(ochess.black == chess.black) continue;//如果同色，则不计算
        BOOL contain = NO;
        for(YFChessFragment *frag in mary){
            contain = [frag contain:chess];
            if(contain){
                break;
            }
        }
        if(contain)continue;//如果已经计算过该子，则不在计算
        
        YFChessFragment *frag = [[YFChessFragment alloc]init];
        frag.needWarning = self.needWarning;
        [frag calLibertyAt:chess board:self.board];
        [mary addObject:frag];
    }
    return mary;
}



#pragma mark - UI functions
-(NSAttributedString *)detailAttrDesc{
    NSMutableAttributedString *mastr = [[NSMutableAttributedString alloc]init];
    [mastr appendAttributedString:[[NSAttributedString alloc]initWithString:iFormatStr(@"%@\n",self.remark)]];
    [mastr appendAttributedString: [[NSAttributedString alloc]initWithString:self.createTime.timeFormat2 attributes:@{NSForegroundColorAttributeName:iColor(0xaa, 0xaa, 0xaa, 1)}]];
    [mastr appendAttributedString:[[NSAttributedString alloc] initWithString:@"创建\n" attributes:@{NSForegroundColorAttributeName:iColor(0x88, 0x88, 0x88, 1)}]];
    [mastr appendAttributedString: [[NSAttributedString alloc]initWithString:self.lastSavedTime.timeFormat2 attributes:@{NSForegroundColorAttributeName:iColor(0xaa, 0xaa, 0xaa, 1)}]];
    [mastr appendAttributedString:[[NSAttributedString alloc] initWithString:@"保存" attributes:@{NSForegroundColorAttributeName:iColor(0x99, 0x88, 0x88, 1)}]];
    return [[NSAttributedString alloc] initWithAttributedString:mastr];
}

-(NSAttributedString *)titleAttrDesc{
    return [[NSAttributedString alloc]initWithString:iFormatStr(@"(%d路)%@",self.board.numOfLines,self.title)];
}


#pragma mark - getter & setter
-(void)setPlayers:(NSArray<YFPlayer *> *)players{
    _players = players;
    [_players enumerateObjectsUsingBlock:^(YFPlayer *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.match = self;
    }];
}

@end
