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

//授权签名url
#define AuthSignUrlWithSession          @"/v1/sessiontoken/%@/sign"

//奖励详情/点击泡泡
#define RewardInfoUrlWithAddress        @"/v1/reward/thor/%@"

//奖励节点详情
#define RewardNodeInfoWithAddress       @"/v1/reward/node/%@"

//领取奖励记录列表
#define GetRewardHistoryWithAddress     @"/v1/reward/thor/%@/history"

//申请节点
#define ApplyNodeRewardWithAddress      @"/v1/reward/node/%@/apply"

//批量节点信息
#define TokenSwapNodeInfo               @"/v1/reward/node/info"

//节点绑定
#define NodeBindingInfoWithAddress      @"/v1/addresses/%@/bindinginfo"

//eth节点绑定信息
#define ETHNodeBindingInfoWithAddress   @"/v1/ethereum/addresses/%@/bindinginfo"

//node check
#define NodeCehckWithAddress            @"/v1/addresses/%@/compliance"

//eth ven address Binding
#define ETHBindingVet                   @"/v1/addresses/%@/binding"

//vet 交易列表
#define VetTradeHistoyWithAddress       @"/v1/addresses/%@/trades"

//token 交易列表
#define TokenTradeHistoryWithAddress    @"/v1/tokens/%@/trades"

//交易详情
#define ReceiptInfoWithAddress          @"/transactions/%@/receipt"

//vet置换记录
#define VETSwapHisoryWithAddress        @"/v1/addresses/%@/swaphistory"

//最初区块信息
#define GenesisBlocKInfo                @"/blocks/0"

//余额
#define BalanceWithAddress              @"/accounts/%@"

//token list
#define TokenListUrl                    @"/v1/app/tokens"

//发送交易
#define SendTransactionUrl              @"/transactions"

//最新区块信息
#define NewBlockInfoUrl                 @"/blocks/best"

//app version 相关信息
#define AppVersionUrl                   @"/v1/app/version"

//swap and reward 开关
#define AppFunctionControl              @"/v1/app/function"

//app config
#define AppConfigUrl                    @"/v1/app/config"

//push 注册
#define PushRegisterUrl                 @"/v1/notification/register"

//lanuage 更新
#define LanuageChangeUrl                @"/v1/notification/language"

#endif /* WalletApiManageMacro_h */
