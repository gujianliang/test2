//
//  WalletPaymentQRCodeView.m
//  VeWallet
//
//  Created by 曾新 on 2018/8/20.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletPaymentQRCodeView.h"
#import "WalletGradientLayerButton.h"
#import "FFBMSTextView.h"
#import "FFBMSTools.h"
#import "UIView+Sizes.h"

//#import "WalletScanQRCodeVC.h"

#import "Masonry.h"

#define  titleFont  [UIFont systemFontOfSize:12 weight:UIFontWeightMedium]

@interface WalletPaymentQRCodeView ()
{
    UIView *_contentView;
    UILabel *_titleLabel;
    NSString *_jsonStr;
    WalletGradientLayerButton *_confirmBtn;
    QRCodeAddressType _codeType;
}

@property (strong, nonatomic) UILabel *textView;

@end

@implementation WalletPaymentQRCodeView

- (instancetype)initWithFrame:(CGRect)frame
                         type:(QRCodeViewType)viewType
                         json:(NSString *)json
                     codeType:(QRCodeAddressType)codeType
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewType = viewType;
        _jsonStr = json;
        _codeType = codeType;
        [self initView];
    }
    return self;
}

- (void)initView
{
    UIView *bgView = [[UIView alloc]init];
    [bgView setBackgroundColor:[UIColor blackColor]];
    bgView.alpha = 0.4;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    _contentView = [[UIView alloc]init];
    _contentView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_contentView];
    [FFBMSTools circualarView:_contentView Radius:4];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(430);
    }];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"icon_close_white-1"] forState:UIControlStateNormal];
    [_contentView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(removeFromSuper) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    _titleLabel = [[UILabel alloc]init];
    [_titleLabel setFont:[UIFont systemFontOfSize:Scale(16.0) weight:UIFontWeightMedium]];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    _titleLabel.textColor = HEX_RGB(0x202C56);
    [_contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(20);
    }];
    
    // 添加下一步按钮
    _confirmBtn = [[WalletGradientLayerButton alloc] init];
    [_confirmBtn addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_confirmBtn];
    
    [FFBMSTools circualarView:_confirmBtn Radius:4];
    CGFloat bottom = (iS_iPhoneX) ? -35 : -24;
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(bottom);
        make.height.mas_equalTo(44);
    }];
    
    
    [self creatMiddleView:_viewType];
}

- (void)removeFromSuper {
    
    __block UIView *superV = _contentView.superview;
    
    [UIView animateWithDuration:0.3 animations:^{
        [superV setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
    } completion:^(BOOL finished) {
        [superV removeFromSuperview];
        superV = nil;
    }];
    
    if (_blockBack) {
        _blockBack();
    }
}

- (void)clickNext:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;

    if(_viewType == HotWalletScanType
       && _codeType != QRCodeObserverAuthType){ // 发送交易
        
        [FFBMSTools checkNetwork:^(BOOL t)
        {
            if (t) {
                if (_confirmBtn.userInteractionEnabled) {
                    if (weakSelf.block) {
                        weakSelf.block(weakSelf.textView.text);
                    }
                }
            }
        }];
    }else {
        
        if (_confirmBtn.userInteractionEnabled) {
            if (weakSelf.block) {
                weakSelf.block(weakSelf.textView.text);
            }
        }
    }
}

- (void)creatMiddleView:(QRCodeViewType)viewType
{    
    switch (_viewType) {
    case HotWalletQrCodeType:
        {
            // 使用冷钱包扫码
            _titleLabel.text = NSLocalizedString(@"observer_transfer_dialog_title", nil);
            [_confirmBtn setTitle:NSLocalizedString(@"transfer_coin_next_page", nil)
                         forState:UIControlStateNormal];
            [_confirmBtn setGrayGradientLayerType:highYellowType];
            
            UIImage *qrCodeImage = [FFBMSTools creatQRcodeImage:_jsonStr];
            UIImageView *qrImageView = [[UIImageView alloc]init];
            [qrImageView setImage:qrCodeImage];
            [_contentView addSubview:qrImageView];
            [qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_contentView.centerX);
                make.size.mas_equalTo(CGSizeMake(215, 215));
                make.top.mas_equalTo(60);
            }];
            
            // 当前为观察钱包
            UILabel *subTitle = [[UILabel alloc]init];
            
            subTitle.textColor = HEX_RGB(0x898CD3);
            subTitle.textAlignment = NSTextAlignmentCenter;
            subTitle.font = titleFont;
            
            NSString *str = NSLocalizedString(@"observer_transfer_dialog_des1_1", nil);
            NSMutableAttributedString *ats = [[NSMutableAttributedString alloc] initWithString:str];
            
            NSRange range1 = [str rangeOfString: @"ffffe901"];
            [ats addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#FFAE03"],
                                 NSFontAttributeName : [UIFont fontWithName:@"icomoon" size:Scale(12.0)]}
                         range:range1];
            NSRange range2 = [str rangeOfString: NSLocalizedString(@"f9_HOT_wallet", nil)];
            [ats addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#FFAE03"],
                                 NSFontAttributeName : [UIFont systemFontOfSize:Scale(12.0)]}
                         range:range2];
            subTitle.attributedText = ats;
            
            [_contentView addSubview:subTitle];
            [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_contentView.centerX);
                make.top.mas_equalTo(qrImageView.mas_bottom).offset(15);
                make.height.mas_equalTo(16);
            }];
            
            // 请用冷钱包扫描二维码，待签名完成后进入下一步
            UILabel *subTitle1 = [[UILabel alloc]init];
            subTitle1.text = NSLocalizedString(@"observer_transfer_dialog_des2", nil);
            subTitle1.textColor = HEX_RGB(0x898CD3);
            subTitle1.numberOfLines = 0;
            subTitle1.textAlignment = NSTextAlignmentCenter;
            subTitle1.font = titleFont;
            [_contentView addSubview:subTitle1];
            [subTitle1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_contentView.centerX);
                make.top.mas_equalTo(subTitle.mas_bottom).offset(5);
                make.left.mas_equalTo(Scale(20));
                make.rightMargin.mas_equalTo(-Scale(20));
            }];
            
        }
        break;
            
    case HotWalletScanType:
        {
            // 读入签名数据
            _titleLabel.text = NSLocalizedString(@"observer_transfer_dialog2_title", nil);
            // 发送交易
            [_confirmBtn setTitle:NSLocalizedString(@"observer_transfer_dialog2_button", nil)
                         forState:UIControlStateNormal];
            [_confirmBtn setGrayGradientLayerType:lowYellowType];
            _confirmBtn.userInteractionEnabled = NO;
            
            UIButton *scanBtn = [[UIButton alloc]init];
            [scanBtn setImage:[UIImage imageNamed:@"icon_scan_QR_Big"] forState:UIControlStateNormal];
            [_contentView addSubview:scanBtn];
            [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_contentView.centerX);
                make.size.mas_equalTo(CGSizeMake(55, 55));
                make.top.mas_equalTo(60 + 20);
            }];
            scanBtn.block = ^(UIButton *btn) {
                
//#warning 观察钱包转账, 地址授权 ，合约签名 三个事件
//
//                WalletScanQRCodeVC *qrcodeVC = [[WalletScanQRCodeVC alloc]init];
//                qrcodeVC.block = ^(NSString *scanStr)
//                {
//                    [self analyseSignture:scanStr];
//                };
//                [[FFBMSTools getCurrentVC] presentViewController:qrcodeVC animated:YES completion:nil];
//
//                if(self.enter_path.length > 0){
//                    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
//                    [paramDict setValueIfNotNil:self.enter_path forKey:@"enter_path"];
//                    [paramDict setValueIfNotNil:@(_businessType) forKey:@"business_type"];
//                    [paramDict setValueIfNotNil:@"" forKey:@"error_message"];
//
//                    [[SensorsAnalyticsSDK sharedInstance] track:@"ScanQRCode"
//                                                 withProperties:paramDict];
//                }
            };
            UILabel *subTitle = [[UILabel alloc]init];
            
            subTitle.textColor = HEX_RGB(0x898CD3);
            subTitle.textAlignment = NSTextAlignmentCenter;
            subTitle.font = titleFont;
            
            // 当前为观察钱包
            NSString *str = NSLocalizedString(@"observer_transfer_dialog_des1_1", nil);
            NSMutableAttributedString *ats = [[NSMutableAttributedString alloc] initWithString:str];
            
            NSRange range1 = [str rangeOfString: @"ffffe901"];
            [ats addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#FFAE03"],
                                 NSFontAttributeName : [UIFont fontWithName:@"icomoon" size:Scale(12.0)]}
                         range:range1];
            NSRange range2 = [str rangeOfString: NSLocalizedString(@"f9_HOT_wallet", nil)];
            [ats addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#FFAE03"],
                                 NSFontAttributeName : [UIFont systemFontOfSize:Scale(12.0)]}
                         range:range2];
            subTitle.attributedText = ats;
            
            [_contentView addSubview:subTitle];
            [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_contentView.centerX);
                make.top.mas_equalTo(scanBtn.mas_bottom).offset(23);
                make.height.mas_equalTo(16);
            }];
            
            // 扫描冷钱包签名数据二维码
            UILabel *subTitle1 = [[UILabel alloc]init];
            subTitle1.text = NSLocalizedString(@"observer_transfer_dialog2_des2", nil);
            subTitle1.textColor = HEX_RGB(0x898CD3);
            subTitle1.textAlignment = NSTextAlignmentCenter;
            subTitle1.font = titleFont;
            [_contentView addSubview:subTitle1];
            [subTitle1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_contentView.centerX);
                make.top.mas_equalTo(subTitle.mas_bottom).offset(5);
                make.left.mas_equalTo(Scale(20));
                make.rightMargin.mas_equalTo(-Scale(20));
            }];
            
            _textView = [[UILabel alloc]init];
            _textView.textAlignment = NSTextAlignmentCenter;
            _textView.numberOfLines = 0;
            _textView.textColor = HEX_RGB(0xBDBDBD);
            [_contentView addSubview:_textView];
            _textView.backgroundColor = HEX_RGB(0xfdfdfd);
            [_textView setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
            [_textView.layer setBorderColor:HEX_RGB(0xf6f6f6).CGColor];
            [_textView.layer setBorderWidth:1];
            _textView.userInteractionEnabled = NO;
            // 待扫码导入签名数据
            _textView.text = NSLocalizedString(@"observer_transfer_dialog2_sign_hint", nil);
            [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(Scale(20));
                make.right.mas_equalTo(-Scale(20));
                make.top.mas_equalTo(subTitle1.mas_bottom).offset(25);
                make.height.mas_equalTo(90);
            }];
        }
        break;
            
    case ColdShowQrCodeType:
        {
            // 签名成功
            _titleLabel.text = NSLocalizedString(@"transaction_cold_sign_success", nil);
            [_confirmBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
            [_confirmBtn setGrayGradientLayerType:cyanType];
            
            UIImage *qrCodeImage = [FFBMSTools creatQRcodeImage:_jsonStr];
            UIImageView *qrImageView = [[UIImageView alloc]init];
            [qrImageView setImage:qrCodeImage];
            [_contentView addSubview:qrImageView];
            [qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_contentView.centerX);
                make.size.mas_equalTo(CGSizeMake(215, 215));
                make.top.mas_equalTo(60);
            }];
            
            
            // 当前为冷钱包
            UILabel *subTitle = [[UILabel alloc]init];
            
            subTitle.textColor = HEX_RGB(0x898CD3);
            subTitle.textAlignment = NSTextAlignmentCenter;
            subTitle.font = titleFont;
            
            NSString *str = NSLocalizedString(@"transaction_cold_dialog_des1_1", nil);
            NSMutableAttributedString *ats = [[NSMutableAttributedString alloc] initWithString:str];
            
            NSRange range1 = [str rangeOfString: @"ffffe902"];
            [ats addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#6DD8EF"],
                                 NSFontAttributeName : [UIFont fontWithName:@"icomoon" size:Scale(12.0)]}
                         range:range1];
            NSRange range2 = [str rangeOfString: NSLocalizedString(@"f9_COLD_wallet", nil)];
            [ats addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#6DD8EF"],
                                 NSFontAttributeName : [UIFont systemFontOfSize:Scale(12.0)]}
                         range:range2];
            subTitle.attributedText = ats;
            [_contentView addSubview:subTitle];
            [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_contentView.centerX);
                make.top.mas_equalTo(qrImageView.mas_bottom).offset(15);
                make.height.mas_equalTo(16);
            }];
            
            // 请用对应的观察钱包扫码二维码发出交易
            UILabel *subTitle1 = [[UILabel alloc]init];
            subTitle1.text = NSLocalizedString(@"transaction_cold_dialog_des2_1", nil);
            subTitle1.textColor = HEX_RGB(0x898CD3);
            subTitle1.textAlignment = NSTextAlignmentCenter;
            subTitle1.font = titleFont;
            subTitle1.numberOfLines = 0;
            subTitle1.adjustsFontSizeToFitWidth = YES;
            [_contentView addSubview:subTitle1];
            [subTitle1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_contentView.centerX);
                make.top.mas_equalTo(subTitle.mas_bottom).offset(5);
                make.left.mas_equalTo(Scale(20));
                make.rightMargin.mas_equalTo(-Scale(20));
            }];
        }
        break;
        
    default:
        break;
    }
}

- (void)analyseSignture:(NSString *)scanStr
{
    switch (_codeType) {
        case QRCodeVetType: //交易部分
        {
//            if ([scanStr hasPrefix:signTransction]) {
//                _textView.text = [scanStr stringByReplacingOccurrencesOfString:signTransction withString:@""];
//                [_confirmBtn setGrayGradientLayerType:highYellowType];
//                _confirmBtn.userInteractionEnabled = YES;
//                _textView.textColor = HEX_RGB(0x202C56);
//            }else if ([scanStr hasPrefix:signObserver]){
//                _textView.text = [scanStr stringByReplacingOccurrencesOfString:signObserver withString:@""];
//                [_confirmBtn setGrayGradientLayerType:highYellowType];
//                _confirmBtn.userInteractionEnabled = YES;
//                _textView.textColor = HEX_RGB(0x202C56);
//            }
//            else{
//                [FFBMSMBProgressShower showTextIn:self
//                                             Text:NSLocalizedString(@"transaction_signature_scheme_error",nil)
//                                           During:1.5];
//            }
        }
            break;
        case QRCodeObserverAuthType: //授权部分
        {
//            if ([scanStr hasPrefix:signAuthorized]) {
//                _textView.text = [scanStr stringByReplacingOccurrencesOfString:signAuthorized withString:@""];
//                [_confirmBtn setGrayGradientLayerType:highYellowType];
//                _confirmBtn.userInteractionEnabled = YES;
//                _textView.textColor = HEX_RGB(0x202C56);
//            }else{
//                [FFBMSMBProgressShower showTextIn:self
//                                             Text:NSLocalizedString(@"authorized_signature_scheme_error",nil)
//                                           During:1.5];
//            }
        }
            break;
            
        default:
            break;
    }
   
}

- (void) dealloc {
    NSLog(@"被移除");
}

@end
