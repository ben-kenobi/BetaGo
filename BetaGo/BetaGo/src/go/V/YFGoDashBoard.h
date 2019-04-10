//
//  YFGoDashBoard.h
//  BetaGo
//
//  Created by yf on 2019/4/10.
//  Copyright © 2019 yf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFGoDashBoard,YFMatch;
@protocol YFGoDashBoardDele<NSObject>
-(void)dashboard:(YFGoDashBoard *)dashboard startPuaseClick:(UIButton *)btn;
-(void)dashboard:(YFGoDashBoard *)dashboard doneClick:(UIButton *)btn;
-(void)dashboard:(YFGoDashBoard *)dashboard settingClick:(UIButton *)btn;
-(void)dashboard:(YFGoDashBoard *)dashboard saveClick:(UIButton *)btn;
@end


NS_ASSUME_NONNULL_BEGIN

@interface YFGoDashBoard : UIView
-(instancetype)initWith:(YFMatch *)match;
@property (nonatomic,weak)id<YFGoDashBoardDele> dele;
-(void)updateUI;
@end

NS_ASSUME_NONNULL_END
