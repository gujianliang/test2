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

#define viewHeight 411

@interface WalletSignatureView ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    BOOL _needAdjust;
    UILabel *_minerLabel;
    
    UIButton *_backBtn;
    UIView *_middleView;
    
    NSString *_contractClauseData;
    NSArray *_params;
    NSString *_additionalMsg;
    
    NSTimer *_timer;
    NSString *_tokenID;
    NSString *_expiration;
    
    WalletSignatureViewHandle *_signatureHandle;
    WalletSignatureViewSubView *_signatureSubView;
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
        _signatureHandle = [[WalletSignatureViewHandle alloc]init];
    }
    return self;
}

- (void)updateView:(NSString *)fromAddress
         toAddress:(NSString *)toAddress
      contractType:(ContractType)contractType
            amount:(NSString *)amount
            params:(NSArray *)params
{
    _fromAddress  = fromAddress;
    _toAddress    = toAddress;
    _contractType = contractType;
    _params       = params;
    _amount       = amount;

    NSDictionary *dictContractData = [WalletTools getContractData:contractType params:params];
    _gasLimit                      = dictContractData[@"gasLimit"];
    _contractClauseData            = dictContractData[@"contractClauseData"];
    _additionalMsg                 = dictContractData[@"additionalMsg"];
    
    if (contractType == NoContract_transferToken) {
        NSDictionary *dictParam = [params firstObject];
        
        _currentCoinModel     = dictParam[@"coinModel"];
        _gasPriceCoef         = (BigNumber *)(dictParam[@"gasPriceCoef"]);
        _clauseData           = dictParam[@"clauseData"];
        _tokenAddress         = dictParam[@"tokenAddress"];
        _gas                  = dictParam[@"gas"];
        
        BigNumber *gasCanUse = [WalletTools calcThorNeeded:_gasPriceCoef.decimalString.floatValue gas:_gas];
        _gasLimit = [Payment formatEther:gasCanUse options:2];

        if (_transferType == JSContranctTransferType) {
        
            [self resolverClouseData];
        }
    }
    
    [self initView];
}

- (void)resolverClouseData
{
    NSString *clouseStr = [SecureData dataToHexString:_clauseData];
    NSString *temp1     = [clouseStr stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    NSString *temp2     = [temp1 substringFromIndex:8];
    
    NSInteger i = temp2.length%(64);
    NSInteger j = temp2.length/64;
    
    NSMutableArray *tempList = [NSMutableArray array];
    if (i == 0) {
        for (NSInteger k = 0;k < j;k++) {
            NSString *temp3 = [temp2 substringWithRange:NSMakeRange(k*64, 64)];
            [tempList addObject:temp3];
        }
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
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    _scrollView.delegate = self;
    [_middleView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(viewHeight - 40);
    }];
    
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(scrollTap)];
    [_scrollView addGestureRecognizer:myTap];
    
    [self addSignatureSubView];
}

- (void)backBtnClick
{
    [self.signatureSubView.pwTextField resignFirstResponder];
    
    if (self.scrollView.contentOffset.x == SCREEN_WIDTH) {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight - 40) animated:YES];
    }else if (self.scrollView.contentOffset.x == SCREEN_WIDTH * 2) {
        [self removeFromSuperview];
        BOOL hasListVC = NO;
        if (!hasListVC) {
            [[WalletTools getCurrentVC].navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
//            if (self.transferBlock) {
//                self.transferBlock(self.txid);
//            }
        }];
    }
}

- (void)addSignatureSubView
{
    _signatureSubView = [[WalletSignatureViewSubView alloc]init];
    [_signatureSubView initSignature:_scrollView
                        contractType:_contractType
                              amount:_amount
                    currentCoinModel:_currentCoinModel
                            gasLimit:_gasLimit
                         fromAddress:_fromAddress
                           toAddress:_toAddress
                         pwTextField:self.signatureSubView.pwTextField
                        transferType:_transferType
                                 gas:_gas
                        gasPriceCoef:_gasPriceCoef
                          clauseData:_clauseData
                     signatureHandle:_signatureHandle
                       additionalMsg:_additionalMsg];
    
    [_signatureSubView creatLeftView:^{
        [self enterSignView];
    }];
    
    [_signatureSubView creatRightView:^{
        [self sign];
    }];
    
    [_signatureSubView creatLastView:^{
        if (self.transferBlock) {
            self.transferBlock(self.txid);
        }
    }removeBlock:^{
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
    NSLog(@"dd");
    if (_scrollView.contentOffset.x == SCREEN_WIDTH) {
        [_backBtn setImage:[WalletTools localImageWithName:@"icon_back_black"] forState:UIControlStateNormal];
        
    }else if (_scrollView.contentOffset.x == SCREEN_WIDTH * 2){
        [_backBtn setImage:[WalletTools localImageWithName:@"icon_close_black"] forState:UIControlStateNormal];
    }
    else{
        [_backBtn setImage:[WalletTools localImageWithName:@"icon_close_black"] forState:UIControlStateNormal];
    }
}

- (void)sign
{
    if (_contractType == NoContract_transferToken) {
        [self signTransfer:_transferBlock];
        return;
    }
}

- (void)timerCountBlock
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             repeats:YES
                                               block:^(NSTimer * _Nonnull timer)
              {
                NSInteger time = _signatureSubView.timeBtn.titleLabel.text.integerValue;
                time --;
                if (time > 0) {
                    [_signatureSubView.timeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)time] forState:UIControlStateNormal];
                }else{
                    [_signatureSubView.timeBtn setTitle:[NSString stringWithFormat:@"%d",20] forState:UIControlStateNormal];
                }
                  if (time%10 == 0) {
                      [self checkUploadBlock];
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
    if (_contractType == NoContract_transferToken) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.transferBlock) {
                self.transferBlock(self.txid);
            }
            [self removeFromSuperview];
        });
    }
}

-(void)uploadFail
{
    [_signatureSubView.timeBtn setTitle:@"" forState:UIControlStateNormal];
    [_signatureSubView.lastBtn setTitle:VCNSLocalizedBundleString(@"dialog_confirm", nil) forState:UIControlStateNormal];
    [_signatureSubView.timeBtn setImage:[UIImage imageNamed:@"icon_shibai"] forState:UIControlStateNormal];
    
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
