//
//  YFChessBtn.m
//  BetaGo
//
//  Created by yf on 2019/3/7.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFChessBtn.h"

@interface YFChessBtn ()
@property (nonatomic,weak)UILongPressGestureRecognizer *lpGest;
@end


@implementation YFChessBtn
- (void)setPined:(BOOL)pined{
    _pined = pined;
    if(_pined)
        [self setImage:self.mod.pinedImg forState:0];
    else
        [self setImage:nil forState:0];
}

-(void)setShowTitle:(BOOL)showTitle{
    _showTitle = showTitle;
    [self updateUI];
}

-(void)setMod:(YFChess *)mod{
    _mod = mod;
    [self updateUI];
}

-(void)updateUI{
    [self setBackgroundImage:self.mod.bgimg forState:0];
    [self setTitleColor:self.mod.titleColor forState:0];
    self.titleLabel.font = iFont(11);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.imageView.contentMode = UIViewContentModeCenter;
    [self setTitle:self.showTitle ? self.mod.title : @"" forState:0];
    [self setTitleColor:iGlobalFocusColor forState:(UIControlStateSelected)];
}
+(instancetype)btnWith:(YFChess *)mod w:(CGFloat)wid dele:(id<YFChessLPActionDele>)dele {
    YFChessBtn *btn = [[self alloc]init];
    btn.userInteractionEnabled = NO;
    btn.mod=mod;
    btn.size = CGSizeMake(wid, wid);
//    [UIUtil commonShadowWithRadius:2 size:CGSizeMake(1, 1) view:btn opacity:mod.black?.4:.2];
    
    UILongPressGestureRecognizer *lpgest = [[UILongPressGestureRecognizer alloc]initWithTarget:dele action:@selector(onLpAction:)];
    [btn addGestureRecognizer:lpgest];
    lpgest.minimumPressDuration=.3;
    lpgest.delegate = dele;
    btn.lpGest = lpgest;
    
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:dele action:@selector(onDoubleTap:)];
    tapgest.numberOfTapsRequired = 2;
    [btn addGestureRecognizer:tapgest];
    tapgest.delegate = dele;
    
    return btn;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return contentRect;
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return contentRect;
}

@end
