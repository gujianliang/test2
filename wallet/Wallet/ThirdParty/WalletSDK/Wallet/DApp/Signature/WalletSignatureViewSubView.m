//
//  WalletSignatureViewSubView.m
//  WalletSDK
//
//  Created by 曾新 on 2019/2/15.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletSignatureViewSubView.h"
#import "Payment.h"
#import "SecureData.h"

#define viewHeight Scale(411)

@implementation WalletSignatureViewSubView
{
    BOOL        _needAdjust;
    UILabel     *_minerLabel;
    UIView      *_leftView;
    UIView      *_rightView;
    UILabel     *_valueLabel;
    NSString    *_additionalMsg;
    UIButton    *_timeBtn;
    
    WalletGradientLayerButton *_middleBtn;
    WalletGradientLayerButton *_lastBtn;
    
    UIScrollView        *_scrollView;
    NSString            *_amount;
    WalletCoinModel     *_currentCoinModel;
    NSString            *_gasLimit;
    NSString            *_fromAddress;
    NSString            *_toAddress;
    UITextField         *_pwTextField;
    WalletTransferType      _transferType;
    NSNumber            *_gas;
    BigNumber           *_gasPriceCoef;
    NSData              *_clauseData;
    
    WalletSignatureViewHandle *_signatureHandle;
}


- (void)initSignature:(UIScrollView *)scrollView amount:(NSString *)amount currentCoinModel:(WalletCoinModel *)currentCoinModel gasLimit:(NSString *)gasLimit  fromAddress:(NSString *)fromAddress toAddress:(NSString *)toAddress pwTextField:(UITextField *)pwTextField transferType:(WalletTransferType)transferType
                  gas:(NSNumber *)gas gasPriceCoef:(BigNumber *)gasPriceCoef clauseData:(NSData *)clauseData signatureHandle:(WalletSignatureViewHandle *)signatureHandle additionalMsg:(NSString *)additionalMsg
{
    _scrollView = scrollView;
    _amount     = amount;
    _currentCoinModel   = currentCoinModel;
    _gasLimit           = gasLimit;
    _fromAddress        = fromAddress;
    _transferType       = transferType;
    _gas                = gas;
    _gasPriceCoef       = gasPriceCoef;
    _clauseData         = clauseData;
    _signatureHandle    = signatureHandle;
    _additionalMsg      = additionalMsg;
    _toAddress          = toAddress;
}

- (void)creatLeftView:(void(^)(void))enterSignViewBlock
{
    if (_leftView == nil) {
        _leftView = [[UIView alloc]init];
        [_scrollView addSubview:_leftView];
        [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(viewHeight - Scale(40));
        }];
    }
    // 售卖价格
    _valueLabel = [[UILabel alloc]init];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:Scale(36)];
    _valueLabel.textColor = CommonBlack;
    
    [self initMinerLabel];
    
    _valueLabel.adjustsFontSizeToFitWidth = YES;
    _valueLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [_leftView addSubview:_valueLabel];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Scale(20));
        make.right.mas_equalTo(-Scale(20));
        make.top.mas_equalTo(Scale(20.0));
    }];
    
    [self initCellView:enterSignViewBlock];
    
    [self addLeftViewBottomBtn:enterSignViewBlock];
}

- (void)initMinerLabel
{
    if ([_amount isEqualToString:@"0"]) {
        _valueLabel.text = [NSString stringWithFormat:@"0.00 %@",_currentCoinModel.symobl];
    }else{
        _valueLabel.text = [NSString stringWithFormat:@"%@ %@",_amount.length == 0 ? @"0.00" : _amount,_currentCoinModel.symobl] ;
    }
}

- (void)addLeftViewBottomBtn:(void(^)(void))enterSignViewBlock
{
    WalletGradientLayerButton *nextBtn = [[WalletGradientLayerButton alloc]init];
    [nextBtn setDisableGradientLayer:YES];
    [nextBtn setTitle:VCNSLocalizedBundleString(@"transfer_coin_next_page", nil) forState:UIControlStateNormal];
    [nextBtn.layer setCornerRadius:4];
    [nextBtn setClipsToBounds:YES];
    [_leftView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Scale(20));
        make.right.mas_equalTo(-Scale(20));
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(-Scale(30));
    }];
    nextBtn.block = ^(UIButton *btn) {
        [WalletTools checkNetwork:^(BOOL t) {
            if (t) {
                
                [self leftViewClick:enterSignViewBlock];
            }
        }];
    };
}

- (void)leftViewClick:(void(^)(void))enterSignViewBlock
{
    if (_transferType == WalletContranctTransferType) {
        
        [self enterPreView:enterSignViewBlock];
        
    }else {
        [self checkBalance:enterSignViewBlock];
    }
}

- (void)checkBalance:(void(^)(void))enterSignViewBlock
{
    [_signatureHandle checkBalcanceFromAddress:_fromAddress
                                     coinModel:_currentCoinModel
                                        amount:_amount
                                      gasLimit:_gasLimit
                                         block:^(BOOL result)
     {
         if (result) {
             if (enterSignViewBlock) {
                 enterSignViewBlock();
             }
         }else{
             [_scrollView.superview.superview removeFromSuperview];
         }
     }];
}

- (void)initCellView:(void(^)(void))enterSignViewBlock
{
    NSString *gasFormat = [NSString stringWithFormat:@"%@ VTHO",_gasLimit.length == 0 ? @"0.00" : [WalletTools thousandSeparator:_gasLimit decimals:NO]];
    
    CGFloat jsOffset = 0;
    
    [self creatCell:VCNSLocalizedBundleString(@"contract_payment_info_row1_title", nil)
              value:gasFormat
                  Y: Scale(52 + 20)
          adjustBtn: YES
 enterSignViewBlock:enterSignViewBlock];
    
    if (_needAdjust) {
        [self addAdj_Y:Scale(52 + 20 + 52)];
        jsOffset = 52;
    }
    
    [self creatCell:VCNSLocalizedBundleString(@"contract_payment_info_row2_title", nil)
              value:[WalletTools checksumAddress:_fromAddress]
                  Y:Scale(52 * 2 + 20 + jsOffset)
          adjustBtn:NO
 enterSignViewBlock:enterSignViewBlock];
    
    [self creatCell:VCNSLocalizedBundleString(@"contract_payment_info_row3_title", nil)
              value:[WalletTools checksumAddress:_toAddress]
                  Y:Scale(52 * 3 + 20 + jsOffset)
          adjustBtn:NO
 enterSignViewBlock:enterSignViewBlock];
}

- (void)enterPreView:(void(^)(void))enterSignViewBlock
{
    NSMutableDictionary *proParamDict = [NSMutableDictionary dictionary];
    [proParamDict setValueIfNotNil:_toAddress forKey:@"to"];
    [proParamDict setValueIfNotNil:_amount forKey:@"value"];
    [proParamDict setValueIfNotNil:@(_gas.integerValue) forKey:@"gas"];
    [proParamDict setValueIfNotNil:@(_gasPriceCoef.integerValue) forKey:@"gasPrice"];
    [proParamDict setValueIfNotNil:[SecureData dataToHexString:_clauseData] forKey:@"data"];
    
    WalletDAppSignPreVC *signProVC = [[WalletDAppSignPreVC alloc]init];
    signProVC.dictParam = proParamDict;
    signProVC.block = ^{
        if (enterSignViewBlock) {
            enterSignViewBlock();
        }
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:signProVC];
    [[WalletTools getCurrentVC] presentViewController:nav animated:YES completion:^{
        
    }];
}

- (UIView *)creatCell:(NSString *)title value:(NSString *)value Y:(CGFloat)Y adjustBtn:(BOOL)adjustBtn enterSignViewBlock:(void(^)(void))enterSignViewBlock
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH, Scale(52))];
    contentView.backgroundColor = UIColor.whiteColor;
    [_leftView addSubview:contentView];
    
    // 左名称标签标记
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.text = title;
    leftLabel.textColor = HEX_RGB(0xBDBDBD);
    leftLabel.font = MediumFont(Scale(14.0));
    [leftLabel sizeToFit];
    [contentView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(Scale(20.0));
        make.width.mas_equalTo(leftLabel.mas_width);
    }];
    
    // 右值标签
    UILabel *rightLabel = [[UILabel alloc]init];
    rightLabel.numberOfLines = 0;
    rightLabel.backgroundColor = UIColor.whiteColor;
    rightLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    rightLabel.text = value;
    rightLabel.textColor = CommonBlack;
    rightLabel.font = MediumFont(Scale(14.0));
    [contentView addSubview:rightLabel];
    
    if (adjustBtn) {
        _minerLabel = rightLabel;
        
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(leftLabel.mas_right).offset(Scale(20.0));
        }];
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:VCNSLocalizedBundleString(@"transfer_coin_adjust_cost", nil) forState:UIControlStateNormal];
        [btn setTitleColor:HEX_RGB(0x898CD3) forState:UIControlStateNormal];
        [contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(rightLabel.mas_right).offset(Scale(10.0));
            make.height.mas_equalTo(Scale(50));
        }];
        btn.block = ^(UIButton *btn) {
            if (!_needAdjust) {
                _needAdjust = YES;
                [_leftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                
                [self creatLeftView:enterSignViewBlock];
            }
        };
    }else{
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-Scale(20.0));
            make.left.mas_equalTo(leftLabel.mas_right).offset(Scale(20.0));
        }];
    }
    
    // 下划线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HEX_RGB(0xF6F6F6);
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Scale(20.0));
        make.right.mas_equalTo(-Scale(20.0));
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    return contentView;
}

- (void)addAdj_Y:(CGFloat)Y
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH, 50)];
    [_leftView addSubview:contentView];
    UILabel *slow = [[UILabel alloc]init];
    slow.text = VCNSLocalizedBundleString(@"transfer_coin_slow", nil);
    slow.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:slow];
    [slow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(Scale(50));
    }];
    
    UISlider *slider = [[UISlider alloc]init];
    slider.minimumValue = 0.0;
    slider.maximumValue = 255.0;
    slider.value = 120.0;
    
    [contentView addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70);
        make.right.mas_equalTo(-70);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [slider addTarget:self
               action:@selector(sliderChange:)
     forControlEvents:UIControlEventValueChanged];
    
    UILabel *fast = [[UILabel alloc]init];
    fast.text = VCNSLocalizedBundleString(@"transfer_coin_quick", nil);
    fast.font = [UIFont systemFontOfSize:14];
    
    [contentView addSubview:fast];
    [fast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(Scale(50));
    }];
}

- (void)sliderChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    _gasPriceCoef = [BigNumber bigNumberWithInteger:slider.value];
    
    BigNumber *gasCanUse = [WalletTools calcThorNeeded:slider.value gas:_gas];
    
    _gasLimit = [Payment formatEther:gasCanUse options:2];
    NSString *miner = [_gasLimit stringByAppendingString:@" VTHO"];
    _minerLabel.text = miner;
}

- (void)creatRightView:(void(^)(void))signBlock
{
    _rightView = [[UIView alloc]init];
    [_scrollView addSubview:_rightView];
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(_leftView.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    // 密码输入框
    _pwTextField = [[UITextField alloc]init];
    _pwTextField.placeholder = VCNSLocalizedBundleString(@"wallet_detail_modify_password_dialog_title", nil);
    _pwTextField.secureTextEntry = YES;
    _pwTextField.delegate = self;
    _pwTextField.text = @"";
    [_rightView addSubview:_pwTextField];
    [_pwTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(10);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = HEX_RGB(0xf6f6f6);
    [_rightView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(_pwTextField.mas_bottom);
    }];
    
    // 底部下一步按钮
    _middleBtn = [[WalletGradientLayerButton alloc]init];
    [_middleBtn setDisableGradientLayer:YES];
    [_middleBtn setTitle:VCNSLocalizedBundleString(@"dialog_yes", nil)
                forState:UIControlStateNormal];
    [_rightView addSubview:_middleBtn];
    [_middleBtn.layer setCornerRadius:4];
    [_middleBtn setClipsToBounds:YES];
    [_middleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(-40);
    }];
    @weakify(self);
    _middleBtn.block = ^(UIButton *btn) {
        @strongify(self);
        [self middleViewBtnClick:signBlock];
    };
}

- (void)middleViewBtnClick:(void(^)(void))signBlock
{
    if (_pwTextField.text.length == 0) {
        [WalletAlertShower showAlert:nil
                                 msg:VCNSLocalizedBundleString(@"wallet_detail_modify_password_dialog_title", nil)
                               inCtl:[self getVC]
                               items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                          clickBlock:^(NSInteger index) {
                          }];
    }else{
        [WalletTools checkNetwork:^(BOOL t)
         {
             if (t) {
                 if (signBlock) {
                     signBlock();
                 }
             }
         }];
    }
}

- (void)creatLastView:(void(^)(void))transferBlock removeBlock:(void(^)(void))removeBlock
{
    _lastView = [[UIView alloc]init];
    [_scrollView addSubview:_lastView];
    [_lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(_rightView.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    _timeBtn = [[UIButton alloc]init];
    _timeBtn.backgroundColor = HEX_RGB(0xF9F9F9);
    [_timeBtn setTitle:@"20" forState:UIControlStateNormal];
    [_timeBtn.titleLabel setFont:[UIFont fontWithName:@"DINAlternate-Bold" size:36]];
    [_timeBtn setUserInteractionEnabled:NO];
    [_timeBtn.layer setCornerRadius:45];
    [_timeBtn setClipsToBounds:YES];
    _timeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_timeBtn setTitleColor:HEX_RGB(0x202C56) forState:UIControlStateNormal];
    [_lastView addSubview:_timeBtn];
    [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.centerX.mas_equalTo(_lastView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.tag = 10;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = VCNSLocalizedBundleString(@"contract_payment_confirm_wait_name", nil);
    titleLabel.textColor = CommonBlack;
    titleLabel.font = MediumFont(Scale(14));
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [_lastView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(_timeBtn.mas_bottom).offset(20);
    }];
    
    UILabel *subTitleLabel = [[UILabel alloc]init];
    subTitleLabel.tag = 11;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.text = VCNSLocalizedBundleString(@"contract_payment_confirm_explain", nil);
    subTitleLabel.textColor = HEX_RGB(0xBDBDBD);
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.font = MediumFont(Scale(12));
    [_lastView addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(0);
    }];
    
    // 底部按钮
    _lastBtn = [[WalletGradientLayerButton alloc]init];
    [_lastBtn setDisableGradientLayer:YES];
    [_lastBtn setTitle:VCNSLocalizedBundleString(@"contract_payment_confirm_wait_button", nil)
              forState:UIControlStateNormal];
    [_lastView addSubview:_lastBtn];
    [_lastBtn.layer setCornerRadius:4];
    [_lastBtn setClipsToBounds:YES];
    _lastBtn.titleLabel.font = [UIFont systemFontOfSize:Scale(16.0)];
    [_lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(-40);
    }];
    @weakify(self);
    _lastBtn.block = ^(UIButton *btn) {
        @strongify(self);
        if (removeBlock) {
            removeBlock();
        }
        [self removeFromSuperview];
        
        if (transferBlock) {
            transferBlock();
        }
    };
}

- (UIViewController *)getVC{
    UIResponder *responder = self;
    
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    
    return [WalletTools getCurrentVC];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
