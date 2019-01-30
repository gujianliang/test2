//
//  WalletCollectNodeModel.h
//  VeWallet
//
//  Created by 曾新 on 2018/10/9.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "VCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletCollectNodeModel : VCBaseModel

@property (nonatomic, copy)NSString *catalogID; // 类目ID编号
@property (nonatomic, copy)NSString *symbol;    //符号(ERC721)
@property (nonatomic, copy)NSString *name;      //名称(ERC721)
@property (nonatomic, copy)NSString *baseURI;   //藏品链接前缀。每个藏品至少包含两张大小不一的图，访问方式如下： 藏品小图: baseURI/small/:tokenID 藏品大图：baseURI/large/:tokenID
@property (nonatomic, copy)NSString *title;         //项目标题
@property (nonatomic, copy)NSString *tokenAddress;  //主合约地址
@property (nonatomic, copy)NSString *auctionAddress;//拍卖合约地址
@property (nonatomic, copy)NSString *pdescription;  //项目介绍

@property (nonatomic, copy)NSString *smallImage;    //项目小图
@property (nonatomic, copy)NSString *largeImage;    //项目大图
@property (nonatomic, copy)NSString *show;          //是否显示
@property (nonatomic, copy)NSString *showOrder;     //显示顺序
@property (nonatomic, copy)NSString *quantity;      //钱包地址的持有量，仅当提供钱包地址时显示
@property (nonatomic, copy)NSString *createdAt;     //创建时间
@property (nonatomic, copy)NSString *updatedAt;     //更新时间

@property (nonatomic, copy)NSString *txRate;        //交易费率

@end

@interface WalletCollectNodeListModel : VCBaseModel

@property (nonatomic, copy)NSArray *catalogs;

@end

NS_ASSUME_NONNULL_END
