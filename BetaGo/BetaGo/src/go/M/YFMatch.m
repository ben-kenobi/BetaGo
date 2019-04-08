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
        self.board = [[YFChessBoard alloc]initWithLines:lines];
        
        //TODO TEST
        for(int i=0;i<9;i++){
            [self beginNextRound];
            [self canPlayThisRoundAt:i y:0];
            [self doneThisRound:NO];
        }
        self.showRound=YES;
        self.needConfirm=NO;
    }return self;
}

-(void)setShowRound:(BOOL)showRound{
    _showRound=showRound;
}



#pragma mark - round
-(void)beginNextRound{
    switch (self.roundType) {
        case RoundTypeNormal:
            self.round += 1;
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
}
-(BOOL)canPlayThisRoundAt:(int)x y:(int)y{
    x = MIN(MAX(0, x),self.board.numOfLines-1);
    y = MIN(MAX(0, y),self.board.numOfLines-1);
    return [self chess:self.curChess canPlayAtX:x y:y];
}
-(NSArray<YFChessFragment *> *)doneThisRound:(BOOL)cal{
    [self.board addChess:self.curChess];
    if(cal)
        return [self calculateLibertyNrmDead];
    return nil;
}


-(void)prevRound{
    
}

-(BOOL)chess:(YFChess *)chess canPlayAtX:(int)x y:(int)y{
    chess.x = x;chess.y = y;
    return [self.board canAdd:chess];
}


#pragma mark - calculate
/**
 计算当前落子是否会产生提子
 @return 返回需要提子的数组
 */
-(NSArray<YFChessFragment *> *)calculateLibertyNrmDead{
    NSMutableArray<YFChessFragment *> *mary = [NSMutableArray array];
    NSArray<YFChess *> * sibChesses = [self.board findSiblingChessBy:self.curChess];
    
    //迭代当前子四周的其他棋子，找出其他棋子的相连子，
    for(int i=0;i<sibChesses.count;i++){
        YFChess *chess = sibChesses[i];
        if(chess.black == self.curChess.black) continue;//如果同色，则不计算
        BOOL contain = NO;
        for(YFChessFragment *frag in mary){
            contain = [frag contain:chess];
            if(contain){
                break;
            }
        }
        if(contain)continue;//如果已经计算过该子，则不在计算
        
        YFChessFragment *frag = [[YFChessFragment alloc]init];
        [frag calLibertyAt:chess board:self.board];
        [mary addObject:frag];
    }
    return mary;
}
            

#pragma mark - move
-(BOOL)canPlayAt:(int)x y:(int)y{
    x = MIN(MAX(0, x),self.board.numOfLines-1);
    y = MIN(MAX(0, y),self.board.numOfLines-1);
    return [self.board canPlayAtX:x y:y];
}
-(void)move:(YFChess *)chess toX:(int)x y:(int)y{
    [self.board rmChess:chess];
    chess.x = x;chess.y = y;
    [self.board addChess:chess];
}


@end
