//
//  YFPlayersView.h
//  BetaGo
//
//  Created by yf on 2019/4/9.
//  Copyright © 2019 yf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFMatch.h"
NS_ASSUME_NONNULL_BEGIN

@interface YFPlayersView : UIView
-(instancetype)initWithMatch:(YFMatch *)match;
-(void)updateUI;
-(UIView *)playerViewBy:(BOOL)black;
@end

NS_ASSUME_NONNULL_END
