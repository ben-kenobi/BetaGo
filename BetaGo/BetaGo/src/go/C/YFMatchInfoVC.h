//
//  YFMatchInfoVC.h
//  BetaGo
//
//  Created by yf on 2019/4/16.
//  Copyright © 2019 yf. All rights reserved.
//

#import "BCSettingBaseVC.h"
@class YFMatch,YFMatchList;
NS_ASSUME_NONNULL_BEGIN

@interface YFMatchInfoVC : BCSettingBaseVC
@property (nonatomic,strong)YFMatch *match;
@property (nonatomic,strong)YFMatchList *vm;
@end

NS_ASSUME_NONNULL_END
