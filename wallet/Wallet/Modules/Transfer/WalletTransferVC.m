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
    
    _blockHost = [WalletUtils getNodeUrl];
    
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
    self.receiveAddressTextView.text = @"0x1231231231231231231212131231231231231231";
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
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"Please enter the wallet password"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    @weakify(self);
    [alertController addAction:([UIAlertAction actionWithTitle: @"Confirm"
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
                                     
        UITextField *textF =  alertController.textFields.lastObject;
        
        NSString *password = textF.text;
        
        [WalletUtils verifyKeystorePassword:keystore password:password callback:^(BOOL result) {
            @strongify(self);
                 if (result) {
                     
                     if (self.isVET) {
                         [self vetTransfer:from keystore:keystore password:password];
                     }else{
                         [self tokenTransfer:from keystore:keystore password:password];
                     }
                     
                     //sign contract demo
                     //    [self contractSignture:from keystore:keystore password:password];
                 }else{
                     NSLog(@"The password is wrong");
                 }
        }];
        
    }])];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)vetTransfer:(NSString *)from keystore:(NSString *)keystore  password:(NSString *)password{
    
    if (self.receiveAddressTextView.text.length == 0
        || self.transferAmountTextField.text.length == 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text =  NSLocalizedString(@"input_empty", nil);
        [hud hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:self.transferAmountTextField.text dicimals:18];

    TransactionParameter *transactionModel = [[TransactionParameter alloc]init];
    transactionModel.gas = @"21000";  //Set maximum gas allowed for call,
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //noce: hex string
    transactionModel.noce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = self.receiveAddressTextView.text;//Payee's address
    clauseModel.value = amountBig.hexString;//Payment amount,hex string
    clauseModel.data  = @"";
    [clauseList addObject:clauseModel];
    transactionModel.clauses = clauseList; //Clauses is an array
    
    transactionModel.expiration = @"720"; //Expiration relative to blockRef
    transactionModel.gasPriceCoef = @"0";// Coefficient used to calculate the final gas price (0 - 255)

    //Get the chain tag of the block
    [self getChainTagAndBlockReference:transactionModel keystore:keystore password:password];
}


- (void)tokenTransfer:(NSString *)from keystore:(NSString *)keystore  password:(NSString *)password{
    if (self.receiveAddressTextView.text.length == 0
        || self.transferAmountTextField.text.length == 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text =  NSLocalizedString(@"input_empty", nil);
        [hud hideAnimated:YES afterDelay:1.5];
        return;
    }
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
    //The amount of the transaction needs to be multiplied by the disimals of the coin
    BigNumber *amountBig = [self amountConvertWei:self.transferAmountTextField.text dicimals:18];
    
    TransactionParameter *transactionModel = [[TransactionParameter alloc]init];
    transactionModel.gas = @"60000"; //Set maximum gas allowed for call,
    
    //noce: hex string
    transactionModel.noce = [BigNumber bigNumberWithData:randomData].hexString;

    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = _tokenContractAddress;//Contract address of token
    clauseModel.value = @""; //Vip 180 transaction token, value is an empty string
    
    //
    clauseModel.data  = [self calculatenTokenTransferClauseData:self.receiveAddressTextView.text value:amountBig.hexString];
    [clauseList addObject:clauseModel];
    transactionModel.clauses = clauseList;//Clauses is an array
    transactionModel.expiration = @"720";//Expiration relative to blockRef
    transactionModel.gasPriceCoef = @"0";// Coefficient used to calculate the final gas price (0 - 255)

    //Get the chain tag of the block
    [self getChainTagAndBlockReference:transactionModel keystore:keystore password:password];
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

- (void)contractSignture:(NSString *)from keystore:(NSString *)keystore  password:(NSString *)password{
    //xnode pending order contract
   
    TransactionParameter *transactionModel = [[TransactionParameter alloc]init];
    transactionModel.gas = @"60000"; //Set maximum gas allowed for call, decimalstring
    
    //The random number is 8 bytes
    NSMutableData* randomData = [[NSMutableData alloc]initWithCapacity:8];
    randomData.length = 8;
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        return ;
    }
     //noce: hex string
    transactionModel.noce = [BigNumber bigNumberWithData:randomData].hexString;
    
    NSMutableArray *clauseList = [NSMutableArray array];
    ClauseModel *clauseModel = [[ClauseModel alloc]init];
    clauseModel.to    = @"0xd4dac3a95c741773f093d59256a21ed6fcc768a7"; //contract address
    clauseModel.value = @"";//Contract signature requires the number of trade vets, if you don't need to trade vet, this value is your empty string
    
    //Contract signature parameters
    clauseModel.data  = @"0xbae3e19e00000000000000000000000000000000000000000000000000000000000000680000000000000000000000000000000000000000000000000de0b6b3a76400000000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000000000000000000000000000000000000003f480";
    
    {
        // Method of splicing data
        //        NSMutableArray *clauseParamList = [NSMutableArray array];
        //        [clauseParamList addObject:@"0x68"];
        //        [clauseParamList addObject:@"0x0DE0B6B3A7640000"];
        //        [clauseParamList addObject:@"0x3840"];
        //        [clauseParamList addObject:@"0x1231231231231231231231231231231231231231"];
        //        clauseModel.data = [self contractMethodId:@"0x2ed9b4fd" params:clauseParamList];
    }
    
    [clauseList addObject:clauseModel];
    transactionModel.clauses = clauseList;//Clauses is an array
    transactionModel.expiration = @"720";//Expiration relative to blockRef
    transactionModel.gasPriceCoef = @"0";// Coefficient used to calculate the final gas price (0 - 255)

    
    transactionModel.gas = @"600000"; //Set maximum gas allowed for call,
    
     //Get the chain tag of the block
    [self getChainTagAndBlockReference:transactionModel keystore:keystore password:password];
}

- (void)getChainTagAndBlockReference:(TransactionParameter *)transactionModel
                            keystore:(NSString *)keystore
                            password:(NSString *)password
{
    @weakify(self);
    //Get the chain tag of the block chain
    [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
        NSLog(@"chainTag == %@",chainTag);
        //If the chainTag is nil, then the acquisition fails, you can prompt alert
        transactionModel.chainTag = chainTag;
        
        //Get the reference of the block chain
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            NSLog(@"blockReference == %@",blockReference);
            //If the blockReference is nil, then the acquisition fails, you can prompt alert
            
            transactionModel.blockReference = blockReference;
            @strongify(self);
            [self checkModelAndSendTransfer:transactionModel
                                   keystore:keystore
                                   password:password];
        }];
    }];
    
}

- (void)checkModelAndSendTransfer:(TransactionParameter *)transactionModel
                         keystore:(NSString *)keystore
                         password:(NSString *)password
{
    // Check if the signature parameters are correct
    [transactionModel checkParameter:^(NSString * _Nonnull error, BOOL result)
     {
         if (!result) {
             NSLog(@"error == %@",error);
         }else
         {
             [WalletUtils signAndSendTransfer:keystore
                                    parameter:transactionModel
                                     password:password
                                     callback:^(NSString *txId)
              {
                  //Developers can use txid to query the status of data packaged on the chain
        
                  NSLog(@"\n txId: %@", txId);
              }];
         }
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

/**
*  Just hidden the keyboard.
*/
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (BigNumber *)amountConvertWei:(NSString *)amount dicimals:(NSInteger )dicimals
{
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:amount];
    NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, dicimals)]];
    NSDecimalNumber *weiNumber = [number decimalNumberByMultiplyingBy:number1];
    
    return [BigNumber bigNumberWithNumber:weiNumber];
}

- (void)dealloc
{
    [WalletUtils deallocDappSingletion];
}

@end
