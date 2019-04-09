//
//  YFGoUtil.h
//  BetaGo
//
//  Created by yf on 2019/4/9.
//  Copyright © 2019 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFGoUtil : NSObject
+(NSString *)durationDesc:(NSInteger)millis;
+(void)feedbackWhenChessDone;
+(CAAnimation *)playerPlayingAnimation;
@end

NS_ASSUME_NONNULL_END
