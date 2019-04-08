


//
//  YFChess.m
//  BetaGo
//
//  Created by yf on 2019/3/7.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFChess.h"
#import "YFChessBoard.h"


@interface YFChess()
@end

@implementation YFChess
+(instancetype)chessWith:(BOOL)black{
    YFChess *chess = [[self alloc]init];
    chess.black = black;
    return chess;
}


-(UIImage *)bgimg{
    UIColor *color = self.black ? iColor(0x33, 0x33, 0x33, 1) : iColor(0xef, 0xef, 0xef, 1);
    return [UIImage dotImg4Color:color rad:dp2po(7) imgSize:CGSizeMake(dp2po(16), dp2po(16))];
}
-(UIImage *)pinedImg{
    UIColor *color = self.black ? iColor(0xee, 0x33, 0xee, .3) : iColor(0xde, 0x33, 0x33, .3);
    return [UIImage dotImg4Color:color rad:dp2po(7) imgSize:CGSizeMake(dp2po(16), dp2po(16))];
}
-(UIColor *)titleColor{
    return !self.black ? iColor(0x33, 0x33, 0x33, 1) : iColor(0xef, 0xef, 0xef, 1);
}
-(NSString *)title{
    return iFormatStr(@"%d",self.round);
}


-(void)rmFromBoard{
    [self.board rmChess:self];
}


#pragma mark - overrided
- (id)initWithCoder:(NSCoder *)coder
{
    if(self = [super init]){
        self.x = [coder decodeIntForKey:@"x"];
        self.y = [coder decodeIntForKey:@"y"];
        self.round = [coder decodeIntForKey:@"round"];
        self.black = [coder decodeBoolForKey:@"black"];
        self.done = [coder decodeBoolForKey:@"done"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:self.x forKey:@"x"];
    [coder encodeInt:self.y forKey:@"y"];
    [coder encodeInt:self.round forKey:@"round"];
    [coder encodeBool:self.black forKey:@"black"];
    [coder encodeBool:self.done forKey:@"done"];
}
-(BOOL)isEqual:(id)object{
    if(object == self) return YES;
    if(!object) return NO;
    if(![object isKindOfClass:self.class]) return NO;
    YFChess *other = (YFChess *)object;
    return other.black == self.black &&
            other.x == self.x &&
            other.y == self.y &&
            other.round == self.round;
}
-(NSUInteger)hash{
    NSUInteger prime = 31;
    NSUInteger result = 1;
    result = prime * result + self.x;
    result = prime * result + self.y;
    result = prime * result + self.round;
    result = prime * result + self.black;
    return result;
}
-(id)copyWithZone:(NSZone *)zone{
    YFChess *chess = [[YFChess alloc]init];
    chess.x = self.x;
    chess.y = self.y;
    chess.black = self.black;
    chess.round = self.round;
    return chess;
}

@end
