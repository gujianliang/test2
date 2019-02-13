//
//  WalletRewardNodeModel.h
//  VeWallet
//
//  Created by 曾新 on 2018/5/17.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "VCBaseModel.h"
@class nodeReasonModel;
@class reasonModel;

@interface WalletRewardNodeModel : VCBaseModel

/*
 节点等级：S, T, M, XV, XS, XT, XM；没有节点 类型是返回空（""）
 普通节点
    Strength node
    Thunder node
    Mjolnir node
 X节点
    VeThor X node
    Strength X node
    Thunder X node
    Mjolnir X node
 
0:默认值, 1：被降级, 2：正常, 3：申请通过
 */
@property (nonatomic, copy)NSString *nodeID;      // 当前地址所处的节点 ，默认为0，代表不是节点
@property (nonatomic, copy)NSString *nodeType;    // 节点等级  S, T, M, XV, XS, XT, XM；没有节点 类型是返回空（""）
@property (nonatomic, copy)NSString *nodeState;   // 0-被降级 1-正常 9-默认值
@property (nonatomic, copy)NSArray *nodeReason;     // 提示信息
@property (nonatomic, copy)NSString *applyNodeType; // 正在升级的节点
@property (nonatomic, copy)NSString *ripeDay;       // 目标达成所需要的天数，此时间在本地已经写死了，根据每个节点
@property (nonatomic, copy)NSString *ripeTerm;    // 剩余锁定期天数
@property (nonatomic, copy)NSString *capableNode; // 当前地址可以升级的下一级节点，如果没有可升级的节点，则为""
@property (nonatomic, copy)NSString *applyNodeState; // 0-审核不通过 1-审核中 2-审核通过
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *balance;

@end

@interface nodeReasonModel :VCBaseModel
@property (nonatomic, copy)NSString *type;  // 消息类型，1:降级，2:升级, 3:申请失败，9:默认值
@property (nonatomic, strong)reasonModel *reason;   // 消息数据对象
@end

@interface reasonModel :VCBaseModel

@property (nonatomic, copy)NSString *amount;            // 最新地址持币量
@property (nonatomic, copy)NSString *nodeType;          // 节点类型, (降级时为降到节点，升级时为升级到的节点，申请时为申请节点信息)
@property (nonatomic, copy)NSString *txID;              // 交易ID
@property (nonatomic, copy)NSString *blockID;           // 区块ID
@property (nonatomic, copy)NSString *blockNumber;       // 区块高度
@property (nonatomic, copy)NSString *blockTimestamp;    // 区块时间戳
@end
