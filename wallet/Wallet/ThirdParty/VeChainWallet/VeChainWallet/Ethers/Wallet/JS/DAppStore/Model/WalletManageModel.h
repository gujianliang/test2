//
//  WalletManageModel.h
//  VCWallet
//
//  Created by 曾新 on 2018/4/18.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "VCBaseModel.h"
#import "WalletRewardNodeModel.h"
#import "WalletNodeListModel.h"

@interface WalletCoinModel : VCBaseModel

@property (nonatomic, assign) NSInteger newsCount; // 待支付 条数

@property (nonatomic, copy)NSString *quantity; // 藏品余额

@property (nonatomic, copy)NSString *coinName;
@property (nonatomic, copy)NSString *coinCount;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *walletName;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *transferGas;
@property (nonatomic, assign) NSUInteger decimals;
@property (nonatomic, copy) NSString *icon; // ICO的 logo
@property (nonatomic, copy) NSString *ico;  // 是否是ICO的币

@property (nonatomic, copy) NSString *introduction_cn;  // token文案 中文
@property (nonatomic, copy) NSString *introduction_en;  // token文案 英文

@property (nonatomic, copy) NSString *pdescription_cn;  // tokenSale项目文案 中文
@property (nonatomic, copy) NSString *pdescription_en;  // tokenSale项目文案 英文
@property (nonatomic, copy) NSString *alert_cn;   // tokenSale弹窗文案 中文
@property (nonatomic, copy) NSString *alert_en;   // tokenSale弹窗文案 英文

@property (nonatomic, copy) NSString *officialWebsite;  // 官网域名
@property (nonatomic, copy) NSString *tokenSaleAddress;
@property (nonatomic, copy) NSString *tokenAddress;
@property (nonatomic, copy) NSString *tokenSaleGas;
@property (nonatomic, copy) NSString *tokenShow;//是否显示tokenlist 表里面


@property (nonatomic, assign) BOOL hideAssetsNumber;    // 是否隐藏币额
@end

@interface WalletManageModel : VCBaseModel

@property (nonatomic, copy)NSString *name; //钱包名
@property (nonatomic, copy)NSString *address; //vet 地址
@property (nonatomic, copy)NSString *VETCount;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, copy)NSString *observer; //是否是观察者钱包  1：是，0，否
@property (nonatomic, copy)NSString *addressNodeType; // 节点类型
@property (nonatomic, copy)NSString *addressNodeTypeImageName; // 节点类型图片名

@property (nonatomic, assign) BOOL isSelect;  // 是否被选中
@property (nonatomic, copy) NSString *officialWebsite;    // 官网域名, 跟着当前ICO的币走
@property (nonatomic, copy)NSString *icoAdddress; // 合约地址
@property (nonatomic, copy)NSString *introduceName; // 查看介绍名
@property (nonatomic, copy)NSString *tokenSaleGas;//ICO 合约gas;

@property (nonatomic, copy) NSString *reason; // 描述原因
@property (nonatomic, assign) BOOL enable;    // 是否支持可选中

@property (nonatomic, copy)NSArray <WalletCoinModel *> *coinList;
@property (nonatomic, strong)WalletNodeModel *nodeModel; //node 信息
@property (nonatomic, copy)NSArray <WalletCoinModel *> *showCoinList;//显示的icon

@property (nonatomic, strong)WalletCoinModel *vthoModel;

@property (nonatomic, copy) NSString *keyStore;

@end

