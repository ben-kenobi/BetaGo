
//
//  BCPirTriggerExcVC.m
//  BatteryCam
//
//  Created by yf on 2019/1/21.
//  Copyright © 2019 oceanwing. All rights reserved.
//

#import "YFGoSettingVC.h"
#import "YFMatch.h"
#import "YFMatchSettingVM.h"

static NSString * celliden = @"celliden";

@interface YFGoSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tv;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)YFMatchSettingVM *vm;
@end

@implementation YFGoSettingVC

- (void)viewDidLoad {
    self.radius=0;
    self.dissmissWhenTouchOutside=YES;
    [super viewDidLoad];
    [self initUI];
    UIBlurEffect *blurEff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEff];
    [self.view insertSubview:visualView atIndex:0];
    [visualView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    self.shadowBg.transform = CGAffineTransformMakeTranslation(0, iScreenH);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIUtil commonAnimation:^{
            self.shadowBg.transform=CGAffineTransformIdentity;
        }];
    });
    self.vm = [[YFMatchSettingVM alloc]initWith:self.match];
}

-(void)dealloc{
    [self.tv removeObserver:self forKeyPath:@"contentSize"];
}


-(void)dismiss{
    [UIUtil commonAnimation:^{
        self.shadowBg.transform=CGAffineTransformMakeTranslation(0, self.shadowBg.h);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super dismiss];
    });
}


#pragma mark - observe

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if(object ==  self.tv && [@"contentSize" isEqualToString:keyPath]){
        [self updateTvH];
    }
}

-(void)updateTvH{
    [self.tv mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.tv.contentSize.height+20+self.tv.contentInset.bottom));
    }];
}


#pragma mark - actions
-(void)onOK{
    [self dismiss];
    [self.vm confirmChange];
}
-(void)onCancel{
    [self dismiss];
}

#pragma mark - UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.vm.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celliden forIndexPath:indexPath];
    YFMatchSwitchSettingMod *mod = [self.vm getBy:indexPath];
    cell.textLabel.text = mod.title;
    cell.accessoryType = mod.on ? UITableViewCellAccessoryCheckmark : 0;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.vm selAt:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}


#pragma - mark UI
-(void)initUI{
    [self.shadowBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(@0);
        make.top.greaterThanOrEqualTo(@(dp2po(60)));
    }];
    
    
    self.tv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tv.bounces=NO;
    self.tv.backgroundColor=[UIColor whiteColor];
    self.tv.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tv.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, dp2po(0))];
    self.tv.delegate=self;
    self.tv.dataSource=self;
    self.tv.rowHeight=UITableViewAutomaticDimension;
    self.tv.estimatedRowHeight=dp2po(80);
    [self.tv registerClass:UITableViewCell.class forCellReuseIdentifier:celliden];
    self.tv.sectionHeaderHeight=UITableViewAutomaticDimension;
    self.tv.sectionFooterHeight=dp2po(10);
    self.tv.tableHeaderView=self.tvHeadrView;
    
    [self.tv addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionOld) context:0];
    
    UIButton *okbtn = [IProUtil commonNoShadowTextBtn:iFont(dp2po(16)) color:iColor(0xff, 0xff, 0xff, 1) title:NSLocalizedString(@"确认", 0)];
    [UIUtil commonTexBtn:okbtn tar:self action:@selector(onOK)];
    
    UIButton *noShowBtn = [IProUtil commonNoShadowTextBtn:iFont(dp2po(16)) color:iColor(0x66, 0x66, 0x66, 1) title:NSLocalizedString(@"取消",0)];
    [UIUtil commonStrokeBtn:noShowBtn tar:self action:@selector(onCancel) shadowOpacity:0 strokeColor:iColor(0xbb, 0xbb, 0xbb, 1) strokeHLColor:iGlobalFocusColor strokeDisColor:0 bgcolor:iColor(0xff, 0xff, 0xff, 1) corRad:6];
    
    //layout ---
    [self.contentView addSubview:self.tv];
    [self.contentView addSubview:okbtn];
    [self.contentView addSubview:noShowBtn];
    
    [self.tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        make.height.equalTo(@0);
    }];
    self.tv.contentInset = UIEdgeInsetsMake(0, 0, dp2po(60), 0);
    
    [okbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView).multipliedBy(.4);
        make.leading.equalTo(@(dp2po(18)));
        make.height.equalTo(@(dp2po(46)));
        make.bottom.equalTo(self.contentView.mas_bottomMargin).offset(-dp2po(15));
    }];
    [noShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.bottom.equalTo(okbtn);
        make.trailing.equalTo(@(dp2po(-18)));
    }];
}

-(UIView *)tvHeadrView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iScreenW, dp2po(50)+self.titleLab.h)];
    self.titleLab.text = @"设置";
    [view addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(dp2po(25)));
        make.centerX.equalTo(@0);
        make.width.equalTo(view.mas_width).multipliedBy(.85);
    }];
    return view;
}
-(UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [IProUtil commonLab:iBFont(dp2po(18)) color:iColor(0x33, 0x33, 0x33, 1)];
        _titleLab.numberOfLines=0;
        _titleLab.textAlignment=NSTextAlignmentCenter;
    }return _titleLab;
}

@end
