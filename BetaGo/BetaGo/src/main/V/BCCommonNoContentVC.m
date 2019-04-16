
//
//  BCCommonNoContentVC.m
//  BatteryCam
//
//  Created by yf on 2018/3/5.
//  Copyright © 2018年 oceanwing. All rights reserved.
//

#import "BCCommonNoContentVC.h"
#import "BCBaseHttpClient.h"
@interface BCCommonNoContentVC ()

@end

@implementation BCCommonNoContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _loading=YES;
    _loadResultCode=NO;
}

-(void)setLoading:(BOOL)loading{
    _loading=loading;
    [self showNoContent];
}
-(void)noContentNormalCB{}
-(void)noContentNetworkErrCB{}

-(void)onNoContent:(BOOL)show{}


-(void)showNoContent{
    BOOL show = !self.hasData&&!self.loading;
    if(show){
        BCNoContentType type = _loadResultCode!=BC_NETWORKERR?_noContentType:BCNetworkUnReachable;
        //不判断是否类型不一致，每次都重新创建
//        if(!_noContent || _noContent.type!=type){
            [_noContent removeFromSuperview];
            _noContent=[BCNoContentView viewBy:type];
            @weakRef(self)
            [_noContent setBtnCb:^{
                if(type==BCNetworkUnReachable)
                    [weak_self noContentNetworkErrCB];
                else
                    [weak_self noContentNormalCB];
            }];
//        }
    }

    //动画会导致界面跳动，解决前先取消动画
//    [UIUtil commonTransiWith:self.view blo:^{
        [self onNoContent:show];
//    }];
}

-(BOOL)hasData{
    return NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showNoContent];
}



@end
