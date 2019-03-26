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
#import "WalletDAppSignPreVC.h"
#import "UIButton+block.h"
#import "WalletDAppSignPreVC.h"
#import "WalletSingletonHandle.h"
#import "NSBundle+Localizable.h"
#import "WalletSignatureViewHandle.h"
#import "WalletSignatureViewSubView.h"
#import "WalletSignatureViewSubView.h"
#import "WalletTools.h"
#import "SecureData.h"
#import "Payment.h"

#define viewHeight Scale(411)

@interface WalletSignatureView ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    BOOL _needAdjust;
    UILabel *_minerLabel;
    
    UIButton *_backBtn;
    UIView *_middleView;
    
    NSString *_contractClauseData;
    NSString *_additionalMsg;
    
    NSTimer *_timer;
    NSString *_tokenID;
    NSString *_expiration;
    
    WalletSignatureViewSubView *_signatureSubView;
    
    UILabel *_titleLabel;
}

@end

@implementation WalletSignatureView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = frame;
        }];
    }
    return self;
}

- (void)updateViewParamModel:(WalletSignParamModel *)paramModel
{
    _fromAddress  = paramModel.fromAddress;
    _toAddress    = paramModel.toAddress;
    _amount       = paramModel.amount;
    _keystore     = paramModel.keystore;
    _clauseList   = paramModel.clauseList;
    
    _gasPriceCoef         = paramModel.gasPriceCoef;
    if (paramModel.clauseData.length > 0) {
        _clauseData           = [SecureData secureDataWithHexString:paramModel.clauseData].data;
    }
    _tokenAddress         = paramModel.tokenAddress;
    _gas                  = [NSNumber numberWithInteger:paramModel.gas.integerValue];
    
    BigNumber *gasCanUse = [WalletTools calcThorNeeded:_gasPriceCoef.decimalString.floatValue gas:_gas];
    _gasLimit = [Payment formatEther:gasCanUse options:2];
    
    _currentCoinModel = [[WalletCoinModel alloc]init];
    _currentCoinModel.transferGas = [NSString stringWithFormat:@"%@",_gas];
    
    [self packageCoinModel];
}

- (void)packageCoinModel
{
    if (_transferType == WalletVETTransferType) {
        _currentCoinModel.symobl = @"VET";
        _currentCoinModel.decimals = 18;
        _currentCoinModel.address = _fromAddress;

        [self initView];
        
    }else if (_transferType == WalletTokenTransferType){
        _currentCoinModel.symobl = @"VTHO";
        _currentCoinModel.decimals = 18;
        _currentCoinModel.address = vthoTokenAddress;
        
        [self initView];
        
    }else{ //合约，显示的只能是vet
        _currentCoinModel.symobl = @"VET";
        _currentCoinModel.decimals = 18;
        _currentCoinModel.address = _fromAddress;

        [self initView];
    }
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
        make.height.mas_equalTo(viewHeight );
    }];
    
    UIView *titleView = [[UIView alloc]init];
    [_middleView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    // 主标题标签
    _titleLabel = [[UILabel alloc]init];
    
    if (_transferType == WalletContranctTransferType) {
        _titleLabel.text = VCNSLocalizedBundleString(@"contract_payment_info_title", nil);
    }else{
        _titleLabel.text = VCNSLocalizedBundleString(@"dialog_coin_transfer_description", nil);
    }
    
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    // 返回箭头按钮
    _backBtn = [[UIButton alloc]init];
    
    UIImage *iamge = [WalletTools localImageWithName:@"icon_close_black"];
    
    [_backBtn setImage:iamge forState:UIControlStateNormal];
    [titleView addSubview:_backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    @weakify(self);
    _backBtn.block = ^(UIButton *btn) {
        @strongify(self);
        [self backBtnClick];
    };
    
    // 分页滑动容器
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    _scrollView.delegate = self;
    [_middleView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(viewHeight - 40);
    }];
    
    
    // 添加隐藏键盘手势点击事件
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(scrollTap)];
    [_scrollView addGestureRecognizer:myTap];
    
    
    // 添加子视图控件【金额，交易费，滑块，签名地址，目标地址，下一步按钮】
    [self addSignatureSubView];
}

#warning 需要多测试
- (void)backBtnClick
{
    [self.signatureSubView.pwTextField resignFirstResponder];
    
    if (self.scrollView.contentOffset.x == SCREEN_WIDTH) {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight - 40) animated:YES];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        //通知webview
        if (self.transferBlock) {
            self.transferBlock(_txid,ERROR_CANCEL);
        }
    }
}

- (void)addSignatureSubView
{
    _signatureSubView = [[WalletSignatureViewSubView alloc]init];
    [_signatureSubView initSignature:_scrollView
                              amount:_amount
                    currentCoinModel:_currentCoinModel
                            gasLimit:_gasLimit
                         fromAddress:_fromAddress
                           toAddress:_toAddress
                        transferType:_transferType
                                 gas:_gas
                        gasPriceCoef:_gasPriceCoef
                          clauseData:_clauseData
                       additionalMsg:_additionalMsg];
     @weakify(self);
    [_signatureSubView creatLeftView:^{
        @strongify(self);
        [self enterSignView];
    }];
    
    [_signatureSubView creatRightView:^{
        
        [WalletTools checkNetwork:^(BOOL t) {
             if(t){
                 @strongify(self);
                 [self signTransfer];
             }
         }];
    }];
    
    [_signatureSubView creatLastView:^{
        @strongify(self);
        if (self.transferBlock) {
            self.transferBlock(self.txid,ERROR_CANCEL);
        }
    }removeBlock:^{
        @strongify(self);
        [self removeFromSuperview];
    } ];
}

- (void)enterSignView
{
    WalletManageModel *walletModel = [[WalletSingletonHandle shareWalletHandle] currentWalletModel];
    if (!walletModel.observer.boolValue) {
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollView.contentOffset.x == SCREEN_WIDTH) {
        UIImage *iamge = [WalletTools localImageWithName:@"icon_back_black"];
        [_backBtn setImage:iamge forState:UIControlStateNormal];
        
        _titleLabel.text = VCNSLocalizedBundleString(@"dialog_coin_transfer_password", nil);
        
    }else if (_scrollView.contentOffset.x == SCREEN_WIDTH * 2){
        UIImage *iamge = [WalletTools localImageWithName:@"icon_close_black"];
        [_backBtn setImage:iamge forState:UIControlStateNormal];
        
        
        _titleLabel.text = VCNSLocalizedBundleString(@"token_list_packaging", nil);
        
    }else{
        UIImage *iamge = [WalletTools localImageWithName:@"icon_close_black"];
        [_backBtn setImage:iamge forState:UIControlStateNormal];
        if (_transferType == WalletContranctTransferType) {
            _titleLabel.text = VCNSLocalizedBundleString(@"contract_payment_info_title", nil);
            
        }else{
            _titleLabel.text = VCNSLocalizedBundleString(@"dialog_coin_transfer_description", nil);
        }
    }
}

- (void)timerCountBlock
{
    @weakify(self);
    __block NSInteger count = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             repeats:YES
                                               block:^(NSTimer * _Nonnull timer)
              {
                @strongify(self);
                NSInteger time = _signatureSubView.timeBtn.titleLabel.text.integerValue;
                time --;
                count ++;
                  
                if (time > 0) {
                    [_signatureSubView.timeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)time] forState:UIControlStateNormal];
                }else{
                    [_signatureSubView.timeBtn setTitle:[NSString stringWithFormat:@"%d",20] forState:UIControlStateNormal];
                }
                  if (time%10 == 0) {
                      [self checkUploadBlock];
                  }
                  if (count >= 60) {
                      
                      [self uploadFail];
                      [_timer invalidate];
                      _timer = nil;
                  }
                  
              }];
}

- (void)uploadSuccess
{
    [_signatureSubView.timeBtn setTitle:@"" forState:UIControlStateNormal];
    [_signatureSubView.lastBtn setTitle:VCNSLocalizedBundleString(@"dialog_confirm", nil) forState:UIControlStateNormal];
    [_signatureSubView.timeBtn setImage:[WalletTools localImageWithName:@"Group 3"] forState:UIControlStateNormal];
    
    UILabel *titleLabel = [_signatureSubView.lastView viewWithTag:10];
    titleLabel.text = VCNSLocalizedBundleString(@"contract_payment_confirm_success", nil);
    
    UILabel *subTitleLabel = [_signatureSubView.lastView viewWithTag:11];
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
                 [self notificatonJS];
             }else {
                 [self uploadFail];
             }
         }
     }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
         [self uploadFail];
     }];
}

- (void)notificatonJS
{
    //js 成功后跳转到js 页面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.transferBlock) {
            self.transferBlock(self.txid,OK);
        }
        [self removeFromSuperview];
    });
}

-(void)uploadFail
{
    [_signatureSubView.timeBtn setTitle:@"" forState:UIControlStateNormal];
    [_signatureSubView.lastBtn setTitle:VCNSLocalizedBundleString(@"dialog_confirm", nil) forState:UIControlStateNormal];
    [_signatureSubView.timeBtn setImage:[WalletTools localImageWithName:@"icon_shibai"] forState:UIControlStateNormal];
    
    UILabel *titleLabel = [_signatureSubView.lastView viewWithTag:10];
    titleLabel.text = VCNSLocalizedBundleString(@"contract_payment_result_fail", nil);
    
    UILabel *subTitleLabel = [_signatureSubView.lastView viewWithTag:11];
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
}

@end
