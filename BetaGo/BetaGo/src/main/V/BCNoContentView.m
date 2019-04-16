//
//  BCNoContentView.m
//  BatteryCam
//
//  Created by yf on 2017/11/14.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import "BCNoContentView.h"

@interface BCNoContentView()

@end
@implementation BCNoContentView



+(instancetype)viewBy:(BCNoContentType)type{
    BCNoContentView *view = [[BCNoContentView alloc]init];
    view.type=type;
    switch (type) {
        case BCNoContentNormal:
            [view initNormalNoContent];
            break;
        case BCNoContentnNoMatch:
            [view initNoMatchView];
            break;
        case BCNetworkUnReachable:
            [view initNetworkUnReachableView];
            break;
        default:
            break;
    }
    return view;
}

-(void)initNormalNoContent{
    self.backgroundColor=[UIColor clearColor];
    self.userInteractionEnabled=YES;
    UILabel *tip1=[IProUtil commonLab:iBFont(20) color:iColor(0xbb, 0xbb, 0xbb, 1)];
    tip1.text=NSLocalizedString(@"bc.menu.no_content",0);
    //----layout-----
    [self addSubview:tip1];

    [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
}

-(void)initNoMatchView{
    self.backgroundColor=[UIColor clearColor];
    self.userInteractionEnabled=YES;
    UIImageView *iv = [[UIImageView alloc]initWithImage:nil];
    [self addSubview:iv];
    
    UILabel *tip1=[IProUtil commonLab:iBFont(dp2po(17)) color:iColor(0xAA, 0xAA, 0xAA, 1)];
    tip1.textAlignment=NSTextAlignmentCenter;
    tip1.numberOfLines=0;
    tip1.text=@"";
    [self addSubview:tip1];
    
//    UIImageView *indicateIV = [[UIImageView alloc]initWithImage:img(@"line_add_con")];
//    [self addSubview:indicateIV];

    UIButton *backBtn=[IProUtil commonTextBtn:iFont(dp2po(17)) color:iColor(0x33, 0x33, 0x33, 1) title:@"新建对局"];
    [UIUtil commonStrokeBtn:backBtn tar:self action:@selector(onClick)];
    backBtn.alpha = .7;
    [self addSubview:backBtn];
    //----layout----
//    [indicateIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(@(-20));
//        make.top.equalTo(@(dp2po(15)));
//    }];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@(dp2po(-110)));
    }];
    [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv.mas_bottom).offset(dp2po(20));
        make.width.equalTo(@(iScreenW-dp2po(20)));
        make.centerX.equalTo(@0);
    }];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip1.mas_bottom).offset(dp2po(40));
        make.centerX.equalTo(@0);
        make.width.equalTo(@(dp2po(200)));
        make.height.equalTo(@(dp2po(48)));
    }];
}

-(void)initNetworkUnReachableView{
    self.backgroundColor=[UIColor clearColor];
    self.userInteractionEnabled=YES;
    UILabel *tip1=[IProUtil commonLab:iFont(15) color:iColor(0x66, 0x66, 0x66, 1)];
    tip1.text=NSLocalizedString(@"bc.devices.not_to_internet",0);
    UIImageView *iv=[[UIImageView alloc]initWithImage:img(@"network_no_icon")];
    
    UIButton *btn = [IProUtil commonTextBtn:iFont(15) color:iColor(0x99, 0x99, 0x99, 1) title:NSLocalizedString(@"bc.other.tap_to_refresh.",0)];
    [UIUtil commonUnderlineBtnSetup:btn];
    [btn addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    
    //----layout-----
    [self addSubview:tip1];
    [self addSubview:iv];
    [self addSubview:btn];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@(dp2po(-58)));
    }];
    [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv.mas_bottom).offset(dp2po(35));
        make.centerX.equalTo(@0);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip1.mas_bottom).offset(dp2po(8));
        make.centerX.equalTo(@0);
    }];
}

-(void)onClick{
    if(self.btnCb)
        self.btnCb();
}





-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    __block BOOL b=NO;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:UIButton.class] && CGRectContainsPoint(obj.frame, point)){
            b = YES;
            *stop=YES;
        }
    }];
    
    return b;
}
//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    __block UIView * tar;
//    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if([obj isKindOfClass:UIButton.class] && CGRectContainsPoint(obj.frame, point)){
//            tar = obj;
//            *stop=YES;
//        }
//    }];
//
//    return tar;
//}
@end

