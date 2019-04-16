
//
//  YFMatchInfoVC.m
//  BetaGo
//
//  Created by yf on 2019/4/16.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFMatchInfoVC.h"
#import "YFMatch.h"
#import "BCCountTextView.h"
#import "BCCustTextView.h"
#import "BCCustTf.h"
#import "YFMatchInfoCell.h"


static NSString *celliden2=@"celliden2";
@interface YFMatchInfoVC ()
@property (nonatomic,strong)BCCustTf *nametf;
@property (nonatomic,strong)BCCountTextView *countTv;
@end

@implementation YFMatchInfoVC

- (void)viewDidLoad {
    self.pname=@"YFMatchInfoVC.plist";
    self.cellClz=YFMatchInfoCell.class;
    [super viewDidLoad];
    [self initUI];
    [self loadDatas];
    [iNotiCenter addObserver:self selector:@selector(onKeyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.nametf becomeFirstResponder];
}

#pragma mark - datas
-(void)loadDatas{
    [self updateData];
}
-(void)updateData{
    self.nametf.text = self.match.title;
    self.countTv.textView.text=self.match.remark;
}


-(void)updateUI{
    self.navigationItem.rightBarButtonItem.enabled = !emptyStr([self.nametf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
}


#pragma mark - actions
-(void)save:(id)sender{
    [self.view endEditing:YES];
    if([self isNameExists]){
        [iPop toastWarn:NSLocalizedString(@"bc.mode.mode_name_exists", 0)];
        return ;
    }
    if(self.mode){
        self.tmpMode = self.mode;
        self.tmpMode.iconType = self.modeListV.selMode.iconType;
        self.tmpMode.title = self.nametf.text;
        self.tmpMode.detail = self.countTv.textView.text;
        [self.mod.modeVM updateMode:self.tmpMode];
        
        
        [iPop showProg];
        
        [BCComCtrlManager.shared setCustMode:[self.mod.modeVM uploadParam:self.mode.mode operType:SceneOperationTypeUpdate] task:[BCComCtrlTask taskWith:self.mod.connectDID sn:self.mod.station_sn chl:0 cb:^(TASK_RESULT_CODE code, NSString *msg, id datas) {
            [iPop dismProg];
            if(code == TASK_SUCESS){
                [UIViewController popVC];
                [self.mod.modeVM commitChange];
            }else{
                [iPop toastWarn:msg];
            }
        }]];
        return;
    }
    BCModeMod *mode = [[BCModeMod alloc]init];
    mode.iconType = self.modeListV.selMode.iconType;
    mode.title = self.nametf.text;
    mode.detail = self.countTv.textView.text;
    
    [self.mod.modeVM addMode:mode];
    
    [self.mod resetDevicesActionsOnMode:mode.mode];
    
    [iPop showProg];
    [BCComCtrlManager.shared setCustMode:[self.mod.modeVM uploadParam:mode.mode operType:SceneOperationTypeAdd] task:[BCComCtrlTask taskWith:self.mod.connectDID sn:self.mod.station_sn chl:0 cb:^(TASK_RESULT_CODE code, NSString *msg, id datas) {
        [iPop dismProg];
        if(code == TASK_SUCESS){
            BCSecuritySettingsVC2 *vc = [[BCSecuritySettingsVC2 alloc]init];
            vc.mod=self.mod;
            vc.mode=mode;
            vc.fromAdd = YES;
            UINavigationController *nav = self.navigationController;
            [self.navigationController popViewControllerAnimated:NO];
            runOnMain(^{
                [nav pushViewController:vc animated:YES];
            });
            [self.mod.modeVM commitChange];
        }else{
            [iPop toastWarn:msg];
        }
    }]];
}
-(BOOL)isNameExists{
    NSString *title = self.nametf.text;
    for(NSInteger i = 0; i<self.mod.modeVM.count; i++){
        BCModeMod *m = [self.mod.modeVM get:i];
        if(m != self.mode && [m.title isEqualToString:title]){
            return YES;
        }
    }
    return NO;
}

-(void)onKeyboardChange:(NSNotification *)noti{
    CGFloat dura=[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endframe=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat h = endframe.size.height;
    CGFloat y = endframe.origin.y;
    BOOL hide = y>=iScreenH;
    [self.tv mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(hide?0:-h));
    }];
    
    [UIView animateWithDuration:dura animations:^{
        [self.view layoutIfNeeded];
    }];
    if(self.countTv.textView.isFirstResponder){
        [self.tv scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    }
}
#pragma mark - UITableviewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:0];
    cell.selectionStyle=0;
    NSInteger sec = indexPath.section;
    if(sec == 0){
        [self.nametf removeFromSuperview];
        [cell.contentView addSubview:self.nametf];
        [self.nametf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.equalTo(@0);
            make.width.equalTo(cell);
        }];
    }else if(sec == 1){
        [self.modeListV removeFromSuperview];
        [cell.contentView addSubview:self.modeListV];
        [self.modeListV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.equalTo(@0);
            make.width.equalTo(cell);
        }];
    }else if(sec == 2){
        [self.countTv removeFromSuperview];
        [cell.contentView addSubview:self.countTv];
        [self.countTv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.equalTo(@0);
            make.width.equalTo(cell);
        }];
    }
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger sec = indexPath.section;
    if(sec == 0){
        return dp2po(52);
    }else if(sec == 1){
        return 200;
    }else if(sec == 2){
        return dp2po(110);
    }
    return 0;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - UI
-(void)initUI{
    [self.tv registerClass:BCSecuritySettingDeviceCell.class forCellReuseIdentifier:celliden2];
    self.tv.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, iScreenW, CGFLOAT_MIN)];
    self.tv.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, iScreenW, CGFLOAT_MIN)];
    self.tv.bounces=YES;
    if(self.mode)
        self.title = NSLocalizedString(@"bc.mode.edit_security",0);
    else
        self.title = NSLocalizedString(@"bc.mode.create_security",0);
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:self.mode ? NSLocalizedString(@"bc.common.save",0) : NSLocalizedString(@"bc.common.next",0) style:(UIBarButtonItemStylePlain) target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem.tintColor = iGlobalFocusColor;
    self.navigationItem.rightBarButtonItem.enabled=NO;
}


-(BCCustTf *)nametf{
    if(_nametf)return _nametf;
    BCCustTf * (^createTf)(void)= ^BCCustTf * {
        BCCustTf *tf = [[BCNamingTF alloc]init];
        tf.leftPad=dp2po(15);
        tf.rightPad=tf.leftPad;
        tf.bottomLine.hidden=YES;
        tf.adjustFocusColor=NO;
        tf.tintColor=iColor(0x20, 0x6b, 0xff, 1);
        tf.backgroundColor=[UIColor whiteColor];
        tf.font=iFont(17);
        tf.textColor=iColor(0x33, 0x33, 0x33, 1);
        //        [UIUtil commonShadowWithRadius:12 size:CGSizeMake(0, 4) view:tf opacity:.06];
        tf.layer.borderColor=iCommonSeparatorColor.CGColor;
        tf.layer.borderWidth=1;
        return tf;
    };
    __weak typeof (self)se=self;
    _nametf=createTf();
    _nametf.placeholder=@"";
    [_nametf setOnTextChange:^(BCCustTf *tf) {
        [se updateUI];
    }];
    [_nametf setOnReturn:^(BCCustTf *tf) {
    }];
    return _nametf;
}
-(BCCountTextView *)countTv{
    if(_countTv)return _countTv;
    // content Sv ---begin
    
    _countTv=[[BCCountTextView alloc]init];
    _countTv.maxCharacters = 60;
    _countTv.textView.placeholder = NSLocalizedString(@"bc.mode.custom_security", 0);
    return _countTv;
}
-(BCModeListView *)modeListV{
    if(_modeListV)return _modeListV;
    _modeListV = [[BCModeListView alloc]init];
    @weakRef(self)
    [_modeListV setOnSelChange:^{
        [weak_self updateUI];
    }];
    return _modeListV;
}

-(BCGatewaryMod *)mod{
    BCGatewaryMod *mod =  [BCDevicesInstance.shared.bases getBySN:_mod.station_sn];
    if(mod){
        _mod=mod;
        if(_mode)
            _mode = [_mod.modeVM getBy:_mode.mode];
    }
    return _mod;
}
@end
