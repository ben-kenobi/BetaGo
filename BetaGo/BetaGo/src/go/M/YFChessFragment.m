//
//  YFChessFragment.m
//  BetaGo
//
//  Created by yf on 2019/4/8.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFChessFragment.h"
#import "YFChess.h"
#import "YFChessBoard.h"
#import "YFChessBtn.h"

@implementation YFChessFragment

-(void)updateChessList:(NSMutableDictionary<YFChess *,YFChessBtn *> *)dict{
    for(YFChess *chess in self.list){
        YFChessBtn *btn = dict[chess];
        if(self.free)
            btn.pined = YES;
        else{
            [btn removeFromSuperview];
            [dict removeObjectForKey:chess];
        }
    }
}


-(BOOL)contain:(YFChess *)chess{
    return [self.list containsObject:chess];
}


/**
 @param chess 被计算的子
 */
-(void)calLibertyAt:(YFChess *)chess board:(YFChessBoard *)board{
    NSMutableArray *mary = self.list;
    [mary addObject:chess];//计算过该子的气
    NSArray *ary = [board findSiblingsBy:chess];//获取该子周围子
    for(id obj in ary){
        if([obj isKindOfClass:YFChess.class]){
            YFChess *objch=obj;
            if(![mary containsObject:objch]&&objch.black == chess.black){//如果该子这次未被计算过且同色，则计算该子的气
                [self calLibertyAt:obj board:board];
            }
        }else{
            self.free = YES;
        }
    }
}


iLazy4Ary(list, _list)
@end
