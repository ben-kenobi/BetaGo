//
//  BCSettingBaseVC.h
//  BatteryCam
//
//  Created by yf on 2017/9/15.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import "YFBasicVC.h"
#import "BCCommonSettingCell.h"
@class BCCommonTvModel;
@interface BCSettingBaseVC : YFBasicVC<UITableViewDelegate,UITableViewDataSource,BCCommonSettingCellDelegate>
@property (nonatomic,strong)UITableView *tv;
@property (nonatomic,copy)NSString *pname;
@property (nonatomic,strong)Class cellClz;
@property (nonatomic,strong)NSMutableArray *datas;

-(void)loadBaseData;

-(void)clickAtIdxPath:(NSIndexPath *)idxpath;
-(void)setupCell:(BCCommonSettingCell *)cell idxpath:(NSIndexPath *)idxpath;
-(UITableViewCell *)dequeueCellFrom:(UITableView *)tv iden:(NSString *)iden idxpath:(NSIndexPath *)idxpath;

//export
-(id<BCCommonSettingMod>)modByIdxpath:(NSIndexPath *)idxpath;
-(BCCommonTvModel *)tvModBySection:(NSInteger)section;
-(NSString *)titleBy:(NSInteger)section;
-(NSString *)footerTitleBy:(NSInteger)section;
-(void)setLoading:(BOOL)loading at:(NSIndexPath *)idxpath;
-(void)commonLoadingSequenceAt:(NSIndexPath *)idxpath action:(void(^)(BOOL (^cb)(void)))action ;

-(void)loadBaseData;
-(void)addDatas:(NSArray *)datas at:(NSInteger)section;
-(void)addDatasFromPlist:(NSString *)plist at:(NSInteger)section;
-(void)appendDatasFromPlist:(NSString *)plist;
@end
