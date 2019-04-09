//
//  YFChessBtn.h
//  BetaGo
//
//  Created by yf on 2019/3/7.
//  Copyright © 2019 yf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFChess.h"
NS_ASSUME_NONNULL_BEGIN

@protocol YFChessLPActionDele <UIGestureRecognizerDelegate>

-(void)onLpAction:(UILongPressGestureRecognizer *)gest;

-(void)onDoubleTap:(UITapGestureRecognizer *)gest;


@end

@interface YFChessBtn : UIButton
@property (nonatomic,assign)BOOL pined;
@property (nonatomic,strong)YFChess *mod;
@property (nonatomic,assign)BOOL showTitle;

+(instancetype)btnWith:(YFChess *)mod w:(CGFloat)wid dele:(id<YFChessLPActionDele>)dele ;
@end

NS_ASSUME_NONNULL_END
