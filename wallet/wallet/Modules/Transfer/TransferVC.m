//
//  TransferVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/27.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "TransferVC.h"
#import <walletSDK/WalletUtils.h>
//#import "AFNetworking.h"
//#import "MBProgressHUD.h"
#import <walletSDK/Payment.h>
#import <walletSDK/MBProgressHUD.h>
#import <walletSDK/AFHTTPSessionManager.h>

@interface TransferVC ()<UITextFieldDelegate>
{
    NSString *_toAddress;
    NSString *_tokenContractAddress;
    NSString *_blockHost;
    
    MBProgressHUD *_hud;
}

@property (weak, nonatomic) IBOutlet UITextView *receiveAddressTextView;
@property (weak, nonatomic) IBOutlet UITextField *transferAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *balanceAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UISlider *feeSwitcher;

@property (weak, nonatomic) IBOutlet UILabel *coinName;
@property (weak, nonatomic) IBOutlet UIImageView *coinIcon;
@property (weak, nonatomic) IBOutlet UISlider *minerFeeSlider;
@property (nonatomic, strong)UITextField *pwTextField;
@end

@implementation TransferVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _blockHost = @"https://vethor-node-test.vechaindev.com";
    //_blockHost = @"https://vethor-node.vechain.com" //product
    
    if (!_isVET) {
        _tokenContractAddress = @"0x0000000000000000000000000000456e65726779";
        [self.coinIcon setImage:[UIImage imageNamed:@"VTHO"]];
        self.coinName.text = @"VTHO";
    }else{
        [self.coinIcon setImage:[UIImage imageNamed:@"VET"]];
        self.coinName.text = @"VET";
    }
    
    self.receiveAddressTextView.text = @"0xe2c3B55d8Aa9920058030F73baCECe582f2123FF";
    
    BigNumber *bigNumberCount = [BigNumber bigNumberWithHexString:self.amount];
    
    NSString *coinAmount = @"0.00";
    if (!bigNumberCount.isZero) {
        coinAmount = [Payment formatToken:bigNumberCount
                                 decimals:18
                                  options:2];
    }
    self.balanceAmountLabel.text = coinAmount;
    
    self.minerFeeSlider.minimumValue = 0.0;
    self.minerFeeSlider.maximumValue = 255.0;
    self.minerFeeSlider.value = 120.0;
    [self calcThorNeeded:120];
}

- (IBAction)transfer:(id)sender
{
    if (self.receiveAddressTextView.text.length == 0 || self.transferAmountTextField.text.length == 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                                  animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"Invalid";
        [hud hide:YES afterDelay:1];
        return;
    }
    
    //创建操作
    UIAlertAction *okAlert = [UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action)
    {
        //具体操作内容
        NSLog(@"ddd== %@",self.pwTextField.text);
        [self doTransfer];
    }];
    //初始化
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please input your password"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    //添加操作
    [alert addAction:okAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        self.pwTextField = textField;
    }];
   
    //以model形式，显示警告视图
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)doTransfer
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view
                                              animated:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText =  @"waiting ...";
    
    Transaction *transaction = [[Transaction alloc] init];
    
    // 生成随机 nonce
    SecureData* randomData = [SecureData secureDataWithLength:8];
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) { // fail
        [_hud hide:YES];
        return;
    }
    transaction.nonce = [[[BigNumber bigNumberWithData:randomData.data] mod:[BigNumber bigNumberWithInteger:NSIntegerMax]] integerValue];
    
    transaction.Expiration = 720;
    if (_isVET) {
        transaction.gasPrice = [BigNumber bigNumberWithInteger:120];
        transaction.gasLimit = [BigNumber bigNumberWithDecimalString:@"21000"];
    }else{
        transaction.gasPrice = [BigNumber bigNumberWithInteger:120];
        transaction.gasLimit = [BigNumber bigNumberWithDecimalString:@"60000"];
    }
    
    NSString *urlString = [_blockHost stringByAppendingString:@"/blocks/0"];
    AFHTTPSessionManager *httpManagerGenesisBlock = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [httpManagerGenesisBlock GET:urlString
                      parameters:nil
                        progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSString *blockID = result[@"id"];
        NSString *chainTag = [NSString stringWithFormat:@"0x%@", [blockID substringFromIndex:blockID.length-2]];
        transaction.ChainTag = [BigNumber bigNumberWithHexString:chainTag];
        
        [self getBestBlockInfo:transaction];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)getBestBlockInfo:(Transaction *)transaction
{
    NSString *urlString = [_blockHost stringByAppendingString:@"/blocks/best"];
    AFHTTPSessionManager *httpManagerGenesisBlock = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [httpManagerGenesisBlock GET:urlString
                      parameters:nil
                        progress:^(NSProgress * _Nonnull uploadProgress) {
                        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSString *blockRef = [[result[@"id"] substringFromIndex:2] substringToIndex:16];
        transaction.BlockRef = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"0x%@",blockRef]];
        [self decryptKeystore:transaction];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
        [_hud hide:YES];

    }];
}

- (void)packClausesInfo:(Transaction *)transaction
{
    BigNumber *subValue;
    if (_isVET) {
        //ven 转账  data 设置空
        subValue = [Payment parseEther:_transferAmountTextField.text];
        if ([_transferAmountTextField.text floatValue] == 0.0
            && [subValue lessThanEqualTo:[BigNumber constantZero]]) {
            NSData *toData = [SecureData hexStringToData:self.receiveAddressTextView.text];
            transaction.Clauses = @[@[toData,[NSData data],[NSData data]]];
        } else {
            NSData *toData = [SecureData hexStringToData:self.receiveAddressTextView.text];
            transaction.Clauses = @[@[toData,subValue.data,[NSData data]]];
        }
    } else {
        //token 转账 value 设置0，data 设置见文档
        subValue = [Payment parseToken:_transferAmountTextField.text dicimals:18];
        NSString *data = [self signData:self.receiveAddressTextView.text value:subValue.hexString];
        SecureData *tokenAddress = [SecureData secureDataWithHexString:_tokenContractAddress];
        NSData *clauseData = [SecureData hexStringToData:data];
        transaction.Clauses = @[@[tokenAddress.data,[NSData data],clauseData]];
    }
}

- (void)decryptKeystore:(Transaction *)transaction
{
    NSDictionary *currentWalletDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    NSString *keystore = currentWalletDict[@"keystore"];
    [Account decryptSecretStorageJSON:keystore
                             password:self.pwTextField.text
                             callback:^(Account *account, NSError *NSError)
    {
        if (account == nil) {
            [_hud hide:YES];
            NSLog(@"pw error");
            return ;
        }
        [self packClausesInfo:transaction];
        [account sign:transaction];
        
        NSString *raw = [SecureData dataToHexString: [transaction serialize]];
        [self sendRaw:raw];
    }];
}

- (void)sendRaw:(NSString *)raw
{
    if (raw.length == 0) {
        return;
    }
    NSString *urlString = [_blockHost stringByAppendingString:@"/transactions"];
    AFHTTPSessionManager *httpManagerGenesisBlock = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpManagerGenesisBlock.requestSerializer = [AFJSONRequestSerializer serializer];
    [httpManagerGenesisBlock POST:urlString
                       parameters:@{@"raw":raw}
                        progress:^(NSProgress * _Nonnull uploadProgress) {
                        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        [_hud hide:YES];

        NSDictionary *result = (NSDictionary *)responseObject;
        NSString *txid = result[@"id"];
        NSLog(@"txid == %@",txid);
         
         UIAlertAction *okAlert = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:txid
                                                                        message:@""
                                                                 preferredStyle:UIAlertControllerStyleAlert];
         [alert addAction:okAlert];
         [self presentViewController:alert animated:YES completion:nil];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         
         [_hud hide:YES];

     }];
}

//转账 thor data 的值
- (NSString *)signData:(NSString *)address
                 value:(NSString *)value
{
    NSString *head = @"0xa9059cbb";
    NSString *newAddrss = [NSString stringWithFormat:@"000000000000000000000000%@",[address substringFromIndex:2]];
    NSInteger t = 64 - [value substringFromIndex:2].length;
    NSMutableString *zero = [NSMutableString new];
    for (int i = 0; i < t; i++) {
        [zero appendString:@"0"];
    }
    NSString *newValue = [NSString stringWithFormat:@"%@%@",zero,[value substringFromIndex:2]];
    NSString *result = [NSString stringWithFormat:@"%@%@%@",head,newAddrss,newValue];
    return  result;
}

- (void)calcThorNeeded:(float)gasPriceCoef {
    BigNumber *gas = [BigNumber bigNumberWithDecimalString:@"21000"];
    NSString *transferGas = nil;
    if (_isVET) {
        transferGas = @"21000";
    }else{
        transferGas = @"60000";
    }
    gas = [BigNumber bigNumberWithDecimalString:transferGas];
    BigNumber *gasCanUse = [[[[BigNumber bigNumberWithDecimalString:@"1000000000000000"] mul:[BigNumber bigNumberWithInteger:(1+gasPriceCoef/255.0)*1000000]] mul:gas] div:[BigNumber bigNumberWithDecimalString:@"1000000"]];
    self.feeLabel.text = [[Payment formatEther:gasCanUse options:2] stringByAppendingString:@" VTHO"];
}

- (IBAction)changeSlider:(UISlider *)sender
{
    [self calcThorNeeded:sender.value];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
