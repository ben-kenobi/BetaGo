//
//  YFMatchSettingVM.h
//  BetaGo
//
//  Created by yf on 2019/4/15.
//  Copyright © 2019 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YFMatch;
NS_ASSUME_NONNULL_BEGIN

@interface YFMatchSwitchSettingMod : NSObject
@property (nonatomic,strong)NSString *title;
@property (nonatomic,assign)BOOL on;
+(instancetype)modWith:(NSString *)title on:(BOOL)on;
@end


@interface YFMatchSettingVM : NSObject

-(instancetype)initWith:(YFMatch *)match;
@property (nonatomic,strong)YFMatch *match;
@property (nonatomic,strong)NSArray<YFMatchSwitchSettingMod *> *datas;

-(NSInteger)count;
-(YFMatchSwitchSettingMod *)getBy:(NSIndexPath *)idxpath;
-(void)selAt:(NSIndexPath *)idxpath;
-(void)confirmChange;

@end

NS_ASSUME_NONNULL_END
