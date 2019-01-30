//
//  WalletUserDefaultManager.m
//  FFBMS
//
//  Created by 曾新 on 16/4/11.
//  Copyright © 2016年 Eagle. All rights reserved.
//

#import "WalletUserDefaultManager.h"

@implementation WalletUserDefaultManager

+ (void)setServerType:(NSInteger) type
{
    //保存当前环境
    [WalletUserDefaultManager setSaveServerType:@(type)];
    
    switch (type) {
            
        case TEST_SERVER: //测试环境
        {
            // 基础钱包功能API(Explorer服务)
            [[NSUserDefaults standardUserDefaults] setValue: explorer_host_test forKey:@"MainUrl"];
            
            // 区块链节点地址
            [[NSUserDefaults standardUserDefaults] setValue: blockChain_host_test forKey:@"BlockUrl"];
            
            // 换币功能API(有加密)
            [[NSUserDefaults standardUserDefaults] setValue: token_swap_host_test forKey:@"TokenSwap"];
            
            // 版本升级、tokenswap开关、获取系统配置信息(有加密)
            [[NSUserDefaults standardUserDefaults] setValue: base_wallet_host_test forKey:@"BasicUrl"];
            
            // 地址授权
            [[NSUserDefaults standardUserDefaults] setValue: authorized_host_test forKey:@"AuthAddress"];
            
            //收藏品
            [[NSUserDefaults standardUserDefaults] setValue: category_host_test forKey:@"nodeExchangeUrl"];
            
            //合约地址
            [[NSUserDefaults standardUserDefaults] setValue: NODE_CONTRACT_ADDRESS_TEST forKey:@"contractAddressKey"];
            
            //推送
            [[NSUserDefaults standardUserDefaults] setValue: push_host_test forKey:@"PushNotice"];
        }
            break;
            
        case DEVELOP_SERVER:
        {
            // 基础钱包功能API(Explorer服务)
            [[NSUserDefaults standardUserDefaults] setValue: explorer_host_dev forKey:@"MainUrl"];
            
            // 区块链节点地址
            [[NSUserDefaults standardUserDefaults] setValue: blockChain_host_dev forKey:@"BlockUrl"];
            
            // 换币功能API(有加密)
            [[NSUserDefaults standardUserDefaults] setValue: token_swap_host_dev forKey:@"TokenSwap"];
            
            // 版本升级、tokenswap开关、获取系统配置信息(有加密)
            [[NSUserDefaults standardUserDefaults] setValue: base_wallet_host_dev forKey:@"BasicUrl"];
            
            // 地址授权
            [[NSUserDefaults standardUserDefaults] setValue: authorized_host_dev forKey:@"AuthAddress"];
            
             // 收藏品
             [[NSUserDefaults standardUserDefaults] setValue: category_host_dev forKey:@"nodeExchangeUrl"];
            
             //合约地址
             [[NSUserDefaults standardUserDefaults] setValue: NODE_CONTRACT_ADDRESS_DEBUG forKey:@"contractAddressKey"];
            
            //推送
            [[NSUserDefaults standardUserDefaults] setValue: push_host_dev forKey:@"PushNotice"];
        }
            break;
            
        case STAGING_SERVER:
        {
            // 基础钱包功能API(Explorer服务)
            [[NSUserDefaults standardUserDefaults] setValue: explorer_host_staging forKey:@"MainUrl"];
            
            // 区块链节点地址
            [[NSUserDefaults standardUserDefaults] setValue: blockChain_host_staging forKey:@"BlockUrl"];
            
            // 换币功能API(有加密)
            [[NSUserDefaults standardUserDefaults] setValue: token_swap_host_staging forKey:@"TokenSwap"];
            
            // 版本升级、tokenswap开关、获取系统配置信息(有加密)
            [[NSUserDefaults standardUserDefaults] setValue: base_wallet_host_staging forKey:@"BasicUrl"];
            
            // 地址授权
            [[NSUserDefaults standardUserDefaults] setValue:authorized_host_staging forKey:@"AuthAddress"];
            
            //收藏品
            [[NSUserDefaults standardUserDefaults] setValue: category_host_staging forKey:@"nodeExchangeUrl"];
            
            // 合约地址
            [[NSUserDefaults standardUserDefaults] setValue: NODE_CONTRACT_ADDRESS_STAGING forKey:@"contractAddressKey"];
            
            //推送
            [[NSUserDefaults standardUserDefaults] setValue: push_host_staging forKey:@"PushNotice"];
        }
            break;
            
        case PRODUCT_SERVER://生产环境
        {
            // 基础钱包功能API(Explorer服务)
            [[NSUserDefaults standardUserDefaults] setValue: explorer_host_release forKey:@"MainUrl"];
            
            // 区块链节点地址
            [[NSUserDefaults standardUserDefaults] setValue: blockChain_host_release forKey:@"BlockUrl"];
            
            // 换币功能API(有加密)
            [[NSUserDefaults standardUserDefaults] setValue: token_swap_host_release forKey:@"TokenSwap"];
            
            // 版本升级、tokenswap开关、获取系统配置信息(有加密)
            [[NSUserDefaults standardUserDefaults] setValue: base_wallet_host_release forKey:@"BasicUrl"];
            
            // 地址授权
            [[NSUserDefaults standardUserDefaults] setValue: authorized_host_release forKey:@"AuthAddress"];
            
            //收藏品
            [[NSUserDefaults standardUserDefaults] setValue: category_host_release forKey:@"nodeExchangeUrl"];
            
            // 合约地址
            [[NSUserDefaults standardUserDefaults] setValue: NODE_CONTRACT_ADDRESS_RELEASE forKey:@"contractAddressKey"];
            
            //推送
            [[NSUserDefaults standardUserDefaults] setValue: push_host_release forKey:@"PushNotice"];
            
        }
            break;
            
        default:break;
    }
}

+ (NSString *)getMainUrl
{
     return [[NSUserDefaults standardUserDefaults] objectForKey:@"MainUrl"];
}

+ (NSString *)getBlockUrl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"BlockUrl"];
}

+ (NSString *)getTokenSwapUrl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"TokenSwap"];
}

+ (NSString *)getBasicUrl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"BasicUrl"];
}


+ (NSString *)getAuthAddressUrl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"AuthAddress"];
}

+(NSString *)getNodeExchangeUrl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"nodeExchangeUrl"];;
}

+(NSString *)getPushNoticeUrl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"PushNotice"];;
}

+ (void)setLanuage:(NSString *)lanuage
{
    [[NSUserDefaults standardUserDefaults] setObject:lanuage forKey:@"languageCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getLanuage
{
    NSString *languageCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
    NSString *language = nil;
    
    if (languageCode.length == 0) { // 用户未设置：取出手机自带语言
        
        NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSString *localeLanguageCode = [appLanguages objectAtIndex:0];
       
        
        if ([localeLanguageCode containsString:@"zh"]) {
            language = @"zh-Hans";
        
        }else{
            language = @"en";
        }
    }else{ // 用户设置：取出设置语言
        language = languageCode;
    }
    
    return language;
}

/* 获取 奖励页是否同意协议 */
+ (void)setRewardAgree:(NSString *)RewardAgree{
    [[NSUserDefaults standardUserDefaults] setObject:RewardAgree forKey:@"RewardAgree"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getRewardAgree{
    NSString *rewardAgree = [[NSUserDefaults standardUserDefaults] objectForKey:@"RewardAgree"];
    return rewardAgree.intValue;
}


/* 获取 X节点是否同意服务 */
+ (void)setXAgree:(NSString *)XAgree{
    [[NSUserDefaults standardUserDefaults] setObject:XAgree forKey:@"XAgree"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getXAgree{
    NSString *XAgree = [[NSUserDefaults standardUserDefaults] objectForKey:@"XAgree"];
    return XAgree.intValue;
}

/* 获取 VET 置换服务是否同意协议*/
+ (void)setVETAgree:(NSString *)VETAgree{
    [[NSUserDefaults standardUserDefaults] setObject:VETAgree forKey:@"VETAgree"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getVETAgree{
    NSString *VETAgree = [[NSUserDefaults standardUserDefaults] objectForKey:@"VETAgree"];
    return VETAgree.intValue;
}


/* 获取 奖励功能服务是否 开启 */
+ (void)setRewardStartStatuse:(NSString *)startStatus{
    if(startStatus.length == 0){startStatus = @"0";}
    [[NSUserDefaults standardUserDefaults] setObject:startStatus forKey:@"startStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getRewardStartStatuse{
    NSString *startStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"startStatus"];
    return startStatus.intValue;
}


/* 获取 转账页面是否首次进入 */
+ (void)setTransferAccountsFirst:(NSString *)AccountsFirst{
    [[NSUserDefaults standardUserDefaults] setObject:AccountsFirst forKey:@"AccountsFirst"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getTransAccountsFirst{
    NSString *AccountsFirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccountsFirst"];
    return AccountsFirst.intValue;
}
/* 获取 转账页面是否不再提示 */
+ (void)setTransferAccountsNeverTip:(NSString *)AccountsNeverTip{
    [[NSUserDefaults standardUserDefaults] setObject:AccountsNeverTip forKey:@"AccountsNeverTip"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getTransAccountsNeverTip{
    NSString *AccountsNeverTip = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccountsNeverTip"];
    return AccountsNeverTip.intValue;
}

/* 获取 收款页面是否首次进入 */
+ (void)setReceiveCoinFirst:(NSString *)ReceiveCoinFirst{
    [[NSUserDefaults standardUserDefaults] setObject:ReceiveCoinFirst forKey:@"ReceiveCoinFirst"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getReceiveCoinFirst{
    NSString *ReceiveCoinFirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReceiveCoinFirst"];
    return ReceiveCoinFirst.intValue;
}
/* 获取 收款页面是否不再提示 */
+ (void)setReceiveCoinNeverTip:(NSString *)ReceiveCoinNeverTip{
    [[NSUserDefaults standardUserDefaults] setObject:ReceiveCoinNeverTip forKey:@"ReceiveCoinNeverTip"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getReceiveCoinNeverTip{
    NSString *ReceiveCoinNeverTip = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReceiveCoinNeverTip"];
    return ReceiveCoinNeverTip.intValue;
}

//保存数据库密码
+ (void)setDBKey:(NSString *)DBKey
{
    [[NSUserDefaults standardUserDefaults] setObject:DBKey forKey:@"DBKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getDBKey
{
    NSString *DBKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"DBKey"];
    return DBKey;
}

//报错idfv
+ (void)setIDFV:(NSString *)IDFV
{
    [[NSUserDefaults standardUserDefaults] setObject:IDFV forKey:@"IDFV"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getIDFV
{
    NSString *IDFV = [[NSUserDefaults standardUserDefaults] objectForKey:@"IDFV"];
    return IDFV;
}

/* 获取 是否有同意授权钱包协议 */
+ (void)setAuthObserveAgree:(NSString *)AuthObserveAgree {
    [[NSUserDefaults standardUserDefaults] setObject:AuthObserveAgree forKey:@"AuthObserveAgree"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getAuthObserveAgree {
    NSString *AuthObserveAgree = [[NSUserDefaults standardUserDefaults] objectForKey:@"AuthObserveAgree"];
    return AuthObserveAgree.intValue;
}

/* 获取 地址是否同意协议 */
+ (void)setAuthAddressAgree:(NSString *)AuthAddressAgree
{
    [[NSUserDefaults standardUserDefaults] setObject:AuthAddressAgree forKey:@"AuthAddressAgree"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getAuthAddressAgree
{
    NSString *rewardAgree = [[NSUserDefaults standardUserDefaults] objectForKey:@"AuthAddressAgree"];
    return rewardAgree.intValue;
}


/* 获取 是否有知道了奖励引导 */
+ (void)setGuideRewardAgree:(NSString *)GuideRewardAgree {
    [[NSUserDefaults standardUserDefaults] setObject:GuideRewardAgree forKey:@"GuideRewardAgree"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getGuideRewardAgree {
    NSString *GuideRewardAgree = [[NSUserDefaults standardUserDefaults] objectForKey:@"GuideRewardAgree"];
    return GuideRewardAgree.intValue;
}

//渠道号
//+(void)setChannel:(NSString *)channelId
//{
//    [[NSUserDefaults standardUserDefaults] setObject:channelId forKey:kAppChannel];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

//+(NSString *)getChannel
//{
//    NSString *appChannel = [[NSUserDefaults standardUserDefaults] objectForKey:kAppChannel];
//    return appChannel;
//}

//保存环境类型
+(void)setSaveServerType:(NSNumber *)serverType
{
    [[NSUserDefaults standardUserDefaults] setObject:serverType forKey:@"service"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSNumber *)getSaveServerType
{
    NSNumber *serverType = [[NSUserDefaults standardUserDefaults] objectForKey:@"service"];
    return serverType;
}

////退出后台时间
//+(void)setResignTime:(NSString *)resignTime
//{
//    [[NSUserDefaults standardUserDefaults] setObject:resignTime forKey:kResign];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+(NSString *)getResignTime
//{
//    NSString *resignTime = [[NSUserDefaults standardUserDefaults] objectForKey:kResign];
//    return resignTime;
//}
//
//+(void)removeResignTime
//{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kResign];
//}

//打开app 密码相关
+(void)setAppPW:(NSString *)appPW
{
    [[NSUserDefaults standardUserDefaults] setObject:appPW forKey:@"AppConfig"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getAppPW
{
    NSString *appPW = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppConfig"];
    return appPW;
}

+(void)removeAppPW
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AppConfig"];
}

//当前钱包的index
//+(void)setWalletIndex:(NSNumber *)walletIndex
//{
//    [[NSUserDefaults standardUserDefaults] setObject:walletIndex forKey:WALLET_ASSETS_SELECTED_WALLET_INDEX_KEY];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+(NSNumber *)getWalletIndex
//{
//    NSNumber *appPW = [[NSUserDefaults standardUserDefaults] objectForKey:WALLET_ASSETS_SELECTED_WALLET_INDEX_KEY];
//    return appPW;
//}

////xnode or token swap 状态
//+(void)setTokenSwapORXnode:(NSString *)tokenSwapORXnode
//{
//    [[NSUserDefaults standardUserDefaults] setObject:tokenSwapORXnode forKey:kTokenSwapORXnode];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+(NSString *)getTokenSwapORXnode
//{
//    NSString *tokenSwapORXnode = [[NSUserDefaults standardUserDefaults] objectForKey:kTokenSwapORXnode];
//    return tokenSwapORXnode;
//}
//
////是否选择了xnode 阅读规则
//+(void)setSelectRuleXnode:(NSString *)selectRuleXnode
//{
//    [[NSUserDefaults standardUserDefaults] setObject:selectRuleXnode forKey:kselectRuleXnode];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+(NSString *)getSelectRuleXnode
//{
//    NSString *selectRuleXnode = [[NSUserDefaults standardUserDefaults] objectForKey:kselectRuleXnode];
//    return selectRuleXnode;
//}

////是否隐藏资产数据
//+(void)setHideAmount:(NSNumber *)hideAmount
//{
//    [[NSUserDefaults standardUserDefaults] setObject:hideAmount forKey:WALLET_ASSETS_HIDE_AMOUNT_KEY];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+(NSNumber *)getHideAmount
//{
//    NSNumber *hideAmount = [[NSUserDefaults standardUserDefaults] objectForKey:WALLET_ASSETS_HIDE_AMOUNT_KEY];
//    return hideAmount;
//}

//best 块高度
+(void)setBestnumber:(NSNumber *)bestnumber
{
    [[NSUserDefaults standardUserDefaults] setObject:bestnumber forKey:@"bestnumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSNumber *)getBestnumber
{
    NSNumber *bestnumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"bestnumber"];
    return bestnumber;
}

////base gas price
//+(void)setBaseGasPrice:(NSString *)baseGasPrice
//{
//    [[NSUserDefaults standardUserDefaults] setObject:baseGasPrice forKey:WALLET_BASE_GAS_PRICE];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+(NSString *)getBaseGasPrice
//{
//    NSString *baseGasPrice = [[NSUserDefaults standardUserDefaults] objectForKey:WALLET_BASE_GAS_PRICE];
//    return baseGasPrice;
//}

//是否开启touch id
+(void)setEnableBiometricAuth:(NSNumber *)enableBiometricAuth
{
    [[NSUserDefaults standardUserDefaults] setObject:enableBiometricAuth forKey:@"WalletEnableBiometricAuth"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSNumber *)getEnableBiometricAuth
{
    NSNumber *enableBiometricAuth = [[NSUserDefaults standardUserDefaults] objectForKey:@"WalletEnableBiometricAuth"];
    return enableBiometricAuth;
}

//是否开启数据采集埋点
+(void)setEnableCollectDataAuth:(NSNumber *)collectDataAuth
{
    [[NSUserDefaults standardUserDefaults] setObject:collectDataAuth forKey:@"collectDataAuth"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSNumber *)getEnableCollectDataAuth
{
    NSNumber *collectDataAuth = [[NSUserDefaults standardUserDefaults] objectForKey:@"collectDataAuth"];
    return collectDataAuth;
}

// 存储节点BaseURI
+ (void)setNodeBaseURL:(NSString *)nodeBaseURL {
    if(nodeBaseURL.length == 0){nodeBaseURL = @"";}
    [[NSUserDefaults standardUserDefaults] setObject:nodeBaseURL forKey:@"nodeBaseURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getNodeBaseURL {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"nodeBaseURL"];
}

// 存储txID
+ (void)setTxID:(NSString *)txID{
    
    /* 1、收集这个txID */
    NSArray *tempArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"txIDArr"];
    NSMutableArray *txIDArr = [NSMutableArray arrayWithArray:tempArr];
    if (txIDArr.count > 0) {
        [txIDArr addObject:txID];
        
    }else {
        txIDArr = [NSMutableArray array];
        [txIDArr addObject:txID];
    }
    
    /* 2、判断这个txID 集合列表 是否大于 50条记录，如果是，则清除掉前 25条 ，减少后面遍历次数 */
    if (txIDArr.count > 50) {
        [txIDArr removeObjectsInRange:NSMakeRange(0, 25)];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:txIDArr forKey:@"txIDArr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray *)getTxIDArr{
    NSMutableArray *txIDArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"txIDArr"];
    if (txIDArr) {
        return txIDArr;
    }else {
        return [NSMutableArray array];
    }
}


+ (BOOL)getExchangeRule
{
    BOOL exchangeRule = [[NSUserDefaults standardUserDefaults]boolForKey:@"exchangeRule"];
    return exchangeRule;
}

+(void)setExchangeRule:(BOOL)hasSee
{
    [[NSUserDefaults standardUserDefaults] setBool:hasSee forKey:@"exchangeRule"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setExchangeProDescroption:(NSString *)exchangeProDescroption
{
    if(exchangeProDescroption.length == 0){exchangeProDescroption = @"";}
    [[NSUserDefaults standardUserDefaults] setValue:exchangeProDescroption forKey:@"exchangeProDescroption"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getExchangeProDescroption
{
    NSString *descr = [[NSUserDefaults standardUserDefaults] objectForKey:@"exchangeProDescroption"];
    return (descr.length == 0) ? @"" : descr;
}

// 存储地址填写方式
+ (void)setInputType:(InputAddressType)inputAddressType {
    NSString *type = [NSString stringWithFormat:@"%ld", inputAddressType];
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"inputAddressType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getInputType {
    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"inputAddressType"];
    if (type.integerValue == 0) {
        return @"input";
        
    }else if (type.integerValue == 1) {
        return @"copy";
        
    }else if (type.integerValue == 2) {
        return @"scan";
        
    }else if (type.integerValue == 3) {
        return @"contact";
        
    }else {
        return @"";
    }
}

+(NSString *)getStringInputType:(NSInteger)type
{
    if (type == 0) {
        return @"input";
        
    }else if (type == 1) {
        return @"copy";
        
    }else if (type == 2) {
        return @"scan";
        
    }else if (type == 3) {
        return @"contact";
        
    }else {
        return @"";
    }
}

// 存储现在可以发送有效指令
+ (void)setDataAvailable:(NSString *)dataAvailable
{
    [[NSUserDefaults standardUserDefaults] setValue:dataAvailable forKey:@"dataAvailable"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getDataAvailable
{
    NSString *dataAvailable = [[NSUserDefaults standardUserDefaults] objectForKey:@"dataAvailable"];
    return dataAvailable.intValue;
}

+ (void)setRegisterTokenId:(NSString *)registerTokenId
{
    if(registerTokenId.length == 0){registerTokenId = @"";}
    [[NSUserDefaults standardUserDefaults] setValue:registerTokenId forKey:@"registerTokenId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getRegisterTokenId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"registerTokenId"];
}

// 存储新安装的主协议是否有同意
+ (void)setStartAgreeProtocol:(NSString *)startAgreeProtocol
{
    [[NSUserDefaults standardUserDefaults] setObject:startAgreeProtocol forKey:@"parivacyAgreement"];
    [[NSUserDefaults standardUserDefaults] setObject:startAgreeProtocol forKey:@"startAgree"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getStartAgreeProtocol
{
    NSString *startAgreeProtocol = [[NSUserDefaults standardUserDefaults] objectForKey:@"startAgree"];
    return startAgreeProtocol.boolValue;
}

// 存储隐私埋点协议是否有同意
+ (void)setPrivacyAgreement:(NSString *)parivacyAgreement{
    [[NSUserDefaults standardUserDefaults] setObject:parivacyAgreement forKey:@"parivacyAgreement"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getPrivacyAgreement{
    NSString *parivacyAgreement = [[NSUserDefaults standardUserDefaults] objectForKey:@"parivacyAgreement"];
    return parivacyAgreement.intValue;
}

@end
