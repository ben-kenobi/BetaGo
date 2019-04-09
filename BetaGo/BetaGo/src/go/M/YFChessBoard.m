

//
//  YFChessBoard.m
//  BetaGo
//
//  Created by yf on 2019/3/7.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFChessBoard.h"

@interface YFChessBoard ()
@property (nonatomic,strong)NSMutableArray *chessList;

@end
@implementation YFChessBoard

-(instancetype)initWithLines:(int)lines{
    if(self = [super init]){
        NSAssert(lines>=5 && lines<=19 && lines%2!=0, @"invalid lines");
        self.numOfLines = lines;
        NSMutableArray *mary = [NSMutableArray array];
        for(int i=0;i<lines * lines;i++){
            [mary addObject: @0];
        }
        self.chessList = mary;
        
    }return self;
}

-(UIImage *)bgImg{
    return img(@"board_bg").resizableStretchImg;
}
-(UIColor *)lineColor{
    return [iColor(0x33, 0x33, 0x33, .9) colorWithAlphaComponent:.8];
}
-(UIColor *)hlLineColor{
    return iColor(36, 165, 58, 1);
}
-(UIColor *)errLineColor{
    return iGlobalErrorColor;
}
-(UIColor *)borderColor{
    return [[UIColor whiteColor] colorWithAlphaComponent:.2];
}





#pragma mark - 增删改查
-(YFChess *)findChessAt:(int)x y:(int)y{
    if(x<0 || x > self.numOfLines-1  || y < 0 || y > self.numOfLines-1)
        return nil;
    id obj = self.chessList[[self idxByx:x y:y]];
    if([obj isKindOfClass:YFChess.class]){
        return obj;
    }
    return nil;
}
-(NSArray<YFChess *>*)findChessByRound:(int)round{
    NSMutableArray *ary = [NSMutableArray array];
    [self.chessList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:YFChess.class]){
            YFChess * chess = obj;
            if(chess.round == round){
                [ary addObject:chess];
            }
        }
    }];
    return ary;
}
-(NSArray<YFChess *> *)findSiblingChessBy:(YFChess *)chess{
    NSMutableArray *mary = [NSMutableArray array];
    YFChess *left = [self findChessAt:chess.x-1 y:chess.y];
    YFChess *right = [self findChessAt:chess.x+1 y:chess.y];
    YFChess *up = [self findChessAt:chess.x y:chess.y-1];
    YFChess *down = [self findChessAt:chess.x y:chess.y+1];
    if(left) [mary addObject:left];
    if(right) [mary addObject:right];
    if(up) [mary addObject:up];
    if(down) [mary addObject:down];
    return [NSArray arrayWithArray:mary];
}

-(NSArray *)findSiblingsBy:(YFChess *)chess{
    NSMutableArray *mary = [NSMutableArray array];
    YFChess *left = [self findItemAt:chess.x-1 y:chess.y];
    YFChess *right = [self findItemAt:chess.x+1 y:chess.y];
    YFChess *up = [self findItemAt:chess.x y:chess.y-1];
    YFChess *down = [self findItemAt:chess.x y:chess.y+1];
    if(left) [mary addObject:left];
    if(right) [mary addObject:right];
    if(up) [mary addObject:up];
    if(down) [mary addObject:down];
    return [NSArray arrayWithArray:mary];
}

-(id)findItemAt:(int)x y:(int)y{
    if(x<0 || x > self.numOfLines-1  || y < 0 || y > self.numOfLines-1)
        return nil;
    id obj = self.chessList[[self idxByx:x y:y]];
    return obj;
}

-(BOOL)canAdd:(YFChess *)chess{
    return [self canPlayAtX:chess.x y:chess.y];
}
-(BOOL)canPlayAtX:(int)x y:(int)y{
    return ![self findChessAt:x y:y];
}
-(BOOL)addChess:(YFChess *)chess{
    if(![self canAdd:chess]) return NO;
    return [self replaceChess:chess];
}
-(BOOL)rmChess:(YFChess *)chess{
    if(![self.chessList containsObject:chess]) return YES;
    self.chessList[[self idxByx:chess.x y:chess.y]] = @0;
    return YES;
}

-(BOOL)replaceChess:(YFChess *)chess{
    self.chessList[[self idxByx:chess.x y:chess.y]] = chess;
    chess.board = self;
    return YES;
}

-(int)idxByx:(int)x y:(int)y{
    return y*self.numOfLines + x;
}


#pragma mark - getter & setter
-(void)setChessList:(NSMutableArray *)chessList{
    _chessList = chessList;
    [_chessList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:YFChess.class]){
            YFChess *chess = (YFChess *)obj;
            chess.board = self;
        }
    }];
}

@end
