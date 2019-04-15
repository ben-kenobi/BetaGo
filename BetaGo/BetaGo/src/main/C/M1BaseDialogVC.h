//
//  M1BaseDialogVC.h
//  M1Remoter
//
//  Created by yf on 2018/3/17.
//  Copyright © 2018年 oceanwing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M1BaseDialogVC : UIViewController
@property (nonatomic,assign)CGFloat radius;
@property (nonatomic,assign)BOOL dissmissWhenTouchOutside;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIView *shadowBg;
@property (nonatomic,assign)BOOL showDissmissBtn;
-(void)dismiss;
@end
