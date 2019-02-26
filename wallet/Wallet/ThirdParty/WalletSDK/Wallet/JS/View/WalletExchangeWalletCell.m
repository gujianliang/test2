//
//  WalletExchangeWalletCell.m
//  VeWallet
//
//  Created by 曾新 on 2018/10/8.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletExchangeWalletCell.h"

@interface WalletExchangeWalletCell ()
{
    UILabel *_walletNameLabel;        // 钱包名称
    UILabel *_addressLabel;           // 钱包地址
    UILabel *_reasonLabel;            // 描述语
    UIImageView *_imageV;             // 勾选标记
    NSString *_cellIndef;
    UIImageView *_observeImageV; //观察钱包icon
}
@end

@implementation WalletExchangeWalletCell

- (instancetype)initWithTable:(UITableView *)table
{
    _cellIndef = @"WalletExchangeWalletCell";
    WalletExchangeWalletCell *cell = [table dequeueReusableCellWithIdentifier:_cellIndef];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIndef];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        self.backgroundColor = HEX_RGB(0xF9FAFC);
    }
    return self;
}

- (void)setModel:(WalletManageModel *)model
{
    _model = model;
    
    _walletNameLabel.text = _model.name;
    
    _addressLabel.text = _model.address;
    
    if(_model.enable){ // 可选中的钱包样式
        _walletNameLabel.textColor = HEX_RGB(0x202C56); // 黑色
        
        _reasonLabel.text = @"";
        _imageV.hidden = !_model.isSelect;
        
    }else { // 不可选中的钱包样式
        _walletNameLabel.textColor = HEX_RGB(0xBDBDBD); // 置灰
        
        _reasonLabel.text = _model.reason;
        _imageV.hidden = YES;
    }
}

- (void)setModel:(WalletManageModel *)model amount:(NSString *)amount toAddress:(NSString *)toAddress
{
    _model = model;
    
    _walletNameLabel.text = _model.name;
    
    _addressLabel.text = _model.address;
    
    if ([model.address.lowercaseString isEqualToString:toAddress.lowercaseString]){
        
        _walletNameLabel.textColor = HEX_RGB(0xBDBDBD); // 置灰
        _reasonLabel.text = @"不能与目标地址相同";
        _imageV.hidden = YES;
        
        
        [model.address.lowercaseString isEqualToString:toAddress.lowercaseString];
        
    }else if(model.VETCount.doubleValue > amount.doubleValue){ // 可选中的钱包样式
        _walletNameLabel.textColor = HEX_RGB(0x202C56); // 黑色
        _reasonLabel.text = @"";
        _imageV.hidden = !_model.isSelect;
        
    }else { // 不可选中的钱包样式
        _walletNameLabel.textColor = HEX_RGB(0xBDBDBD); // 置灰
        _reasonLabel.text = @"余额不足";
        _imageV.hidden = YES;
    }
    
    _observeImageV.hidden = !model.observer.boolValue;
}


- (void)initView
{
    //中间内容
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = UIColor.whiteColor;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    // 钱包名称
    _walletNameLabel = [[UILabel alloc]init];
    _walletNameLabel.text = @"";
    _walletNameLabel.font = MediumFont(15);
    _walletNameLabel.textColor = HEX_RGB(0x202C56);
    [contentView addSubview:_walletNameLabel];
    [_walletNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Scale(20.0));
        make.top.mas_equalTo(Scale(15.0));
        make.height.mas_equalTo(Scale(22.0));
    }];
    
    // 观察钱包
    _observeImageV = [[UIImageView alloc]init];
    _observeImageV.image = [UIImage imageNamed:@"guancha"];
    [contentView addSubview:_observeImageV];
    [_observeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_walletNameLabel.mas_right).offset(10);
        make.centerY.equalTo(_walletNameLabel.mas_centerY);
    }];
    _observeImageV.hidden = YES;
    
    // 地址
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.text = @"";
    _addressLabel.font = MediumFont(12);
    _addressLabel.textColor = HEX_RGB(0xBDBDBD);
    _addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [contentView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_walletNameLabel.mas_bottom).offset(3);
        make.left.mas_equalTo(_walletNameLabel.mas_left);
        make.width.mas_equalTo(Scale(115));
        make.height.mas_equalTo(17);
    }];
    
    
    // 描述语
    _reasonLabel = [[UILabel alloc]init];
    [contentView addSubview:_reasonLabel];
    _reasonLabel.textAlignment = NSTextAlignmentRight;
    _reasonLabel.text = @"";
    _reasonLabel.font = MediumFont(12);
    _reasonLabel.textColor = HEX_RGB(0xBDBDBD);
    [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-Scale(20.0));
        make.left.mas_equalTo(_addressLabel.mas_right).offset(3.0);
        make.centerY.equalTo(_addressLabel.mas_centerY);
    }];
    
    
    // 勾选标记图标
    _imageV = [[UIImageView alloc] init];
    _imageV.image = [UIImage imageNamed:@"icon_yes_copy"];
    [contentView addSubview:_imageV];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_reasonLabel.mas_right);
        make.width.mas_equalTo(Scale(16.0));
        make.height.mas_equalTo(Scale(12.0));
        make.centerY.equalTo(_addressLabel.mas_centerY);
    }];
    
    // 分割线
    UIView *middleViewLine = [[UIView alloc]init];
    middleViewLine.backgroundColor = HEX_RGB(0xF6F6F6);
    [contentView addSubview:middleViewLine];
    [middleViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_walletNameLabel.mas_left);
        make.right.mas_equalTo(-Scale(20.0));
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
}

@end
