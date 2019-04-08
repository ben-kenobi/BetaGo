//
//  YFChess.h
//  BetaGo
//
//  Created by yf on 2019/3/7.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFCodecObj.h"
@class YFChessBoard;
NS_ASSUME_NONNULL_BEGIN

@interface YFChess : YFCodecObj
@property (nonatomic,assign)BOOL black;//是否先手
@property (nonatomic,assign)int x;
@property (nonatomic,assign)int y;
@property (nonatomic,assign)int round;
@property (nonatomic,weak)YFChessBoard *board;
@property (nonatomic,assign)BOOL done;//是否下定


-(void)rmFromBoard;


#pragma mark - UI Property
@property (nonatomic,readonly)UIImage *bgimg;
@property (nonatomic,readonly)UIImage *pinedImg;
@property (nonatomic,readonly)UIColor *titleColor;
@property (nonatomic,readonly)NSString *title;
+(instancetype)chessWith:(BOOL)black;
@end

NS_ASSUME_NONNULL_END
