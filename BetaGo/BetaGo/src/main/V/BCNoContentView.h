//
//  BCNoContentView.h
//  BatteryCam
//
//  Created by yf on 2017/11/14.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum :NSInteger {
    BCNoContentNormal,
    BCNoContentnNoMatch,
    BCNetworkUnReachable
}BCNoContentType;
@interface BCNoContentView : UIView
@property (nonatomic,copy)void(^btnCb)(void);
+(instancetype)viewBy:(BCNoContentType)type;
@property (nonatomic,assign)BCNoContentType type;


@property (nonatomic,strong)UIImageView *iv;
@property (nonatomic,strong)UILabel *msgLab;
@end
