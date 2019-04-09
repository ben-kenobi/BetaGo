//
//  YFGoUtil.m
//  BetaGo
//
//  Created by yf on 2019/4/9.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFGoUtil.h"

@implementation YFGoUtil
+(NSString *)durationDesc:(NSInteger)millis{
    NSString *units[]={@"s",@"m",@"h",@"d"};
    NSInteger factors[]={60,60,24};
    NSMutableString *mstr = [NSMutableString string];
    NSInteger left=millis*.001;
    NSInteger idx = 0;
    do {
        NSInteger mod=left%factors[idx];
        [mstr insertString:iFormatStr(@" %ld %@",mod,units[idx]) atIndex:0];
        left/=factors[idx];
        idx+=1;
    }while(left>0&&idx<3);
    if(left>0&&idx==3){
        [mstr insertString:iFormatStr(@" %ld %@",left,units[idx]) atIndex:0];
    }
    return mstr;
}
+(void)feedbackWhenChessDone{
        static UIImpactFeedbackGenerator *gen;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            gen = [[UIImpactFeedbackGenerator alloc]initWithStyle:(UIImpactFeedbackStyleMedium)];
        });
        [gen impactOccurred];
}

+(CAAnimation *)playerPlayingAnimation{
    CAAnimationGroup *grou = [[CAAnimationGroup alloc]init];
    
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    ani.toValue =(__bridge id) [iGlobalFocusColor colorWithAlphaComponent:.8].CGColor;
    ani.fromValue = (__bridge id)[iGlobalFocusColor colorWithAlphaComponent:.2].CGColor;
    
    CABasicAnimation *ani2 = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    ani2.fromValue = @(.1);
    ani2.toValue = @(1);
    
    grou.animations = @[ani,ani2];
    grou.repeatCount = CGFLOAT_MAX;
    grou.autoreverses = YES;
    grou.duration=.6;
    return grou;

}
@end
