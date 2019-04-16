

//
//  YFMatchListCell.m
//  BetaGo
//
//  Created by yf on 2019/4/16.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFMatchListCell.h"
#import "YFMatch.h"
@implementation YFMatchListCell

-(void)setMatch:(YFMatch *)match{
    _match = match;
    [self updateUI];
}
-(void)updateUI{
    self.textLabel.attributedText = self.match.titleAttrDesc;
    self.detailTextLabel.attributedText = self.match.detailAttrDesc;
}

#pragma mark - UI
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:UITableViewCellStyleSubtitle
                   reuseIdentifier:reuseIdentifier]){
        [self initUI];
    }return self;
}
-(void)initUI{
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = iFont(16);
    self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.detailTextLabel.font = iFont(13);
    self.detailTextLabel.textColor = iColor(0x55, 0x55, 0x55, 1);
    self.detailTextLabel.numberOfLines = 0;
    self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}
@end
