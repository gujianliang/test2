//
//  WalletSignatureVC.m
//  VeWallet
//
//  Created by 曾新 on 2018/10/15.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletSignatureView.h"
#import "WalletGradientLayerButton.h"
#import "WalletBlockInfoApi.h"
#import "WalletTransactionApi.h"
#import "WalletTransantionsReceiptApi.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletSignatureView+transferToken.h"
#import "WalletSignatureView+transferObserver.h"
#import "WalletDAppSignPreVC.h"
#import "UIButton+block.h"
#import "WalletDAppSignPreVC.h"
#import "WalletSingletonHandle.h"
#import "NSBundle+Localizable.h"

#define viewHeight 411

@interface WalletSignatureView ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    BOOL _needAdjust;
    UILabel *_minerLabel;
    
    UIView *_leftView;
    UIView *_rightView;
    UIView *_LastView;
    UIButton *_backBtn;
    UIView *_middleView;
    UILabel *_valueLabel;
    
    NSString *_contractClauseData;
    NSArray *_params;
    NSString *_additionalMsg;
    
    UIButton *_timeBtn;
    NSTimer *_timer;
    NSString *_tokenID;
    NSString *_expiration;
    
    WalletGradientLayerButton *_middleBtn;
    WalletGradientLayerButton *_lastBtn;
}

@end

@implementation WalletSignatureView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = frame;
    }];
    return self;
}

- (void)updateView:(NSString *)fromAddress
         toAddress:(NSString *)toAddress
      contractType:(ContractType)contractType
            amount:(NSString *)amount
            params:(NSArray *)params
{
    _fromAddress = fromAddress;
    _toAddress = toAddress;
    _contractType = contractType;
    _params = params;
    _amount = amount;

    NSDictionary *dictContractData = [FFBMSTools getContractData:contractType params:params];
    _gasLimit = dictContractData[@"gasLimit"];
    _contractClauseData = dictContractData[@"contractClauseData"];
    _additionalMsg = dictContractData[@"additionalMsg"];
    
    if (contractType == NoContract_transferToken) {
        NSDictionary *dictParam = [params firstObject];
        _gasLimit = dictParam[@"miner"];
        _gasLimit = [_gasLimit stringByReplacingOccurrencesOfString:@"VTHO" withString:@""];
        _currentCoinModel = dictParam[@"coinModel"];
        _gasPriceCoef = dictParam[@"gasPriceCoef"];
        NSNumber *numberIsICO = dictParam[@"isICO"];
        _isICO = numberIsICO.boolValue;
        _clouseData = dictParam[@"clouseData"];
        self.tokenAddress = dictParam[@"tokenAddress"];
        _gas = dictParam[@"gas"];
        
        if (_transferType == JSContranctTransferType) {
        
            NSString *clouseStr = [SecureData dataToHexString:_clouseData];
            NSString *temp1 = [clouseStr stringByReplacingOccurrencesOfString:@"0x" withString:@""];
            NSString *temp2 = [temp1 substringFromIndex:8];
            
            NSInteger i = temp2.length%(64);
            NSInteger j = temp2.length/64;
            
            NSMutableArray *tempList = [NSMutableArray array];
            if (i == 0) {
                for (NSInteger k = 0;k < j;k++) {
                    NSString *temp3 = [temp2 substringWithRange:NSMakeRange(k*64, 64)];
                    [tempList addObject:temp3];
                }
            }
            _params = [tempList copy];
        }
    }
    
    [self initView];
}

- (void)tokenID:(NSString *)tokenID expiration:(NSString *)expiration
{
    _tokenID = tokenID;
    _expiration = expiration;
}

- (void)initView
{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.4;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    _middleView = [[UIView alloc]init];
    _middleView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_middleView];
    [_middleView setClipsToBounds:YES];
    [_middleView.layer setCornerRadius:4];
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(viewHeight);
    }];
    
    UIView *titleView = [[UIView alloc]init];
    [_middleView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    // 主标题标签
    UILabel *titleLabel = [[UILabel alloc]init];
    
    if (_contractType == NoContract_transferToken) {
        titleLabel.text = VCNSLocalizedBundleString(@"dialog_coin_transfer_description", nil);

    }else{
        titleLabel.text = VCNSLocalizedBundleString(@"contract_payment_info_title", nil);
    }
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    // 返回箭头按钮
    _backBtn = [[UIButton alloc]init];
    
    UIImage *iamge = [FFBMSTools localImageWithName:@"icon_close_black"];
    
    [_backBtn setImage:iamge forState:UIControlStateNormal];
    [titleView addSubview:_backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    @weakify(self);
    _backBtn.block = ^(UIButton *btn) {
        @strongify(self);
        
        [self.pwTextField resignFirstResponder];
        
        if (self.scrollView.contentOffset.x == SCREEN_WIDTH) {
            [self.scrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight - 40) animated:YES];
        }else if (self.scrollView.contentOffset.x == SCREEN_WIDTH * 2) {
            [self removeFromSuperview];
            BOOL hasListVC = NO;
            if (!hasListVC) {
                [[FFBMSTools getCurrentVC].navigationController popViewControllerAnimated:YES];
            }
            
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [self setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                if (self.transferBlock) {
                    self.transferBlock(self.txid);
                }
            }];
        }
    };
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    _scrollView.delegate = self;
    [_middleView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(viewHeight - 40);
    }];
    
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap)];
    [_scrollView addGestureRecognizer:myTap];
    
    [self creatLeftView];
    [self creatRightView];
    [self creatLastView];
}

-(void)creatLeftView
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
    
    if (_contractType == Contract_acceptNode || _contractType == Contract_buyNode) {
        if ([_amount isEqualToString:@"0"]) {
            _valueLabel.text = @"0.00 VET";
        }else{
            NSString *vet = [FFBMSTools thousandSeparator:_amount decimals:YES];
            _valueLabel.text = [NSString stringWithFormat:@"%@ VET",_amount.length == 0 ? @"0.00" : vet] ;
        }
    }else if(_contractType == NoContract_transferToken){
        
        NSString *vet = [FFBMSTools thousandSeparator:_amount decimals:YES];
        
        _valueLabel.text = [NSString stringWithFormat:@"%@ %@",_amount.length == 0 ? @"0.00" : vet,_currentCoinModel.coinName.length > 0 ?_currentCoinModel.coinName :@"VET" ];
    }
    else{
        _valueLabel.text = [NSString stringWithFormat:@"0.00 VET"] ;
    }
    
    _valueLabel.adjustsFontSizeToFitWidth = YES;
    _valueLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [_leftView addSubview:_valueLabel];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Scale(20));
        make.right.mas_equalTo(-Scale(20));
        make.top.mas_equalTo(Scale(20.0));
    }];

    NSString *gasFormat = [NSString stringWithFormat:@"%@ VTHO",_gasLimit.length == 0 ? @"0.00" : [FFBMSTools thousandSeparator:_gasLimit decimals:NO]];
    
    CGFloat jsOffset = 0;
    
    [self creatCell:VCNSLocalizedBundleString(@"contract_ayment_info_row1_title", nil)
              value:gasFormat
                  Y:52 + 20
          adjustBtn: _jsUse ? YES : NO];
    
    if (_needAdjust) {
        [self addAdj_Y:52 + 20 + 52];
        jsOffset = 52;
    }
    
    [self creatCell:VCNSLocalizedBundleString(@"contract_payment_info_row2_title", nil)
              value:[FFBMSTools checksumAddress:_fromAddress]
                  Y:52 * 2 + 20 + jsOffset
          adjustBtn:NO];
    
    [self creatCell:VCNSLocalizedBundleString(@"contract_payment_info_row3_title", nil)
              value:[FFBMSTools checksumAddress:_toAddress]
                  Y:52 * 3 + 20 + jsOffset
          adjustBtn:NO];
    
    if (!_jsUse) { // js调用没有描述
        [self creatCell:VCNSLocalizedBundleString(@"contract_payment_info_row4_title", nil)
                  value:_additionalMsg
                      Y:52 * 4 + 20
              adjustBtn:NO];
    }
    
    WalletGradientLayerButton *nextBtn = [[WalletGradientLayerButton alloc]init];
    [nextBtn setDisableGradientLayer:YES];
    [nextBtn setTitle:VCNSLocalizedBundleString(@"transfer_coin_next_page", nil) forState:UIControlStateNormal];
    [nextBtn.layer setCornerRadius:4];
    [nextBtn setClipsToBounds:YES];
    [_leftView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Scale(20));
        make.right.mas_equalTo(-Scale(20));
        make.height.mas_equalTo(Scale(44));
        make.bottom.mas_equalTo(-Scale(30));
    }];
    @weakify(self)
    nextBtn.block = ^(UIButton *btn) {
        @strongify(self)
        [FFBMSTools checkNetwork:^(BOOL t) {
            if (t) {
                
                if (self.jsUse && _transferType == JSContranctTransferType) {
                    
                    NSMutableDictionary *proParamDict = [NSMutableDictionary dictionary];
                    [proParamDict setValueIfNotNil:_toAddress forKey:@"to"];
                    [proParamDict setValueIfNotNil:_amount forKey:@"value"];
                    [proParamDict setValueIfNotNil:@(_gas.integerValue) forKey:@"gas"];
                    [proParamDict setValueIfNotNil:@(_gasPriceCoef.integerValue) forKey:@"gasPrice"];
                    [proParamDict setValueIfNotNil: [SecureData dataToHexString:_clouseData] forKey:@"data"];
                    
                    WalletDAppSignPreVC *signProVC = [[WalletDAppSignPreVC alloc]init];
                    signProVC.dictParam = proParamDict;
                    @weakify(self);
                    signProVC.block = ^{
                        @strongify(self);
                        [self enterSignView];
                    };
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:signProVC];
                    [[FFBMSTools getCurrentVC] presentViewController:nav animated:YES completion:^{
                        
                    }];
                }else if (self.jsUse){
                    
                    //js 检查 vet vtho
                    WalletManageModel *fromModel = nil;
                    for (WalletManageModel *temp in [[WalletSingletonHandle shareWalletHandle] getAllWallet]) {
                        if ([temp.address.lowercaseString isEqualToString:self.fromAddress.lowercaseString]) {
                            fromModel = temp;
                            break;
                        }
                    }
                    if (fromModel) {
                        
                        BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:fromModel.VETCount];
                        NSString *vetBalance = [Payment formatEther:bigNumberCount];
                        
                        NSDecimalNumber *vetBalanceNum = [NSDecimalNumber decimalNumberWithString:vetBalance];
                        NSDecimalNumber *amountNum = [NSDecimalNumber decimalNumberWithString:self.amount];
                        
                        if ([vetBalanceNum compare:amountNum] == NSOrderedAscending) {
                            
                            NSString *tempAmount = _amount;
                            if ([_amount containsString:@"0x"]) {
                                
                                BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:_amount];
                                tempAmount = [Payment formatEther:bigNumberCount];
                            }
                            
                            NSString *msg = [NSString stringWithFormat:@"您当前地址余额%.2fVET，不够支付%.2fVET",vetBalance.floatValue,tempAmount.floatValue];
                            
                            [FFBMSAlertShower showAlert:@"余额不足提示"
                                                    msg:msg
                                                  inCtl:[FFBMSTools getCurrentVC]
                                                  items:@[@"确定"]
                                             clickBlock:^(NSInteger index)
                             {

                             }];
                            return ;
                        }
                        
                        //vtho 不足
                        {
                            WalletCoinModel *vthoModel = fromModel.vthoModel;
                            
                            BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:vthoModel.coinCount];
                            NSString *vthoBalance = [Payment formatEther:bigNumberCount];
                            
                            NSDecimalNumber *vthoBalanceNum = [NSDecimalNumber decimalNumberWithString:vthoBalance];
                            
                            
                            NSDecimalNumber *transferVthoAmount = [NSDecimalNumber decimalNumberWithString:_gasLimit];
                            
                            
                            if ([vthoBalanceNum   compare:transferVthoAmount] == NSOrderedAscending) {
                                
                                
                                
                                NSString *msg = [NSString stringWithFormat:@"您当前地址余额%.2fVTHO，不够支付%.2fVTHO",vthoBalanceNum.floatValue,_gasLimit.floatValue];
                                
                                [FFBMSAlertShower showAlert:@"余额不足提示"
                                                        msg:msg
                                                      inCtl:[FFBMSTools getCurrentVC]
                                                      items:@[@"确定"]
                                                 clickBlock:^(NSInteger index)
                                 {

                                 }];
                                return;
                            }
                           
                        }
                        
                        [self enterSignView];
                        
                    }else{
                        [self enterSignView];
                    }
                }
                else{
                    [self enterSignView];
                }                
            }
        }];
    };
}

- (void)enterSignView
{
    WalletManageModel *walletModel = [[WalletSingletonHandle shareWalletHandle] currentWalletModel];
    if (walletModel.observer.boolValue) {
        if (_transferType != JSContranctTransferType && self.jsUse) {
            [self transferAccountObserver:_amount];
        }
    }else
    {
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
}

- (UIView *)creatCell:(NSString *)title value:(NSString *)value Y:(CGFloat)Y adjustBtn:(BOOL)adjustBtn
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH, 40)];
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
    rightLabel.backgroundColor = UIColor.clearColor;
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
            make.height.mas_equalTo(50);
        }];
        btn.block = ^(UIButton *btn) {
            if (!_needAdjust) {
                _needAdjust = YES;
                [_leftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self creatLeftView];
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
        make.width.mas_equalTo(50);
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
        make.width.mas_equalTo(50);
    }];
}

- (void)sliderChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    _gasPriceCoef = [BigNumber bigNumberWithInteger:slider.value];
    BigNumber *gasBig = [BigNumber bigNumberWithNumber:_gas];
    
    BigNumber *gasCanUse = [[[[BigNumber bigNumberWithDecimalString:@"1000000000000000"] mul:[BigNumber bigNumberWithInteger:(1+slider.value/255.0)*1000000]] mul:gasBig] div:[BigNumber bigNumberWithDecimalString:@"1000000"]];
    _gasLimit = [Payment formatEther:gasCanUse options:2];
    NSString *miner = [_gasLimit stringByAppendingString:@" VTHO"];
    _minerLabel.text = miner;
}

- (void)creatRightView
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
        if (_pwTextField.text.length == 0) {
            [FFBMSAlertShower showAlert:nil
                                    msg:VCNSLocalizedBundleString(@"wallet_detail_modify_password_dialog_title", nil)
                                  inCtl:[self getVC]
                                  items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                             clickBlock:^(NSInteger index) {
                             }];
        }else{
            [FFBMSTools checkNetwork:^(BOOL t) {
                if (t) {
                    [self sign];
                }
            }];
        }
    };
}

- (void)creatLastView
{
    _LastView = [[UIView alloc]init];
    [_scrollView addSubview:_LastView];
    [_LastView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [_LastView addSubview:_timeBtn];
    [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.centerX.mas_equalTo(_LastView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];

    // "contract_payment_confirm_wait_name" = "正在等待合约打包上链...";
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.tag = 10;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = VCNSLocalizedBundleString(@"contract_payment_confirm_wait_name", nil);
    titleLabel.textColor = CommonBlack;
    titleLabel.font = MediumFont(Scale(14));
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [_LastView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(_timeBtn.mas_bottom).offset(20);
    }];
    
    // "contract_payment_confirm_explain" = "打包时间视主网拥堵情况，正常10秒左右会完成打包，请耐心等待";
    UILabel *subTitleLabel = [[UILabel alloc]init];
    subTitleLabel.tag = 11;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.text = VCNSLocalizedBundleString(@"contract_payment_confirm_explain", nil);
    subTitleLabel.textColor = HEX_RGB(0xBDBDBD);
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.font = MediumFont(Scale(12));
    [_LastView addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(0);
    }];
    
    // 底部按钮
    // "contract_payment_confirm_wait_button" = "不等了，先看看";
    _lastBtn = [[WalletGradientLayerButton alloc]init];
    [_lastBtn setDisableGradientLayer:YES];
    [_lastBtn setTitle:VCNSLocalizedBundleString(@"contract_payment_confirm_wait_button", nil)
              forState:UIControlStateNormal];
    [_LastView addSubview:_lastBtn];
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
        [self removeFromSuperview];
        
        if (_contractType == NoContract_transferToken) {
            
            if (self.transferBlock) {
                self.transferBlock(self.txid);
            }
            return ;
        }
        BOOL hasListVC = NO;
       
        if (!hasListVC) {
            [[FFBMSTools getCurrentVC].navigationController popViewControllerAnimated:YES];
        }
    };
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"dd");
    if (_scrollView.contentOffset.x == SCREEN_WIDTH) {
        [_backBtn setImage:[FFBMSTools localImageWithName:@"icon_back_black"] forState:UIControlStateNormal];
        
    }else if (_scrollView.contentOffset.x == SCREEN_WIDTH * 2){
        [_backBtn setImage:[FFBMSTools localImageWithName:@"icon_close_black"] forState:UIControlStateNormal];
    }
    else{
        [_backBtn setImage:[FFBMSTools localImageWithName:@"icon_close_black"] forState:UIControlStateNormal];
    }
}

- (void)sign
{
    if (_contractType == NoContract_transferToken) {
        [self signTransfer:_transferBlock];
        return;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)timerCountBlock
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             repeats:YES
                                               block:^(NSTimer * _Nonnull timer)
              {
                NSInteger time = _timeBtn.titleLabel.text.integerValue;
                time --;
                if (time > 0) {
                    [_timeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)time] forState:UIControlStateNormal];
                }else{
                    [_timeBtn setTitle:[NSString stringWithFormat:@"%d",20] forState:UIControlStateNormal];
                }
                  
                  if (time%10 == 0) {
                      [self checkUploadBlock];
                  }
              }];
}

- (void)uploadSuccess
{
    [_timeBtn setTitle:@"" forState:UIControlStateNormal];
    [_lastBtn setTitle:VCNSLocalizedBundleString(@"dialog_confirm", nil) forState:UIControlStateNormal];
    [_timeBtn setImage:[FFBMSTools localImageWithName:@"Group 3"] forState:UIControlStateNormal];
    
    UILabel *titleLabel = [_LastView viewWithTag:10];
    titleLabel.text = VCNSLocalizedBundleString(@"contract_payment_confirm_success", nil);
    
    UILabel *subTitleLabel = [_LastView viewWithTag:11];
    subTitleLabel.text = VCNSLocalizedBundleString(@"contract_payment_confirm_actual_explian", nil);
    [_timer invalidate];
    _timer = nil;
    
    if (_block) {
        _block(YES);
    }
}

- (void)checkUploadBlock
{
    @weakify(self);
    WalletTransantionsReceiptApi *receiptApi = [[WalletTransantionsReceiptApi alloc]initWithTxid:_txid];
    [receiptApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi)
     {
         @strongify(self);
         // 没有打包进去，返回nil
         WalletTransantionsReceiptModel *receiptModel = finishApi.resultModel;
         if (receiptModel != nil) {
             if (!receiptModel.reverted) {
                 [self uploadSuccess];
                 
                 //js 成功后跳转到js 页面
                 if (_contractType == NoContract_transferToken) {
                     
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         if (self.transferBlock) {
                             self.transferBlock(self.txid);
                         }
                         [self removeFromSuperview];
                     });
                 }
                 
             }else {
                 [self uploadFail];
             }
         }
     }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
         
     }];
}

-(void)uploadFail
{
    [_timeBtn setTitle:@"" forState:UIControlStateNormal];
    [_lastBtn setTitle:VCNSLocalizedBundleString(@"dialog_confirm", nil) forState:UIControlStateNormal];
    [_timeBtn setImage:[UIImage imageNamed:@"icon_shibai"] forState:UIControlStateNormal];
    
    UILabel *titleLabel = [_LastView viewWithTag:10];
    titleLabel.text = VCNSLocalizedBundleString(@"contract_payment_result_fail", nil);
    
    UILabel *subTitleLabel = [_LastView viewWithTag:11];
    subTitleLabel.text = @"";
    
    [_timer invalidate];
    _timer = nil;
    if (_block) {
        _block(NO);
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    
    [self endEditing:YES];
}

- (void)scrollTap
{
    [self endEditing:YES];
}



- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIViewController *)getVC{
    UIResponder *responder = self;
    
    while ((responder = [responder nextResponder])) {
            if ([responder isKindOfClass:[UIViewController class]]) {
                return (UIViewController *)responder;
            }
    }
    
    return [FFBMSTools getCurrentVC];
}

@end
