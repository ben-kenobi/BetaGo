//
//  YFChessFragment.h
//  BetaGo
//
//  Created by yf on 2019/4/8.
//  Copyright © 2019 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YFChess,YFChessBoard,YFChessBtn;
NS_ASSUME_NONNULL_BEGIN

/**
 连城一片的子的集合
 */
@interface YFChessFragment : NSObject
@property (nonatomic,strong)NSMutableArray<YFChess *> *list;

@property (nonatomic,assign)BOOL free;//是否该集有气

-(BOOL)contain:(YFChess *)chess;

-(void)calLibertyAt:(YFChess *)chess board:(YFChessBoard *)board;


// 根据自身状态更新棋子
-(void)updateChessList:(NSDictionary<YFChess *,YFChessBtn *> *)dict;
@end

NS_ASSUME_NONNULL_END
