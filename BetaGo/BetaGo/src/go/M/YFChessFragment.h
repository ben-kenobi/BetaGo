//
//  YFChessFragment.h
//  BetaGo
//
//  Created by yf on 2019/4/8.
//  Copyright © 2019 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YFChess,YFChessBoard,YFChessBtn,YFPlayersView;
NS_ASSUME_NONNULL_BEGIN

/**
 连城一片的子的集合
 */
@interface YFChessFragment : NSObject
@property (nonatomic,strong)NSMutableArray<YFChess *> *list;

@property (nonatomic,assign)NSInteger liberty;//有多少气
@property (nonatomic,readonly)BOOL free;//是否有气
@property (nonatomic,assign)BOOL needWarning;

-(BOOL)contain:(YFChess *)chess;

-(void)calLibertyAt:(YFChess *)chess board:(YFChessBoard *)board;


// 根据自身状态更新棋子
-(void)updateChessList:(NSDictionary<YFChess *,YFChessBtn *> *)dict playerView:(YFPlayersView *)playerView;
@end

NS_ASSUME_NONNULL_END
