//
//  BCCommonTvModel.h
//  BatteryCam
//
//  Created by yf on 2017/9/15.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCCommonSettingMod.h"

@interface BCCommonTvModel : NSObject
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *footerTitle;


-(NSInteger)count;
-(BCCommonSettingMod *)objectAtIndex:(NSInteger)idx;
@end
