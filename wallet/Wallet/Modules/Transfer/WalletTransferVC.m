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
@property (nonatomic, strong)UITextField *pwTextField;

@end

@implementation WalletTransferVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _blockHost = [WalletUtils getNode];
    
    if (!_isVET) {
        // vtho contract address
        _tokenContractAddress = @"0x0000000000000000000000000000456e65726779";
        [self.coinIcon setImage:[UIImage imageNamed:@"VTHO"]];
        self.symobl.text = @"VTHO";
        
    }else{
        [self.coinIcon setImage:[UIImage imageNamed:@"VET"]];
        self.symobl.text = @"VET";
    }
    

    self.receiveAddressTextView.text = @"0x1231231231231231231231231231231231231231";

    self.receiveAddressTextView.textContainerInset = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    
    self.balanceAmountLabel.text = self.coinAmount;
}

- (IBAction)transfer:(id)sender{
    [self.view endEditing:YES];

    NSDictionary *currentWalletDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentWallet"];
    NSString *from = currentWalletDict[@"address"];
    
    // 设置 钱包
    NSMutableArray *walletList = [NSMutableArray array];
    if (currentWalletDict) {
        [walletList addObject:currentWalletDict];
    }
    
    NSString *keystore = currentWalletDict[@"keystore"];
    if (_isVET) {
        [self vetTransfer:from keystore:keystore];
    }else{
        [self vthoTransfer:from keystore:keystore];
    }
    
//    [self contractSignture:from keystore:keystore];
}

- (void)vetTransfer:(NSString *)from keystore:(NSString *)keystore
{
    NSString *amountHex = [Payment parseEther:self.transferAmountTextField.text].hexString;
    //vet
    TransactionParameter *paramters = [[TransactionParameter alloc]init];
    paramters.to = self.receiveAddressTextView.text;
    paramters.value = amountHex;
    paramters.data = @"";

    paramters.from = from;
    paramters.gas = @"21000";

    [WalletUtils sendWithKeystore:keystore
                               parameter:paramters
                                   callback:^(NSString *txId, NSString *signer)
     {

        NSLog(@"dd");
    }];
}

- (void)vthoTransfer:(NSString *)from keystore:(NSString *)keystore
{
    NSString *amountHex = [Payment parseEther:self.transferAmountTextField.text].hexString;
    
    TransactionParameter *paramters = [[TransactionParameter alloc]init];
    paramters.to = _tokenContractAddress; //token address
    paramters.value = @"";
    
    paramters.data = [self calculatenTokenTransferClauseData:self.receiveAddressTextView.text value:amountHex];;
    
    paramters.from = from;
    paramters.gas = @"60000";
    
    [WalletUtils sendWithKeystore:keystore
                               parameter:paramters
                                   callback:^(NSString *txId, NSString *signer)
     {
         NSLog(@"dd");
     }];

}

//address: receive address
- (NSString *)calculatenTokenTransferClauseData:(NSString *)address
                                     value:(NSString *)value
{
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

- (void)contractSignture:(NSString *)from keystore:(NSString *)keystore
{


    //xnode pending order contract
    TransactionParameter *paramters = [[TransactionParameter alloc]init];
    paramters.to = @"0xd4dac3a95c741773f093d59256a21ed6fcc768a7"; //token address
    paramters.value = @"";
    paramters.data = @"0xbae3e19e00000000000000000000000000000000000000000000000000000000000000680000000000000000000000000000000000000000000000000de0b6b3a76400000000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000000000000000000000000000000000000003f480";
    
    {
//        0x68,
//        0x0DE0B6B3A7640000,
//        0x3840,
//        0x1231231231231231231231231231233123121231

        NSMutableArray *clauseParamList = [NSMutableArray array];
        [clauseParamList addObject:@"0x68"];
        [clauseParamList addObject:@"0x0DE0B6B3A7640000"];
        [clauseParamList addObject:@"0x3840"];
        [clauseParamList addObject:@"0x1231231231231231231231231231231231231231"];
        paramters.data = [self contractMethodId:@"0x2ed9b4fd" params:clauseParamList];
    }
    
    paramters.from = from;
    paramters.gas = @"600000";
    
    [WalletUtils sendWithKeystore:keystore
                        parameter:paramters
                                callback:^(NSString *txId, NSString *signer)
     {
         NSLog(@"dd");
     }];
}

//Contract signature, clause data preparation
- (NSString *)contractMethodId:(NSString *)methodId params:(NSArray *)params
{
    
    NSString *totalData = methodId;
    for (NSString *param in params) {
        NSInteger t = 64 - [param substringFromIndex:2].length;
        NSMutableString *zero = [NSMutableString new];
        for (int i = 0; i < t; i++) {
            [zero appendString:@"0"];
        }
        NSString *newValue = [NSString stringWithFormat:@"%@%@",zero,[param substringFromIndex:2]];
        
        totalData = [totalData stringByAppendingString:newValue];
    }
    return totalData;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


/**
 *  Just hidden the keyboard.
 */
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



- (IBAction)changeSlider:(id)sender{
    
}


@end
