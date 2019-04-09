//
//  YFMatch.h
//  BetaGo
//
//  Created by yf on 2019/3/7.
//  Copyright © 2019 yf. All rights reserved.
//


#import "YFCodecObj.h"
#import "YFChessBoard.h"
#import "YFPlayer.h"

@class YFChessFragment;


typedef NS_ENUM(NSUInteger, RoundType) {
    RoundTypeNormal,//轮流循环
    RoundTypeBlack,//黑棋循环
    RoundTypeWhite//白棋循环
};

typedef NS_ENUM(NSUInteger, RoundStatus) {
    RoundDone,
    RoundBegin,
    RoundReady
};

NS_ASSUME_NONNULL_BEGIN

@interface YFMatch : YFCodecObj
@property (nonatomic,assign)RoundType roundType;
@property (nonatomic,strong)YFChessBoard *board;
@property (nonatomic,assign)int round;//当前多少回合
@property (nonatomic,strong)YFChess *curChess;

@property (nonatomic,strong)NSArray<YFPlayer *> *players;

@property (nonatomic,assign)BOOL needConfirm;//是否需要下子确认
@property (nonatomic,assign)BOOL showRound;//是否需要在棋子上显示回合数
@property (nonatomic,assign)BOOL canMove;//是否允许移动已经下好了的棋子
@property (nonatomic,assign)BOOL needWarning;//是否需要被提预警
@property (nonatomic,assign)BOOL canDelete;//是否可以双击移除棋子
@property (nonatomic,assign)BOOL pause;//暂停
@property (nonatomic,assign)BOOL needFeedback;// 落子是否需要反馈
-(instancetype)initMatchWith:(int)lines;



#pragma mark - round
-(void)beginNextRound;
-(BOOL)canPlayThisRoundAt:(int)x y:(int)y;

-(void)updateRoundType:(RoundType)type;

/**
结束本轮，并且判断是否需要计算提子，如果计算，则返回被提的子数组
 @param cal 是否计算提子
 @return 被提子的数组,相连的子为一个YFChessFragment
 */
-(NSArray<YFChessFragment *> *)doneThisRound:(BOOL)cal;

-(void)prevRound;
-(YFPlayer *)curPlayer;

#pragma mark - move
-(BOOL)canPlayChess:(YFChess *)chess at:(int)x y:(int)y;
-(NSArray<YFChessFragment *> *)confirmMove:(YFChess *)chess toX:(int)x y:(int)y;
@end

NS_ASSUME_NONNULL_END
