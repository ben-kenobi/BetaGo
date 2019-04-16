//
//  BCCameraSettingMod.m
//  BatteryCam
//
//  Created by yf on 2017/8/20.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import "BCCommonSettingMod.h"

@implementation BCCommonSettingMod

+(instancetype)setDict:(NSDictionary *)dict{
    BCCommonSettingMod *m = [IUtil setValues:dict forClz:self];
    if(!emptyStr(m.title))
        m.title = NSLocalizedStringFromTable(m.title, @"BCCommonSettingPlist", nil);
    if(!emptyStr(m.detail))
        m.detail = NSLocalizedStringFromTable(m.detail, @"BCCommonSettingPlist", nil);
    return m;
}

-(void)setOn:(BOOL)on{
    _on=on;
    if(self.switchView&&self.hasEdit){
        self.editable=_on;
    }
}
@end
