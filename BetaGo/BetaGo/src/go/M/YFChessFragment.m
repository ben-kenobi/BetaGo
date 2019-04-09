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
#import "YFPlayersView.h"

@implementation YFChessFragment




-(void)updateChessList:(NSMutableDictionary<YFChess *,YFChessBtn *> *)dict playerView:(YFPlayersView *)playerView{
    NSMutableArray *rmedBtns = [NSMutableArray array];
    for(YFChess *chess in self.list){
        YFChessBtn *btn = dict[chess];
        if(!self.free){
            // 将view从原控件移除后加入新父View做动画效果
            UIView *view = [playerView playerViewBy:!chess.black];
            
            CGRect frame = [btn convertRect:btn.bounds toView:view];
            
            [btn removeFromSuperview];
            btn.frame = frame;
            [view addSubview:btn];
            [rmedBtns addObject:btn];
            
            [dict removeObjectForKey:chess];
            [chess rmFromBoard];
        }else if([self needPin]){
            btn.pined = YES;
        }
    }
    [UIUtil commonAnimationWithDuration:.25 cb:^{
        for(UIView *view in rmedBtns){
            view.center=view.superview.innerCenter;
            view.alpha=.2;
        }
    } comp:^(BOOL finish) {
        for(UIView *view in rmedBtns){
            [view removeFromSuperview];
        }
    }];
   
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
            self.liberty += 1;
        }
    }
}


#pragma mark - getter & setter
-(BOOL)free{
    return self.liberty > 0;
}
-(BOOL)needPin{
    if(!self.needWarning) return NO;
    NSInteger threshholder = (NSInteger)ceil(self.list.count * .2);
    threshholder = MIN(3, threshholder);
    return self.liberty <= threshholder;
}


iLazy4Ary(list, _list)
@end
