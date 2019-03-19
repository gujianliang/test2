//
//  TransferVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/27.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WalletTransferVC.h"
#import <WalletSDK/WalletUtils.h>
#import "WalletSdkMacro.h"

@interface WalletTransferVC ()<UITextFieldDelegate>
{
    NSString *_toAddress;
    NSString *_tokenContractAddress;
    NSString *_blockHost;
}

@property (weak, nonatomic) IBOutlet UITextView *receiveAddressTextView;
@property (weak, nonatomic) IBOutlet UITextField *transferAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *balanceAmountLabel;


@property (weak, nonatomic) IBOutlet UILabel *symobl;
@property (weak, nonatomic) IBOutlet UIImageView *coinIcon;
@property (nonatomic, strong) UITextField *pwTextField;

@end

@implementation WalletTransferVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.transferAmountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    _blockHost = [WalletUtils getNode];
    
    if (!_isVET) {
        // vtho contract address
        _tokenContractAddress = vthoTokenAddress;
        [self.coinIcon setImage:[UIImage imageNamed:@"VTHO"]];
        self.symobl.text = @"VTHO";
        
    }else{
        [self.coinIcon setImage:[UIImage imageNamed:@"VET"]];
        self.symobl.text = @"VET";
    }        

    self.receiveAddressTextView.textContainerInset = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    
    self.balanceAmountLabel.text = self.coinAmount;
//    self.receiveAddressTextView.text = @"0x1231231231231231231231231231231231231231";
}


- (IBAction)transfer:(id)sender{
    [self.view endEditing:YES];

    NSDictionary *currentWalletDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    NSString *from = currentWalletDict[@"address"];
    
    NSMutableArray *walletList = [NSMutableArray array];
    if (currentWalletDict) {
        [walletList addObject:currentWalletDict];
    }
    
    NSString *keystore = currentWalletDict[@"keystore"];
    if (_isVET) {
        [self vetTransfer:from keystore:keystore];
    }else{
        [self tokenTransfer:from keystore:keystore];
    }
    
    //sign contract demo
//    [self contractSignture:from keystore:keystore];
}

- (void)vetTransfer:(NSString *)from keystore:(NSString *)keystore{
    if (self.receiveAddressTextView.text.length == 0
        || self.transferAmountTextField.text.length == 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text =  NSLocalizedString(@"input_empty", nil);
        [hud hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    BigNumber *amountBig = [WalletUtils parseToken:self.transferAmountTextField.text dicimals:18];

    //vet
    TransactionParameter *paramters = [[TransactionParameter alloc]init];
    paramters.to = self.receiveAddressTextView.text;
    paramters.value = amountBig.hexString; //Vet transfer amount, hex string or decimal string,
    paramters.data = @""; //vet transfer data value is an empty string

    paramters.from = from; //signature address（Hex string）
    paramters.gas = @"21000";  //Set maximum gas allowed for call,

    [WalletUtils sendWithKeystore:keystore
                        parameter:paramters
                         callback:^(NSString *txId, NSString *signer, NSInteger status){
                             NSLog(@"\n txId: %@ \n signer: %@ \n status: %ld", txId, signer, (long)status);
    }];
}

- (void)tokenTransfer:(NSString *)from keystore:(NSString *)keystore{
    if (self.receiveAddressTextView.text.length == 0
        || self.transferAmountTextField.text.length == 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text =  NSLocalizedString(@"input_empty", nil);
        [hud hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    BigNumber *amountBig = [WalletUtils parseToken:self.transferAmountTextField.text dicimals:18];
    
    TransactionParameter *paramters = [[TransactionParameter alloc]init];
    paramters.to = _tokenContractAddress; //contract address
    paramters.value = @""; //token transfer value is an empty string
    
    paramters.data = [self calculatenTokenTransferClauseData:self.receiveAddressTextView.text value:amountBig.hexString];
    
    paramters.from = from; //signature address（Hex string）
    paramters.gas = @"60000"; //Set maximum gas allowed for call,
    
    [WalletUtils sendWithKeystore:keystore
                        parameter:paramters
                         callback:^(NSString *txId, NSString *signer,NSInteger status){
                             NSLog(@"\n txId: %@ \n signer: %@ \n status: %ld", txId, signer, (long)status);
     }];

}

/**
* address: Accept the address of the account
* value: Token transfer amount
*/
- (NSString *)calculatenTokenTransferClauseData:(NSString *)address
                                     value:(NSString *)value{
    NSString *head = @"0xa9059cbb"; // method id
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

- (void)contractSignture:(NSString *)from keystore:(NSString *)keystore{
    //xnode pending order contract
    TransactionParameter *paramters = [[TransactionParameter alloc]init];
    paramters.to = @"0xd4dac3a95c741773f093d59256a21ed6fcc768a7"; //contract address
    paramters.value = @""; //Number of VET consumed
    paramters.data = @"0xbae3e19e00000000000000000000000000000000000000000000000000000000000000680000000000000000000000000000000000000000000000000de0b6b3a76400000000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000000000000000000000000000000000000003f480";
    
    {
// Method of splicing data
//        NSMutableArray *clauseParamList = [NSMutableArray array];
//        [clauseParamList addObject:@"0x68"];
//        [clauseParamList addObject:@"0x0DE0B6B3A7640000"];
//        [clauseParamList addObject:@"0x3840"];
//        [clauseParamList addObject:@"0x1231231231231231231231231231231231231231"];
//        paramters.data = [self contractMethodId:@"0x2ed9b4fd" params:clauseParamList];
    }
    
    paramters.from = from;     //signature address（Hex string）
    paramters.gas = @"600000"; //Set maximum gas allowed for call,
    
    [WalletUtils sendWithKeystore:keystore
                        parameter:paramters
                                callback:^(NSString *txId, NSString *signer, NSInteger status){
                                    NSLog(@"\n txId: %@ \n signer: %@  \n  status: %ld", txId, signer, (long)status);
     }];
}

/**
* splice clause data
*/
- (NSString *)contractMethodId:(NSString *)methodId params:(NSArray *)params{
    NSString *clauseData = methodId;
    for (NSString *param in params) {
        NSInteger t = 64 - [param substringFromIndex:2].length;
        NSMutableString *zero = [NSMutableString new];
        for (int i = 0; i < t; i++) {
            [zero appendString:@"0"];
        }
        NSString *newValue = [NSString stringWithFormat:@"%@%@",zero,[param substringFromIndex:2]];
        
        clauseData = [clauseData stringByAppendingString:newValue];
    }
    return clauseData;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


/**
*  Just hidden the keyboard.
*/
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [WalletUtils deallocDappSingletion];
}

/**
*  Just hidden the keyboard.
*/
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

@end
