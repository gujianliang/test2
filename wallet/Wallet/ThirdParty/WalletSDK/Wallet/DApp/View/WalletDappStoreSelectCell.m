//
//  WalletDappStoreSelectCell.m
//  VeWallet
//
//  Created by Tom on 2018/10/8.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletDappStoreSelectCell.h"
#import "Payment.h"

#define MediumFont(__font__) [UIFont systemFontOfSize:__font__ weight:UIFontWeightMedium]


@interface WalletDappStoreSelectCell ()
{
    UILabel *_addressLabel;           // 钱包地址
    UILabel *_reasonLabel;            // 描述语
    UIImageView *_imageV;             // 勾选标记
    NSString *_cellIndef;
}
@end

@implementation WalletDappStoreSelectCell

- (instancetype)initWithTable:(UITableView *)table
{
    _cellIndef = @"WalletDappStoreSelectCell";
    WalletDappStoreSelectCell *cell = [table dequeueReusableCellWithIdentifier:_cellIndef];
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


- (void)setModel:(WalletManageModel *)model amount:(NSString *)amount toAddress:(NSString *)toAddress
{
    _model = model;

    _addressLabel.text = _model.address;
    
    BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:model.VETCount];
    NSString *coinAmount = @"0.00";
    if (!bigNumberCount.isZero) {
        coinAmount = [Payment formatToken:bigNumberCount
                                 decimals:18
                                  options:2];
    }
    
    
    NSString *walletAmount = [coinAmount stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSDecimalNumber *vetBalanceNum = [NSDecimalNumber decimalNumberWithString:walletAmount];
    NSDecimalNumber *amountNum = [NSDecimalNumber decimalNumberWithString:amount];
    

    if ([model.address.lowercaseString isEqualToString:toAddress.lowercaseString]){
        
        _reasonLabel.text = VCNSLocalizedBundleString(@"h5_select_wallet_error", nil);
        _imageV.hidden = YES;
        
        [model.address.lowercaseString isEqualToString:toAddress.lowercaseString];
        _addressLabel.textColor = HEX_RGB(0xBDBDBD);

        [_addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(15);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(20);
        }];
        
    }else if([vetBalanceNum compare:amountNum] != NSOrderedAscending){ // 可选中的钱包样式 ,降级或者相同
        _reasonLabel.text = @"";
        
    }else { // 不可选中的钱包样式
        _reasonLabel.text = [@"VET " stringByAppendingString: VCNSLocalizedBundleString(@"contact_change_wallet_not_enough", nil)];
        _imageV.hidden = YES;
        _addressLabel.textColor = HEX_RGB(0xBDBDBD);
        
        [_addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(15);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(20);
        }];

    }
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
    
    // 地址
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.text = @"";
    _addressLabel.numberOfLines = 2;
    _addressLabel.font = MediumFont(14);
    _addressLabel.textColor = HEX_RGB(0x333333);
    _addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [contentView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    
    // 描述语
    _reasonLabel = [[UILabel alloc]init];
    [contentView addSubview:_reasonLabel];
    _reasonLabel.textAlignment = NSTextAlignmentRight;
    _reasonLabel.text = @"";
    _reasonLabel.font = MediumFont(14);
    _reasonLabel.textColor = HEX_RGB(0xBDBDBD);
    _reasonLabel.textAlignment = NSTextAlignmentLeft;
    [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-Scale(20.0));
        make.top.mas_equalTo(_addressLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(Scale(20.0));
        make.height.mas_equalTo(Scale(17));
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
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-Scale(20.0));
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
}

@end
