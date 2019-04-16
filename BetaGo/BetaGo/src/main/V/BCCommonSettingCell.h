//
//  BCCommonSettingCell.h
//  BatteryCam
//
//  Created by yf on 2017/8/22.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import <UIKit/UIKit.h>
extern CGFloat BC_SETTING_CELL_COMMON_HEIGHT;
@class BCCommonSettingCell;
@protocol BCCommonSettingMod <NSObject>
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


@protocol BCCommonSettingCellDelegate <NSObject>

-(void)onSwitchChange:(BCCommonSettingCell *)cell;
-(void)onEditClicked:(BCCommonSettingCell *)cell;

@end

@interface BCCommonSettingCell : UITableViewCell
@property (nonatomic,strong)id<BCCommonSettingMod> mod;
@property (nonatomic,strong)UISwitch *swi;
@property (nonatomic,strong)UIButton *editBtn;
@property (nonatomic,strong)UIButton *disabledCover;
@property (nonatomic,strong)UIImageView *iconIv;
@property (nonatomic,strong)UILabel *cancelLabel;
@property (nonatomic,strong)UIImageView *betaImageView;
@property (nonatomic,weak)id<BCCommonSettingCellDelegate> delegate;
-(void)initUI;
@end
