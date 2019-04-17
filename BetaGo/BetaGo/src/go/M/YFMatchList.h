//
//  YFMatchList.h
//  BetaGo
//
//  Created by yf on 2019/4/16.
//  Copyright © 2019 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YFMatch;
NS_ASSUME_NONNULL_BEGIN

@interface YFMatchList : NSObject
+(instancetype)newInstance;

#pragma mark - exported
-(NSInteger)count;
-(YFMatch *)getBy:(NSIndexPath *)idxpath;
-(YFMatch *)selectedMatch;

-(void)rmMatch:(YFMatch *)match;
-(void)rmAt:(NSIndexPath *)indexpath;
-(void)saveMatch:(YFMatch *)match;
-(void)save;
-(void)selectMatchAt:(NSIndexPath *)idxpath;

@end

NS_ASSUME_NONNULL_END
