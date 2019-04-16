//
//  BCSceneSettingCell.m
//  BatteryCam
//
//  Created by yf on 2018/4/16.
//  Copyright © 2018年 oceanwing. All rights reserved.
//

#import "YFMatchInfoCell.h"
@interface YFMatchInfoCell()
@property (nonatomic,strong)UIView *lineView;
@end
@implementation YFMatchInfoCell

-(void)setMod:(id<BCCommonSettingMod>)mod{
    [super setMod:mod];
    self.textLabel.textColor=iColor(0x66, 0x66, 0x66, 1);
    if(self.mod.textColor){
        if([self.mod.textColor isKindOfClass:NSString.class]){
        self.textLabel.textColor=[UIColor colorWithHex:self.mod.textColor];
        }else if([self.mod.textColor isKindOfClass:UIColor.class]){
            self.textLabel.textColor=self.mod.textColor;
        }
    }
    self.detailTextLabel.font=iFont(16);
    self.textLabel.font=iFont(16);
    if(self.mod.bold){
        self.textLabel.font=iBFont(17);
    }
    
    [self.lineView removeFromSuperview];
    [self.editBtn removeFromSuperview];
    if(mod.hasEdit){
        self.selectionStyle=0;
        self.accessoryView=nil;
        self.lineView=[UIView viewWithColor:iCommonSeparatorColor];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@0);
            make.height.equalTo(self.contentView);
            make.width.equalTo(@80);
            make.top.equalTo(@0);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.editBtn.mas_leading).offset(12);
            make.height.equalTo(self.contentView).multipliedBy(.4);
            make.width.equalTo(@1);
            make.centerY.equalTo(@0);
        }];
    }
    
}



@end
