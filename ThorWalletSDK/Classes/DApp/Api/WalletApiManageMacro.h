//
//  WalletApiManageMacro.h
//  Wallet
//
//  Created by vechaindev on 2018/9/20.
//  Copyright © 2018年 VeChain. All rights reserved.
//
// This code is distributed under the terms and conditions of the MIT license. 

/**
    Copyright (c) 2019 vechaindev <support@vechain.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

**/



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
