//
//  YFPlayer.h
//  BetaGo
//
//  Created by yf on 2019/4/9.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFCodecObj.h"
@class YFChess,YFChessFragment,YFMatch;
NS_ASSUME_NONNULL_BEGIN

@interface YFPlayer : YFCodecObj
@property (nonatomic,assign)BOOL black;
@property (nonatomic,assign)NSInteger playCount;//落子数
@property (nonatomic,assign)NSInteger getCount;//提子数
@property (nonatomic,assign)NSTimeInterval playDuration;//使用时间

@property (nonatomic,assign)NSTimeInterval beginTime;

@property (nonatomic,weak)YFMatch *match;




#pragma mark - UI properties
@property (nonatomic,readonly)UIImage *iconImg;
@property (nonatomic,readonly)NSString *title;
@property (nonatomic,readonly)UIColor *titleColor;
@property (nonatomic,readonly)NSAttributedString *attrDetail;
@property (nonatomic,readonly)UIImage *bgImg;



#pragma mark - datas
-(void)beginRound;
-(void)endRoundWith:(NSArray<YFChessFragment *> *)list;
-(void)getChess:(NSArray<YFChessFragment *> *)list;
-(void)setPause:(BOOL)pause;
+(instancetype)playerWith:(BOOL)black;

@end

NS_ASSUME_NONNULL_END
