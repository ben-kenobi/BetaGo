
//
//  YFMatchSettingVM.m
//  BetaGo
//
//  Created by yf on 2019/4/15.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFMatchSettingVM.h"
#import "YFMatch.h"
@implementation YFMatchSettingVM
-(instancetype)initWith:(YFMatch *)match{
    if(self = [super init]){
        self.match = match;
        self.datas = @[
            [YFMatchSwitchSettingMod modWith:@"落子确认" on:match.needConfirm],
            [YFMatchSwitchSettingMod modWith:@"显示回合" on:match.showRound],
            [YFMatchSwitchSettingMod modWith:@"长按移动" on:match.canMove],
            [YFMatchSwitchSettingMod modWith:@"双击删除" on:match.canDelete],
             [YFMatchSwitchSettingMod modWith:@"气紧预警" on:match.needWarning]
        ];
    }return self;
}

#pragma mark - actions
-(NSInteger)count{
    return self.datas.count;
}
-(YFMatchSwitchSettingMod *)getBy:(NSIndexPath *)idxpath{
    return self.datas[idxpath.row];
}
-(void)selAt:(NSIndexPath *)idxpath{
    [self getBy:idxpath].on = ![self getBy:idxpath].on;
}
-(void)confirmChange{
    self.match.needConfirm = self.datas[0].on;
    self.match.showRound = self.datas[1].on;
    self.match.canMove = self.datas[2].on;
    self.match.canDelete = self.datas[3].on;
    self.match.needWarning = self.datas[4].on;
    [self.match statusChange];
}
@end




@implementation YFMatchSwitchSettingMod
+(instancetype)modWith:(NSString *)title on:(BOOL)on{
    YFMatchSwitchSettingMod *mod = [[YFMatchSwitchSettingMod alloc]init];
    mod.title = title;
    mod.on = on;
    return mod;
}
@end
