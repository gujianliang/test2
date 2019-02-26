//
//  TransferVC.m
//  walletSDKDemo
//
//  Created by 曾新 on 2018/12/27.
//  Copyright © 2018年 demo. All rights reserved.
//

#import "WalletTransferVC.h"
#import <WalletSDK/WalletUtils.h>

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
@property (weak, nonatomic) IBOutlet UISlider *feeSwitcher;

@property (weak, nonatomic) IBOutlet UILabel *coinName;
@property (weak, nonatomic) IBOutlet UIImageView *coinIcon;
@property (weak, nonatomic) IBOutlet UISlider *minerFeeSlider;
@property (nonatomic, strong)UITextField *pwTextField;

@end

@implementation WalletTransferVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _blockHost = @"https://vethor-node-test.vechaindev.com";
    
    if (!_isVET) {
        _tokenContractAddress = @"0x0000000000000000000000000000456e65726779";
        [self.coinIcon setImage:[UIImage imageNamed:@"VTHO"]];
        self.coinName.text = @"VTHO";
    }else{
        [self.coinIcon setImage:[UIImage imageNamed:@"VET"]];
        self.coinName.text = @"VET";
    }
    
    self.receiveAddressTextView.text = @"0xe2c3B55d8Aa9920058030F73baCECe582f2123FF";
}

- (IBAction)transfer:(id)sender
{
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
    
    [WalletUtils signViewFromAddress:from toAddress:self.receiveAddressTextView.text amount:self.transferAmountTextField.text symbol:self.coinName.text gas:@"21000" tokenAddress:@"" decimals:18 block:^(NSString *txId) {
        
    }];
    
//    [WalletUtils signViewFrom:from
//                           to:self.receiveAddressTextView.text
//                       amount:self.transferAmountTextField.text
//                     coinName:self.coinName.text
//                        block:^(NSString *txId) {
//                            
//                        }];
    
    
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
