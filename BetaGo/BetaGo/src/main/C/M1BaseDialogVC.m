
//
//  M1BaseDialogVC.m
//  M1Remoter
//
//  Created by yf on 2018/3/17.
//  Copyright © 2018年 oceanwing. All rights reserved.
//

#import "M1BaseDialogVC.h"

@interface M1BaseDialogVC ()
@property (nonatomic,strong)UIButton *dismissBtn;
@end

@implementation M1BaseDialogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseUI];
}
-(void)setShowDissmissBtn:(BOOL)showDissmissBtn{
    _showDissmissBtn = showDissmissBtn;
    self.dismissBtn.hidden = !showDissmissBtn;
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:0];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(!self.dissmissWhenTouchOutside) return;
    UITouch *touch = touches.anyObject;
    CGPoint p=[touch locationInView:self.contentView];
    if(!CGRectContainsPoint(self.contentView.frame, p)){
        [self dismiss];
    }
}
-(void)initBaseUI{
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.55];
    UIView *shadowBg = [[UIView alloc]init];
    shadowBg.backgroundColor=[UIColor whiteColor];
    CGFloat radius = self.radius >=0?self.radius : dp2po(6);
    shadowBg.layer.cornerRadius=radius;
    [UIUtil commonShadowWithRadius:12 size:CGSizeMake(0, 4) view:shadowBg opacity:.37];
    
   
    
    
    
    self.contentView=[[UIView alloc]init];
    self.contentView.layer.cornerRadius=radius;
    self.contentView.layer.masksToBounds=YES;
    
    //layout
    [self.view addSubview:shadowBg];
    [shadowBg addSubview:self.contentView];

    self.shadowBg=shadowBg;
    [shadowBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(.8);
        make.center.equalTo(@0);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.bottom.equalTo(self.shadowBg.mas_bottomMargin);
    }];
    
    
    
}

-(instancetype)init{
    if(self=[super init]){
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
        self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        self.radius=-1;
    }
    return self;
}

#pragma mark - ratation
-(BOOL)shouldAutorotate {
    return self.presentingViewController.shouldAutorotate;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.presentingViewController.supportedInterfaceOrientations;
    
}


-(UIButton *)dismissBtn{
    if(_dismissBtn) return _dismissBtn;
    //添加close按钮
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:img(@"box_closed_circle_icon") forState:UIControlStateNormal];
    closeBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _dismissBtn=closeBtn;
    [self.view addSubview:closeBtn];

    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).offset(dp2po(15));
        make.centerX.equalTo(@0);
    }];
    return _dismissBtn;
}
@end
