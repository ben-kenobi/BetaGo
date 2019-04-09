//
//  YFPlayerView.h
//  BetaGo
//
//  Created by yf on 2019/4/9.
//  Copyright © 2019 yf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFPlayer,YFPlayerView;

@protocol YFPlayerViewDelegate <NSObject>

-(void)playerView:(YFPlayerView *)view iconClicked:(UIButton *)icon;

@end
NS_ASSUME_NONNULL_BEGIN

@interface YFPlayerView : UIView
@property (nonatomic,strong)YFPlayer *player;
@property (nonatomic,strong)UIButton *icon;
@property (nonatomic,weak)id<YFPlayerViewDelegate> dele;
-(void)updateUI;
@end

NS_ASSUME_NONNULL_END
