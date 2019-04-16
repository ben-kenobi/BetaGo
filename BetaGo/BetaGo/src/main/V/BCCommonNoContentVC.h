//
//  BCCommonNoContentVC.h
//  BatteryCam
//
//  Created by yf on 2018/3/5.
//  Copyright © 2018年 oceanwing. All rights reserved.
//

#import "YFBasicVC.h"
#import "BCNoContentView.h"
@interface BCCommonNoContentVC : YFBasicVC
@property (nonatomic,assign)BCNoContentType noContentType;
@property (nonatomic,assign)BOOL loading;
@property (nonatomic,assign)NSInteger loadResultCode;
@property (nonatomic,strong)BCNoContentView *noContent;


-(BOOL)hasData;//subVC should override this method to return corresponde value
-(void)noContentNormalCB;
-(void)noContentNetworkErrCB;
-(void)onNoContent:(BOOL)show;
@end
