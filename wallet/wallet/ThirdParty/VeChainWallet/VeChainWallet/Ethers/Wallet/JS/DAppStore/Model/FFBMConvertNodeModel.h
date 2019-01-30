//
//  FFBMConvertNodeModel.h
//  VeWallet
//
//  Created by HuChao on 2018/10/12.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


// 普通节点模型
@interface FFBMNomelNodeModel : NSObject

@property (strong,  readonly, nonatomic) NSArray *titleList;
@property (strong,  readonly, nonatomic) NSArray *twoBonusNodeList;
@property (strong,  readonly, nonatomic) NSArray *twoGetNodeList;
@property (strong,  readonly, nonatomic) NSArray *needDayList;
@property (strong,  readonly, nonatomic) NSArray *imageList;
@property (strong,  readonly, nonatomic) NSArray *nodeList;

@end


// X节点模型
@interface FFBMXNodeModel : NSObject

@property (strong,  readonly, nonatomic) NSArray *titleListX;
@property (strong,  readonly, nonatomic) NSArray *threeBonusNodeList;
@property (strong,  readonly, nonatomic) NSArray *threeGetNodeList;
@property (strong,  readonly, nonatomic) NSArray *xNeedDayList;
@property (strong,  readonly, nonatomic) NSArray *threeXNodeList;
@property (strong,  readonly, nonatomic) NSArray *imageList;
@property (strong,  readonly, nonatomic) NSArray *nodeList;

@end



@interface FFBMConvertNodeModel : NSObject

@property (copy, nonatomic) NSString *nodeType;         // 节点类型

@property (copy, readonly, nonatomic) NSString *nodeName;         // 节点名称
@property (copy, readonly, nonatomic) NSString *bonusNodeFactor;  // 节点加成     【非 X 节点专用、X节点使用】 第一个系数
@property (copy, readonly, nonatomic) NSString *xNodeFactor;      // X节点加成    【X 节点专用】 第二个系数
@property (copy, readonly, nonatomic) NSString *nodeAmount;       // 节点持币量 带 VET，千分符格式
@property (copy, readonly, nonatomic) NSString *amount;           // 节点持币量 纯数值，不带VET，不带千分符格式
@property (copy, readonly, nonatomic) NSString *nodeImageName;    // 节点图片名
@property (copy, readonly, nonatomic) NSString *needDay;          // 节点时间
@property (copy, readonly, nonatomic) NSString *nodeIndex;        // 节点对应服务端的索引值

//  0: 非节点  1: 力量节点  2: 闪电节点  3: 雷神节点  4: 经济X节点  5: 力量X节点  6: 闪电X节点  7: 雷神X节点

@property (strong, nonatomic) FFBMNomelNodeModel *nomelNodelModel;  // 普通节点模型
@property (strong, nonatomic) FFBMXNodeModel *xnodelModel;          // x节点模型

@end

NS_ASSUME_NONNULL_END
