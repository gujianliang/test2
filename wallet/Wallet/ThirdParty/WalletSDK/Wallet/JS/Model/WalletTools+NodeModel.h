//
//  WalletTools+NodeModel.h
//  VeWallet
//
//  Created by HuChao on 2018/12/28.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletTools.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletTools (NodeModel)

// type 转节点名称
+ (NSString *)convertXnodeName:(NSString *)nodeType;

// type 转节点图片名称
+ (NSString *)convertXnodeImageName:(NSString *)nodeType;

// type 转节点索引
+(NSString *)numConvertWithType:(NSString *)nodeType;

// type 转节点模型
//+ (WalletConvertNodeModel *)convertNodeModel:(NSString *)type;

// index 转节点模型
+ (NSString *)convertIndexModel:(NSInteger )index;

@end

NS_ASSUME_NONNULL_END
