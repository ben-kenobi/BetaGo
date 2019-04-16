//
//  BCCommonTvModel.m
//  BatteryCam
//
//  Created by yf on 2017/9/15.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import "BCCommonTvModel.h"
#import "BCCommonSettingCell.h"
#import "BCCommonSettingMod.h"
@implementation BCCommonTvModel

+(instancetype)setDict:(NSDictionary *)dict{
    BCCommonTvModel *m = [IUtil setValues:dict forClz:self];
    if(!emptyStr(m.title))
        m.title = NSLocalizedStringFromTable(m.title, @"BCCommonSettingPlist", nil);
    if(!emptyStr(m.footerTitle))
        m.footerTitle = NSLocalizedStringFromTable(m.footerTitle, @"BCCommonSettingPlist", nil);
    return m;
}

-(void)setDatas:(NSArray *)datas{
     _datas = [NSMutableArray arrayWithCapacity:datas.count];
    for(NSDictionary *dict in datas){
        [_datas addObject:[BCCommonSettingMod setDict:dict]];
    }
}

-(NSInteger)count{
    return self.datas.count;
}
-(BCCommonSettingMod *)objectAtIndex:(NSInteger)idx{
    if(idx<0||idx>self.count-1) return nil;
    return self.datas[idx];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _datas = [NSMutableArray array];
    }
    return self;
}

@end
