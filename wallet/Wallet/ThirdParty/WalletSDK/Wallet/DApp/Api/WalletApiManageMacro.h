//
//  WalletApiManageMacro.h
//  VeWallet
//
//  Created by Tom on 2018/9/20.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#ifndef WalletApiManageMacro_h
#define WalletApiManageMacro_h

#define StringWithParam(__host__,__param__)  [NSString stringWithFormat:__host__,__param__]

////Transaction Details
//#define ReceiptInfoWithAddress          @"/transactions/%@/receipt"

////Initial block information
//#define GenesisBlocKInfo                @"/blocks/0"

////Balance
//#define BalanceWithAddress              @"/accounts/%@"
//
////Send transaction
//#define SendTransactionUrl              @"/transactions"

////Latest block informati
//#define NewBlockInfoUrl                 @"/blocks/best"

////app version
//#define AppVersionUrl                   @"/v1/app/version"


#endif /* WalletApiManageMacro_h */
