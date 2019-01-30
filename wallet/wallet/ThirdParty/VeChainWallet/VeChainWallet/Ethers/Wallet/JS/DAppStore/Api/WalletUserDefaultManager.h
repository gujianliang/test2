//
//  WalletUserDefaultManager.h
//  FFBMS
//
//  Created by 曾新 on 16/4/11.
//  Copyright © 2016年 Eagle. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
//#import "WalletContractConfig.h"

typedef NS_ENUM(NSInteger , SERVICE)
{
    TEST_SERVER,
    DEVELOP_SERVER,
    STAGING_SERVER,
    PRODUCT_SERVER
};

typedef NS_ENUM(NSInteger , InputAddressType)
{
    none_type = 0,
    copy_type = 1,
    scan_type = 2,
    contact_type = 3,
};

@interface WalletUserDefaultManager : NSObject

+ (void)setServerType:(NSInteger) type;
+ (NSString *)getMainUrl;
+ (NSString *)getBlockUrl;
+ (NSString *)getTokenSwapUrl;
+ (NSString *)getPushNoticeUrl;

+ (NSString *)getBasicUrl;
+ (NSString *)getAuthAddressUrl;
/* 获取最新的语言 */
+ (void)setLanuage:(NSString *)lanuage;
+ (NSString *)getLanuage;

/* 获取 奖励页是否同意协议 */
+ (void)setRewardAgree:(NSString *)RewardAgree;
+ (BOOL)getRewardAgree;

/* 获取 X节点是否同意服务 */
+ (void)setXAgree:(NSString *)XAgree;
+ (BOOL)getXAgree;

/* 获取 VET 置换服务是否同意协议*/
+ (void)setVETAgree:(NSString *)VETAgree;
+ (BOOL)getVETAgree;

/* 获取 奖励功能服务是否 开启 */
+ (void)setRewardStartStatuse:(NSString *)startStatus;
+ (BOOL)getRewardStartStatuse;

/* 获取 转账页面是否首次进入 */
+ (void)setTransferAccountsFirst:(NSString *)AccountsFirst;
+ (BOOL)getTransAccountsFirst;
/* 获取 转账页面是否理解了 */
+ (void)setTransferAccountsNeverTip:(NSString *)AccountsNeverTip;
+ (BOOL)getTransAccountsNeverTip;

/* 获取 收款页面是否首次进入 */
+ (void)setReceiveCoinFirst:(NSString *)ReceiveCoinFirst;
+ (BOOL)getReceiveCoinFirst;

/* 获取 收款页面是否理解了 */
+ (void)setReceiveCoinNeverTip:(NSString *)ReceiveCoinNeverTip;
+ (BOOL)getReceiveCoinNeverTip;

/*数据库密码*/
+ (void)setDBKey:(NSString *)DBKey;
+ (NSString *)getDBKey;

/* 获取 是否有同意授权钱包协议 */
+ (void)setAuthObserveAgree:(NSString *)AuthObserveAgree;
+ (BOOL)getAuthObserveAgree;

/* 获取 是否有同意地址授权协议 */
+ (void)setAuthAddressAgree:(NSString *)AuthAddressAgree;
+ (BOOL)getAuthAddressAgree;

/* 获取 是否有知道了奖励引导 */
+ (void)setGuideRewardAgree:(NSString *)GuideRewardAgree;
+ (BOOL)getGuideRewardAgree;

//保存idfv
+ (void)setIDFV:(NSString *)IDFV;
+ (NSString *)getIDFV;

+(void)setChannel:(NSString *)channelId;
+(NSString *)getChannel;

//保存环境类型
+(void)setSaveServerType:(NSNumber *)serverType;
+(NSNumber *)getSaveServerType;

//退出后台时间
+(void)setResignTime:(NSString *)resignTime;
+(NSString *)getResignTime;
+(void)removeResignTime;

//app密码相关
+(void)setAppPW:(NSString *)appPW;
+(NSString *)getAppPW;
+(void)removeAppPW;

//钱包列表，当前选择的index
+(void)setWalletIndex:(NSNumber *)walletIndex;
+(NSNumber *)getWalletIndex;

//xnode or token swap 状态
+(void)setTokenSwapORXnode:(NSString *)tokenSwapORXnode;
+(NSString *)getTokenSwapORXnode;

//是否选择了xnode 阅读规则
+(void)setSelectRuleXnode:(NSString *)selectRuleXnode;
+(NSString *)getSelectRuleXnode;

//是否隐藏资产数据
+(void)setHideAmount:(NSNumber *)hideAmount;
+(NSNumber *)getHideAmount;


//best 块高度
+(void)setBestnumber:(NSNumber *)bestnumber;
+(NSNumber *)getBestnumber;


//base gas price
+(void)setBaseGasPrice:(NSString *)baseGasPrice;
+(NSString *)getBaseGasPrice;

//是否开启touch id
+(void)setEnableBiometricAuth:(NSNumber *)enableBiometricAuth;
+(NSNumber *)getEnableBiometricAuth;

//是否开启数据采集埋点
+(void)setEnableCollectDataAuth:(NSNumber *)collectDataAuth;
+(NSNumber *)getEnableCollectDataAuth;

//node 交易url
+(NSString *)getNodeExchangeUrl;

// 存储节点BaseURI
+(void)setNodeBaseURL:(NSString *)nodeBaseURL;
+(NSString *)getNodeBaseURL;

// 存储txID
+ (void)setTxID:(NSString *)txID;
+ (NSMutableArray *)getTxIDArr;


//是否看过收藏品规则
+ (BOOL)getExchangeRule;
+(void)setExchangeRule:(BOOL)hasSee;

//收藏品描述
+ (void)setExchangeProDescroption:(NSString *)exchangeProDescroption;
+ (NSString *)getExchangeProDescroption;

// 存储地址填写方式
+ (void)setInputType:(InputAddressType)taype;
+ (NSString *)getInputType;
+ (NSString *)getStringInputType:(NSInteger)type;

// 存储现在可以发送有效指令
+ (BOOL)getDataAvailable;
+ (void)setDataAvailable:(NSString *)dataAvailable;

// 存储注册时的tokenID
+ (void)setRegisterTokenId:(NSString *)registerTokenId;
+ (NSString *)getRegisterTokenId;

// 存储新安装的主协议是否有同意
+ (void)setStartAgreeProtocol:(NSString *)startAgreeProtocol;
+ (BOOL)getStartAgreeProtocol;

// 存储隐私埋点协议是否有同意
+ (void)setPrivacyAgreement:(NSString *)parivacyAgreement;
+ (BOOL)getPrivacyAgreement;

@end
