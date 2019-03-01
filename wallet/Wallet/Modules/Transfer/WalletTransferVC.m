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

#define VETGasLimit  @"21000"

@interface WalletTransferVC ()<UITextFieldDelegate>
{
    NSString *_toAddress;
    NSString *_tokenContractAddress;
    NSString *_blockHost;
}

@property (weak, nonatomic) IBOutlet UITextView *receiveAddressTextView;
@property (weak, nonatomic) IBOutlet UITextField *transferAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *balanceAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@property (weak, nonatomic) IBOutlet UILabel *symobl;
@property (weak, nonatomic) IBOutlet UIImageView *coinIcon;
@property (weak, nonatomic) IBOutlet UISlider *minerFeeSlider;
@property (strong, nonatomic) UITextField *pwTextField;

@end

@implementation WalletTransferVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _blockHost = Test_BlockHost;
    
    if (!_isVET) {
        _tokenContractAddress = @"0x0000000000000000000000000000456e65726779";
        [self.coinIcon setImage:[UIImage imageNamed:@"VTHO"]];
        self.symobl.text = @"VTHO";
        
    }else{
        [self.coinIcon setImage:[UIImage imageNamed:@"VET"]];
        self.symobl.text = @"VET";
    }
    
    self.receiveAddressTextView.text = @"0xe2c3B55d8Aa9920058030F73baCECe582f2123FF";
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
    
    [WalletUtils initWithWalletDict:walletList];
    [WalletUtils setCurrentWallet:from];
    
    
    NSString *keystore = currentWalletDict[@"keystore"];
    
//    //vet
//    TransactionParameter *paramters = [[TransactionParameter alloc]init];
//    paramters.to = @"0x1231231231231231231231231231231231231231";
//    paramters.value = @"0x0DE0B6B3A7640000";
//    paramters.data = @"";
//
//    paramters.from = from;
//    paramters.gas = @"21000";
//
//    [WalletUtils transactionWithKeystore:keystore
//                               parameter:paramters
//                                   block:^(NSString *txId, NSString *signer)
//     {
//
//        NSLog(@"dd");
//    }];

   
//    //vtho
//    TransactionParameter *paramters = [[TransactionParameter alloc]init];
//    paramters.to = @"0x0000000000000000000000000000456e65726779";
//    paramters.value = @"";
//    paramters.data = @"0xa9059cbb00000000000000000000000012312312312312312312312312312312312312310000000000000000000000000000000000000000000000000de0b6b3a7640000";
//
//    paramters.from = from;
//    paramters.gas = @"60000";
//
//    [WalletUtils transactionWithKeystore:keystore
//                               parameter:paramters
//                                   block:^(NSString *txId, NSString *signer)
//     {
//
//         NSLog(@"dd");
//     }];

    // contract
    
    
    TransactionParameter *paramters = [[TransactionParameter alloc]init];
    paramters.to = @"0xd4dac3a95c741773f093d59256a21ed6fcc768a7";
    paramters.value = @"";
    paramters.data = @"0xbae3e19e00000000000000000000000000000000000000000000000000000000000000680000000000000000000000000000000000000000000000000de0b6b3a76400000000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000000000000000000000000000000000000003f480";

    paramters.from = from;
    paramters.gas = @"600000";

    [WalletUtils transactionWithKeystore:keystore
                               parameter:paramters
                                   block:^(NSString *txId, NSString *signer)
     {

         NSLog(@"dd");
     }];
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
