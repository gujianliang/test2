//
//  WalletTools+NodeModel.m
//  VeWallet
//
//  Created by HuChao on 2018/12/28.
//  Copyright © 2018年 VeChain. All rights reserved.
//
#import "WalletConvertNodeModel.h"
#import "WalletTools+NodeModel.h"

@implementation WalletTools (NodeModel)

// type 转节点名称
+ (NSString *)convertXnodeName:(NSString *)nodeType {
    if (nodeType.length > 0) {
        WalletConvertNodeModel *model = [self convertNodeModel:nodeType];
        return model.nodeName;
        
    }else {
        return @"";
    }
}

// type 转节点图片名称
+ (NSString *)convertXnodeImageName:(NSString *)nodeType {
    if (nodeType.length > 0) {
        WalletConvertNodeModel *model = [self convertNodeModel:nodeType];
        return model.nodeImageName;
        
    }else {
        return nil;
    }
}

// type 转节点索引
+(NSString *)numConvertWithType:(NSString *)nodeType {
    if(nodeType.length > 0){
        WalletConvertNodeModel *model = [self convertNodeModel:nodeType];
        return model.nodeIndex;
        
    }else {
        return @"0";
    }
}

// type 转节点模型
+ (WalletConvertNodeModel *)convertNodeModel:(NSString *)type {
    
    NSString *nodeType = type.uppercaseString;
    
    WalletConvertNodeModel *model = [[WalletConvertNodeModel alloc] init];
    model.nodeType = nodeType;        // 节点类型
    
    return model;
}

+ (NSString *)convertIndexModel:(NSInteger )index {
    NSArray *arr = @[@"S", @"T", @"M", @"XV", @"XS", @"XT", @"XM"];
    NSString *nodeType = @"";
    if (index < arr.count) {
        nodeType = arr[index];
    }
    return nodeType;        // 节点类型
}

@end
