//
//  WalletObserverSignPreviewVC.m
//  VeWallet
//
//  Created by 曾新 on 2018/10/25.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletObserverSignPreviewVC.h"
#import "WalletUtils.h"
//#import "WalletSqlDataEngine.h"
//#import "WalletAuthInputPWView.h"
#import "WalletPaymentQRCodeView.h"
#import "WalletSignObserverModel.h"

#define   DataKey     @"dataKey"
#define   DataValue   @"dataValue"

static NSString *cellIndef = @"addressIndef";

@interface WalletObserverSignPreviewVC ()<UITableViewDelegate, UITableViewDataSource>
{
    CGFloat _bgHeight;
}

@property (strong, nonatomic) WalletSignObserverModel *transactionModel;

@end

@implementation WalletObserverSignPreviewVC

- (WalletSignObserverModel *)transactionModel{
    if (!_transactionModel) {
        _transactionModel = [[WalletSignObserverModel alloc] init];
    }
    return _transactionModel;
}

- (instancetype)initWithData:(WalletSignObserverModel *)model{  // 二维码扫描数据
    self = [super init];
    if (self) {
        
        self.transactionModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = NSLocalizedString(@"contract_payment_info_title", nil);
//    [self updateNavigationBarStyle:TintAndTitleNoneCloseWhiteOne];
    
    [self initView];
}

- (UIView *)creatCell:(NSString *)title value:(NSString *)value Y:(CGFloat)Y
{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH, 40)];
    contentView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:contentView];
    
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
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-Scale(20.0));
        make.left.mas_equalTo(leftLabel.mas_right).offset(Scale(20.0));
    }];
    
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

- (void)initView
{    
    UILabel *amountLabel = [[UILabel alloc]init];
    amountLabel.font = MediumFont(36);
    amountLabel.textAlignment = NSTextAlignmentCenter;
    NSString *amount = [NSString stringWithFormat:@"%@ VET",self.transactionModel.amount.length == 0?@"0.00":self.transactionModel.amount];
    if ([self.transactionModel.amount isEqualToString:@"0"]) {
        amount = @"0.00 VET";
    }
    amountLabel.text = amount;
    [self.view addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(20 + kNavigationBarHeight);
        make.height.mas_equalTo(40);
    }];
    
    NSString *vthoValue = self.transactionModel.gas.length == 0 ? @"0.00": [FFBMSTools thousandSeparator:self.transactionModel.cost decimals:YES];
    NSString *gas = [NSString stringWithFormat:@"%@ VTHO",vthoValue];
    
    if ([self.transactionModel.cost isEqualToString:@"0"]) {
        gas = @"0.00 VTHO";
    }
    
    [self creatCell:NSLocalizedString(@"contract_ayment_info_row1_title", nil)
              value:gas
                  Y:80 + kNavigationBarHeight];
    
    [self creatCell:NSLocalizedString(@"contract_payment_info_row2_title", nil)
              value:[FFBMSTools checksumAddress:self.transactionModel.from]
                  Y:80 + 50 + kNavigationBarHeight];
    
    [self creatCell:NSLocalizedString(@"contract_payment_info_row3_title", nil)
              value:[FFBMSTools checksumAddress:self.transactionModel.to]
                  Y:80 + 50 * 2 + kNavigationBarHeight];
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.titleLabel.font = [UIFont systemFontOfSize:Scale(15.0)];
    signBtn.layer.cornerRadius = 4.0;
    signBtn.clipsToBounds = YES;
    signBtn.backgroundColor = [UIColor colorWithHexString:@"#6DD8EF"];
    [signBtn setTitle:NSLocalizedString(@"contract_payment_info_title", nil) forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(clickSign) forControlEvents:UIControlEventTouchUpInside];
    CGFloat signBtnY = SCREEN_HEIGHT - Scale(44.0) - Scale(20);
    signBtn.frame = CGRectMake(Scale(20), signBtnY, SCREEN_WIDTH - Scale(40.0), Scale(44.0));
    [self.view addSubview:signBtn];
}

- (BOOL) checkAddressAvailable {
    
    return YES;
}

- (void)clickSign
{
//    NSString *from = self.transactionModel.from;
//    WalletManageModel *walletModel = [[WalletSqlDataEngine sharedInstance] getSingleWallet:[FFBMSTools checksumAddress:from]];
//    if (walletModel.address.length > 0) {
//        if (walletModel.observer.intValue) {
//            [FFBMSAlertShower showAlert:NSLocalizedString(@"dialog_tip_title", nil)
//                                    msg:NSLocalizedString(@"transaction_cold_wallet_observer", nil)
//                                  inCtl:self
//                                  items:@[NSLocalizedString(@"improt_wallet_warning_dialog_butn", nil)]
//                             clickBlock:^(NSInteger index) {
//                                 [FFBMSTools restoreTabNavToRoot];
//                             }];
//            return;
//        }
//
//    }else {
//        [FFBMSAlertShower showAlert:NSLocalizedString(@"dialog_tip_title", nil)
//                                msg:NSLocalizedString(@"transaction_cold_wallet_not_exist", nil)
//                              inCtl:self
//                              items:@[NSLocalizedString(@"improt_wallet_warning_dialog_butn", nil)]
//                         clickBlock:^(NSInteger index) {
//                             [FFBMSTools restoreTabNavToRoot];
//                         }];
//        return;
//    }
//
//    WalletAuthInputPWView *inputV = [self.navigationController.view viewWithTag:9090];
//    if (inputV) {
//        return;
//    }
//
//    //输入keystore 密码签名
//    NSString *address = [FFBMSTools checksumAddress:self.transactionModel.from];
//    WalletAuthInputPWView *inputView = [[WalletAuthInputPWView alloc]initWithAddress:address
//                                                                         authObserve: ColdWalletType
//                                                                               block:^(BOOL result,Account *account)
//                                        {
//                                            if (result) {
//                                                // 执行生成授权页面
//
//                                                NSString *result = [self signMessage:account];
//
//                                                WalletPaymentQRCodeView *QRCodeView = [[WalletPaymentQRCodeView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)
//                                                                                                                               type:ColdShowQrCodeType
//
//                                                                                                                               json:result
//                                                                                                                           codeType:QRCodeUnKnowType];
//                                                QRCodeView.backgroundColor = UIColor.clearColor;
//                                                [self.navigationController.view addSubview:QRCodeView];
//                                                [UIView animateWithDuration:0.3 animations:^{
//                                                    [QRCodeView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//                                                }];
//                                                QRCodeView.block = ^(NSString *result)
//                                                {
//                                                    //回到首页
//                                                    [FFBMSTools restoreTabNavToRoot];
//                                                };
//                                            }
//                                        }];
//    [inputView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    inputView.tag = 9090;
//    [self.navigationController.view addSubview:inputView];
//
//    [UIView animateWithDuration:0.3 animations:^{
//        [inputView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    } completion:^(BOOL finished) {
//
//    }];
}

- (NSString *)signMessage:(Account *)account
{
    NSString *contractAddressUrl = @"";
    Transaction *transaction = [[Transaction alloc] init];
    
    transaction.nonce       =   [[BigNumber bigNumberWithHexString:self.transactionModel.nonce] integerValue];;
    transaction.Expiration  = 720;
    transaction.gasPrice   =  [BigNumber bigNumberWithDecimalString:self.transactionModel.gasPriceCoef];
    transaction.gasLimit   =  [BigNumber bigNumberWithDecimalString:self.transactionModel.gas];
    transaction.ChainTag   = [BigNumber bigNumberWithHexString:self.transactionModel.chainTag];
    transaction.BlockRef   =  [BigNumber bigNumberWithHexString:self.transactionModel.blockRef];
    
    ContractType contractType = [FFBMSTools methodIDConvertContractType:self.transactionModel.methodId];
    NSDictionary *dictContractData = [FFBMSTools getContractData:contractType
                                                          params:self.transactionModel.contractParams];
    NSString *contractClauseData = dictContractData[@"contractClauseData"];
    
    if (dictContractData == nil) {
        contractClauseData = self.transactionModel.methodId;
        
        for (NSString *param in self.transactionModel.contractParams) {
            contractClauseData = [contractClauseData stringByAppendingString:param];
        }
    }
    
    BigNumber *subValue = nil;
    
    if (contractType == Contract_buyNode || contractType == Contract_acceptNode) {
        
        if ([self.transactionModel.amount isEqualToString:@"0"]) {
            transaction.Clauses = @[@[[SecureData hexStringToData:contractAddressUrl],[NSData data], [SecureData hexStringToData:contractClauseData]]];
        }else{
            subValue = [Payment parseEther:self.transactionModel.amount];
            transaction.Clauses = @[@[[SecureData hexStringToData:contractAddressUrl],subValue.data, [SecureData hexStringToData:contractClauseData]]];
        }
    }else{
        transaction.Clauses = @[@[[SecureData hexStringToData:contractAddressUrl],[NSData data], [SecureData hexStringToData:contractClauseData]]];
    }
    
    [account sign:transaction];
    
    Signature *signature = transaction.signature;
    
    SecureData *vData = [[SecureData alloc]init];
    [vData appendByte:signature.v];
    
    NSString *s = [SecureData dataToHexString:signature.s];
    NSString *r = [SecureData dataToHexString:signature.r];
    
    NSString *hashStr = [NSString stringWithFormat:@"%@%@%@",
                         [r substringFromIndex:2],
                         [s substringFromIndex:2],
                         [vData.hexString substringFromIndex:2]];
    return [@"" stringByAppendingString:hashStr];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndef];
    if (!cell) {
        NSArray *dataArr = nil;
        
        NSString *amount = nil;
        if (self.transactionModel.amount.length == 0) {
            amount = [NSString stringWithFormat:@"0.00 %@", self.transactionModel.symbol];
        }else {
            amount = [NSString stringWithFormat:@"%@ %@", self.transactionModel.amount, self.transactionModel.symbol];
        }
        
        NSString *to = [FFBMSTools checksumAddress:self.transactionModel.to];
        to = to.length > 0 ? to : @" ";
        dataArr = @[
                    @{DataKey : NSLocalizedString(@"cold_transfer_to_address", nil), DataValue :to},
                    @{DataKey : NSLocalizedString(@"cold_transfer_amount", nil), DataValue : amount}
                    ];
        
        return [self loadCellWithData:dataArr];
        
        
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _bgHeight;
}
- (UITableViewCell *)loadCellWithData:(NSArray *)dataArr {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:cellIndef];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(Scale(20), 0, SCREEN_WIDTH - Scale(40.0), 0)];
    bgV.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for(int i = 0; i < dataArr.count; i ++ ){
        
        NSDictionary *dic = dataArr[i];
        
        // 左边标签
        UILabel *cellleftLab = [[UILabel alloc] init];
        cellleftLab.tag = 1000 + i;
        cellleftLab.text = dic[DataKey];
        cellleftLab.textColor = [UIColor colorWithHexString:@"#7D7D7D"];
        cellleftLab.font = [UIFont systemFontOfSize:Scale(12.0)];
        [bgV addSubview:cellleftLab];
        [cellleftLab sizeToFit];
        
        // 临时记录左边宽度
        [tempArr addObject:@(cellleftLab.bounds.size.width)];
        
        // 右边标签
        UILabel *cellrightLab = [[UILabel alloc] init];
        cellrightLab.tag = 2000 + i;
        cellrightLab.text = dic[DataValue];
        cellrightLab.textColor = [UIColor colorWithHexString:@"#7D7D7D"];
        cellrightLab.font = [UIFont systemFontOfSize:Scale(12.0)];
        cellrightLab.numberOfLines = 0;
        cellrightLab.lineBreakMode = NSLineBreakByCharWrapping;
        [bgV addSubview:cellrightLab];
    }
    
    [cell addSubview:bgV];
    
    // 获取宽度最大值
    CGFloat maxW = [[tempArr valueForKeyPath:@"@max.floatValue"] floatValue];
    
    
    // 左标签
    UILabel *leftLab1 = [cell viewWithTag:1000];
    leftLab1.frame = CGRectMake(Scale(15), Scale(22.0), maxW, leftLab1.bounds.size.height);
    
    /* 右标签  */
    UILabel *rightLab1 = [cell viewWithTag:2000];
    CGFloat cellrightLabX = CGRectGetMaxX(leftLab1.frame) + Scale(15.0);
    CGFloat cellrightLabW = SCREEN_WIDTH - cellrightLabX - Scale(50.0);
    rightLab1.frame = CGRectMake(0, 0, cellrightLabW, 0);
    [rightLab1 sizeToFit];
    CGFloat rightLab1H = (rightLab1.bounds.size.height == 0) ? leftLab1.bounds.size.height : rightLab1.bounds.size.height;
    rightLab1.frame = CGRectMake(cellrightLabX, leftLab1.frame.origin.y, cellrightLabW, rightLab1H);
    
    
    // 左标签
    UILabel *leftLab2 = [cell viewWithTag:1001];
    leftLab2.frame = CGRectMake(leftLab1.frame.origin.x, CGRectGetMaxY(rightLab1.frame) + Scale(15.0), maxW, leftLab2.bounds.size.height);
    
    /* 右标签  */
    UILabel *rightLab2 = [cell viewWithTag:2001];
    rightLab2.frame = CGRectMake(0, 0, cellrightLabW, 0);
    [rightLab2 sizeToFit];
    CGFloat rightLab2H = (rightLab2.bounds.size.height == 0) ? leftLab2.bounds.size.height : rightLab2.bounds.size.height;
    rightLab2.frame = CGRectMake(cellrightLabX, leftLab2.frame.origin.y, cellrightLabW, rightLab2H);
    
    
    
    // 左标签
    UILabel *leftLab3 = [cell viewWithTag:1002];
    if (leftLab3) {
        leftLab3.frame = CGRectMake(leftLab1.frame.origin.x, CGRectGetMaxY(rightLab2.frame) + Scale(15.0), maxW, leftLab3.bounds.size.height);
        
        /* 右标签  */
        UILabel *rightLab3 = [cell viewWithTag:2002];
        rightLab3.frame = CGRectMake(0, 0, cellrightLabW, 0);
        [rightLab3 sizeToFit];
        CGFloat rightLab3H = (rightLab3.bounds.size.height == 0) ? leftLab3.bounds.size.height : rightLab3.bounds.size.height;
        rightLab3.frame = CGRectMake(cellrightLabX, leftLab3.frame.origin.y, cellrightLabW, rightLab3H);
        
        _bgHeight = CGRectGetMaxY(rightLab3.frame) + Scale(20);
        
    }else {
        _bgHeight = CGRectGetMaxY(rightLab2.frame) + Scale(20);
    }
    
    bgV.frame = CGRectMake(Scale(20), 0, SCREEN_WIDTH - Scale(40.0), _bgHeight);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end

