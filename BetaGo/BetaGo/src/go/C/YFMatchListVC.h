//
//  YFMatchListVC.h
//  BetaGo
//
//  Created by yf on 2019/4/16.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFBasicVC.h"
@class YFMatch;
NS_ASSUME_NONNULL_BEGIN

@interface YFMatchListVC : YFBasicVC
@property (nonatomic,copy)void (^selectedCB)(YFMatch *match);
@end

NS_ASSUME_NONNULL_END
