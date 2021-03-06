//
//  YFChessBoradView.m
//  BetaGo
//
//  Created by yf on 2019/3/7.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFChessBoradView.h"
#import "YFChessFragment.h"
#import "YFPlayersView.h"

@interface YFChessBoradView()<YFChessLPActionDele>
{
    BOOL layoutComplete;
    CGFloat gap;
}
@property (nonatomic,strong)YFMatch *match;
@property (nonatomic,weak)YFChessBoard *mod;
@property (nonatomic,copy)NSArray<UIView *> *yLines;
@property (nonatomic,copy)NSArray<UIView *> *xLines;

@property (nonatomic,strong)NSArray<UIView *> *hightLightedLines;

@property (nonatomic,strong)NSMutableDictionary<YFChess *,YFChessBtn *> *chessBtns;

@end

@implementation YFChessBoradView

#pragma mark - actions



#pragma mark - datas
-(void)setMod:(YFMatch *)match{
    _match = match;
    _mod = match.board;
    [self reloadData];
}
-(void)reloadData{
    [[self subviews]enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    layoutComplete = NO;
    self.layer.contents = (__bridge id)(self.mod.bgImg.CGImage);
    self.layer.borderColor = self.mod.borderColor.CGColor;
    self.layer.borderWidth = 4;
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds=YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(!layoutComplete){
        layoutComplete = YES;
        [self initLines];
        [self initChesses];
    }
    
}

#pragma mark - YFChessLPActionDele
-(void)onLpAction:(UILongPressGestureRecognizer *)gest{
    CGPoint p = [gest locationInView:self];
    YFChessBtn *btn = (YFChessBtn *)gest.view;
    [self moveChess:btn to:p];

    if(gest.state==UIGestureRecognizerStateBegan){
        [UIUtil commonAnimation:^{
            [self beginAddChess:btn at:p];
        }];
    }else if(gest.state == UIGestureRecognizerStateChanged){
    }else if(gest.state == UIGestureRecognizerStateEnded){
        if([self needReponseTo:p]){
            int x,y;
            [self convertP:p toX:&x y:&y];
            BOOL b = [self.match canPlayChess:btn.mod at:x y:y];
            if(b){
                [self finalMoveChess:btn toX:x y:y];
                return ;
            }
        }
        [self abortMoveChess:btn];
    }else if(gest.state == UIGestureRecognizerStateCancelled || gest.state == UIGestureRecognizerStateFailed){
        [self abortMoveChess:btn];
    }
}

-(void)onDoubleTap:(UITapGestureRecognizer *)gest{
    if(!self.match.canDelete) return;
    YFChessBtn *btn = (YFChessBtn *)gest.view;
    [self deleteChess:btn];
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer isKindOfClass:UITapGestureRecognizer.class]){
        return self.match.canDelete;
    }
    if([gestureRecognizer isKindOfClass:UILongPressGestureRecognizer.class]){
        return self.match.canMove;
    }
    return YES;
}

#pragma mark - interaction
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //如果上一轮已经结束或者还没有上一轮，则新创建棋子
    if(!self.curChess || self.curChess.mod.done) {
        [self.match beginNextRound];
        self.curChess = [YFChessBtn btnWith:self.match.curChess w:gap dele:self];
    }
    BOOL animate = NO;
    if(self.curChess && self.curChess.superview && !self.curChess.mod.done){
        animate = YES;
    }
    CGPoint p = [touches.anyObject locationInView:self];
    if(animate){
        YFChessBtn *btn = self.curChess;
        [UIUtil commonAnimationWithDuration:.15 cb:^{
            [self beginAddChess:btn at:p];
        }];
    }else{
        [self beginAddChess:self.curChess at:p];
    }
    [self moveCurChess:p];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint p = [touches.anyObject locationInView:self];
    [self moveCurChess:p];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint p = [touches.anyObject locationInView:self];
    //如果移动失败，则不做处理
    if(![self moveCurChess:p]) return;
    if([self needReponseTo:p]){
        int x,y;
        [self convertP:p toX:&x y:&y];
        BOOL b = [self.match canPlayThisRoundAt:x y:y];
        if(b){
            if(!self.match.needConfirm)
                [self readyNEndAddChess:self.curChess cal:YES];
            else
                [self readyAddChess:self.curChess];
            return ;
        }
    }
    [self cancelCurChess];
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelCurChess];
}
-(void)confirmAddChess{
    [self endAddChess:self.curChess cal:YES];
}


-(BOOL)needReponseTo:(CGPoint)p{
    return !CGPointEqualToPoint(p, CGPointZero) && CGRectContainsPoint(self.bounds,p);
}
-(void)convertP:(CGPoint)p toX:(int *)x y:(int *)y{
    *x = (p.x-gap) / gap + .5;
    *y = (p.y-gap) / gap + .5;
    *x = MIN(MAX(0, *x),self.mod.numOfLines-1);
    *y = MIN(MAX(0, *y),self.mod.numOfLines-1);
}



/**
 @return YES 移动成功，否则失败
 */
-(BOOL)moveCurChess:(CGPoint)p{
    //已经下定的当前子，无法移动
    if(self.curChess.mod.done)return NO;
    [self moveChess:self.curChess to:p];
    [self highlightLineAt:p];
    return YES;
}
-(void)moveChess:(YFChessBtn *)chess to:(CGPoint)p{
    if([self needReponseTo:p]){
        chess.center = p;
    }
}
-(void)cancelCurChess{
    [self.curChess removeFromSuperview];
    [self errorLine];
}

-(void)highlightLineAt:(CGPoint)p{
    int x,y;
    [self convertP:p toX:&x y:&y];
    [self setHightLightedLines:@[self.xLines[x],self.yLines[y]] color:self.mod.hlLineColor];
}
-(void)errorLine{
    [self setHightLightedLines:self.hightLightedLines color:self.mod.errLineColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setHightLightedLines:nil color:0];
    });
}
-(void)setHightLightedLines:(NSArray<UIView *> *)hightLightedLines color:(UIColor *)color{
    [_hightLightedLines enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.shadowOpacity=0;
        obj.backgroundColor = self.mod.lineColor;
    }];
    _hightLightedLines = hightLightedLines;
    [_hightLightedLines enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = color;
        obj.layer.shadowColor = color.CGColor;
        obj.layer.shadowRadius = 1.5;
        obj.layer.shadowOffset=CGSizeZero;
        obj.layer.shadowOpacity=1;
    }];
}

#pragma mark - add chess
-(void)beginAddChess:(YFChessBtn *)btn at:(CGPoint)p{
    btn.center = p;
    [self addSubview:btn];
    btn.alpha = .9;
    btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
}

-(void)readyNEndAddChess:(YFChessBtn *)btn cal:(BOOL)cal{
    [self readyAddChess:btn];
    [self endAddChess:btn cal:cal];
}

-(void)readyAddChess:(YFChessBtn *)btn{
    [UIUtil commonAnimationWithDuration:.15 cb:^{
        btn.cx = self.xLines[btn.mod.x].cx;
        btn.cy = self.yLines[btn.mod.y].cy;
        btn.alpha = 1;
        btn.transform = CGAffineTransformIdentity;
    }];
    [self setHightLightedLines:@[self.xLines[btn.mod.x],self.yLines[btn.mod.y]] color:self.mod.hlLineColor];
}

-(void)endAddChess:(YFChessBtn *)btn cal:(BOOL)cal{
    if(!btn) return;
    [self.chessBtns setObject:btn forKey:btn.mod];
    NSArray<YFChessFragment *> *rmChessList = [self.match doneWith:btn.mod cal:cal];
    [self updateUIWithChessFragments:rmChessList];
    
    
    btn.showTitle=self.match.showRound;
    btn.userInteractionEnabled = YES;
    [self setHightLightedLines:nil color:0];
}

-(void)updateUIWithChessFragments:(NSArray<YFChessFragment *> *)fragments{
    [self.chessBtns enumerateKeysAndObjectsUsingBlock:^(YFChess * _Nonnull key, YFChessBtn * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.pined = NO;
    }];
    for(YFChessFragment *frag in fragments){
        [frag updateChessList:self.chessBtns playerView:self.playerView];
    }
}

-(void)addView:(UIView *)view atX:(int)x y:(int)y{
    view.cx = self.xLines[x].cx;
    view.cy = self.yLines[y].cy;
    [self addSubview:view];
}


-(void)finalMoveChess:(YFChessBtn *)btn toX:(int)x y:(int)y{
    [self.chessBtns removeObjectForKey:btn.mod];//key的mod已经改变，需要先删除再添加
    NSArray<YFChessFragment *> *rmChessList = [self.match confirmMove:btn.mod toX:x y:y];
    [self.chessBtns setObject:btn forKey:btn.mod];
    [self updateUIWithChessFragments:rmChessList];
    
    [UIUtil commonAnimationWithDuration:.15 cb:^{
        btn.cx = self.xLines[btn.mod.x].cx;
        btn.cy = self.yLines[btn.mod.y].cy;
        btn.alpha = 1;
        btn.transform = CGAffineTransformIdentity;
    }];
    
}
-(void)abortMoveChess:(YFChessBtn *)btn{
    [UIUtil commonAnimationWithDuration:.15 cb:^{
        btn.cx = self.xLines[btn.mod.x].cx;
        btn.cy = self.yLines[btn.mod.y].cy;
        btn.alpha = 1;
        btn.transform = CGAffineTransformIdentity;
    }];
}

-(void)deleteChess:(YFChessBtn *)btn{
    YFChess *chess = btn.mod;
    [btn removeFromSuperview];
    [self.chessBtns removeObjectForKey:chess];
    [chess rmFromBoard];
}




#pragma mark - UI
-(void)updateUI{
    [self.chessBtns.allValues enumerateObjectsUsingBlock:^(YFChessBtn * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.showTitle = self.match.showRound;
    }];
}

-(void)initChesses{
  
    
    int count = 0;
    //最后一个落子
    YFChessBtn *lastBtn = nil;
    for(int y=0;y<self.mod.numOfLines;y++){
        for(int x=0;x<self.mod.numOfLines;x++){
            YFChess *chess = [self.mod findChessAt:x y:y];
            if(chess){
                count+=1;
                YFChessBtn *btn = [YFChessBtn btnWith:chess w:gap dele:self];
                if(lastBtn.mod.round < btn.mod.round)
                    lastBtn = btn;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(count*.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self beginAddChess:btn at:CGPointZero];
                    [self readyNEndAddChess:btn cal:NO];
                });
            }
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(count*.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(self.match.curChess && !self.match.curChess.done){
            self.curChess = [YFChessBtn btnWith:self.match.curChess w:self->gap dele:self];
            [self beginAddChess:self.curChess at:CGPointZero];
            [self readyAddChess:self.curChess];
        }else{
            self.curChess = lastBtn;
        }
    });
   
    
}

-(void)initLines{
    CGFloat lineW = 1;
    CGFloat lineW_2 = lineW*.5;
    
    NSMutableArray *xlines = [NSMutableArray array];
    NSMutableArray *ylines = [NSMutableArray array];
    
    gap = self.w/(self.mod.numOfLines+1);
    CGFloat innerW = self.w - gap * 2 + lineW;
    
    for(int i=1;i<=self.mod.numOfLines;i++){
        UIView *xline = [UIView viewWithColor:self.mod.lineColor];
        UIView *yline = [UIView viewWithColor:self.mod.lineColor];
        [xlines addObject:xline];
        [ylines addObject:yline];
        
        xline.frame = CGRectMake(i*gap-lineW_2, gap-lineW_2, lineW,innerW);
        yline.frame = CGRectMake(gap-lineW_2, i*gap-lineW_2, innerW, lineW);
        [self addSubview:xline];
        [self addSubview:yline];
    }
    self.xLines = xlines;
    self.yLines = ylines;
    
    int midLoc = self.mod.numOfLines * .5;
    int submidLoc = midLoc * .5;
    if(midLoc > 0){
        [self addView:self.dotView atX:midLoc y:midLoc];
        [self addView:self.dotView atX:submidLoc y:submidLoc];
        [self addView:self.dotView atX:self.mod.numOfLines - submidLoc-1 y:submidLoc];
        [self addView:self.dotView atX:submidLoc y:self.mod.numOfLines - submidLoc-1];
        [self addView:self.dotView atX:self.mod.numOfLines - submidLoc-1 y:self.mod.numOfLines - submidLoc-1];
    }
}


-(UIView *)dotView{
    UIView *dot=[UIView viewWithColor:self.mod.lineColor];
    dot.size = CGSizeMake(8, 8);
    dot.layer.cornerRadius = dot.w*.5;
    return dot;
}

-(instancetype)initWith:(YFChessBoard *)mod{
    if(self = [super init]){
        self.mod = mod;
    }return self;
}


#pragma mark - getter & setter
-(void)setCurChess:(YFChessBtn *)curChess{
    _curChess.selected = NO;
    _curChess = curChess;
    _curChess.selected = YES;
}


iLazy4Dict(chessBtns, _chessBtns)
@end
