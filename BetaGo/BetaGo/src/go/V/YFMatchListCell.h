//
//  YFMatchListCell.h
//  BetaGo
//
//  Created by yf on 2019/4/16.
//  Copyright © 2019 yf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFMatch;
NS_ASSUME_NONNULL_BEGIN

@interface YFMatchListCell : UITableViewCell
@property (nonatomic,strong)YFMatch *match;
@end

NS_ASSUME_NONNULL_END
