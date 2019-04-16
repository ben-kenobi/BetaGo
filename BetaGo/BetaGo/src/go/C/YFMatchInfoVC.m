
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
#import "YFMatchList.h"

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
    self.match.remark = self.countTv.textView.text;
    self.match.title = self.nametf.text;
    [YFMatchList.shared save];
    [UIViewController popVC];
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
        [self.tv scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
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
        return dp2po(110);
    }
    return 0;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - UI
-(void)initUI{
    [self.tv registerClass:YFMatchInfoCell.class forCellReuseIdentifier:celliden2];
    self.tv.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, iScreenW, CGFLOAT_MIN)];
    self.tv.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, iScreenW, CGFLOAT_MIN)];
    self.tv.bounces=YES;
    self.title = @"备注";
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem.tintColor = iGlobalFocusColor;
    self.navigationItem.rightBarButtonItem.enabled=NO;
}


-(BCCustTf *)nametf{
    if(_nametf)return _nametf;
    BCCustTf * (^createTf)(void)= ^BCCustTf * {
        BCCustTf *tf = [[BCCustTf alloc]init];
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
    _countTv.maxCharacters = 600;
    _countTv.textView.placeholder = @"";
    return _countTv;
}
@end
