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
@end
