//
//  BCCameraSettingMod.h
//  BatteryCam
//
//  Created by yf on 2017/8/20.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCCommonSettingCell.h"
@interface BCCommonSettingMod : NSObject<BCCommonSettingMod>
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *detail;
@property (nonatomic,copy)NSString *detail2;
@property (nonatomic,assign)BOOL hideDetail;
@property (nonatomic,strong)id icon;
@property (nonatomic,strong)id img;
@property (nonatomic,copy)id textColor;
@property (nonatomic,assign)BOOL switchView;
@property (nonatomic,assign)BOOL hasDetail;
@property (nonatomic,assign)BOOL on;
@property (nonatomic,copy)NSString *vc;
@property (nonatomic,copy)NSString *method;
@property (nonatomic,assign)BOOL selectMod;
@property (nonatomic,assign)BOOL selected;
@property (nonatomic,assign)BOOL hasEdit;
@property (nonatomic,assign)BOOL loading;
@property (nonatomic,assign)BOOL editable;
@property (nonatomic,copy)NSString *editMethod;
@property (nonatomic,assign)BOOL bold;
@property (nonatomic,assign)BOOL disabled;
@property (nonatomic,assign)BOOL isSlider;
@end
