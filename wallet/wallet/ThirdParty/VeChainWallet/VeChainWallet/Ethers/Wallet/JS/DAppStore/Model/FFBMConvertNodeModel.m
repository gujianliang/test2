//
//  FFBMConvertNodeModel.m
//  VeWallet
//
//  Created by HuChao on 2018/10/12.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "FFBMConvertNodeModel.h"


// 普通节点模型
@implementation FFBMNomelNodeModel
- (instancetype)init{
    self = [super init];
    if (self) {
        _titleList = [NSArray arrayWithObjects:NSLocalizedString(@"strength_node", nil),
                                               NSLocalizedString(@"thunder_node", nil),
                                               NSLocalizedString(@"mjolnir_node", nil), nil];
        
        _twoBonusNodeList = [NSArray arrayWithObjects:@"1.0", @"1.5", @"2.0", nil];
        _twoGetNodeList = [NSArray arrayWithObjects:@"1,000,000 VET", @"5,000,000 VET", @"15,000,000 VET", nil];
        _needDayList = [NSArray arrayWithObjects:@"10", @"20", @"30", nil];
        _imageList = [NSArray arrayWithObjects:@"Strength Node" ,@"Thunder Node", @"Mjolnir Node", nil];
        _nodeList = [NSArray arrayWithObjects:@"S", @"T", @"M", nil];
    }
    return self;
}
@end


// X节点模型
@implementation FFBMXNodeModel
- (instancetype)init{
    self = [super init];
    if (self) {
        _titleListX = [NSArray arrayWithObjects:NSLocalizedString(@"vethor_x_node", nil),
                                                NSLocalizedString(@"strength_x_node", nil),
                                                NSLocalizedString(@"thunder_x_node", nil),
                                                NSLocalizedString(@"mjolnir_x_node", nil), nil];
        
        _threeBonusNodeList = [NSArray arrayWithObjects:@"0.0", @"1.0", @"1.5", @"2.0", nil];
        _threeGetNodeList = [NSArray arrayWithObjects:@"600,000 VET", @"1,600,000 VET", @"5,600,000 VET", @"15,600,000 VET", nil];
        _xNeedDayList = [NSArray arrayWithObjects:@"0", @"30", @"60", @"90", nil];
        _threeXNodeList = [NSArray arrayWithObjects:@"0.25", @"1.0", @"1.5", @"2.0", nil];
        _imageList = [NSArray arrayWithObjects:@"VeThor X Node" ,@"Strength X Node", @"Thunder X Node", @"Mjolnir X Node", nil];
        _nodeList = [NSArray arrayWithObjects:@"XV", @"XS", @"XT", @"XM", nil];
    }
    return self;
}
@end



@implementation FFBMConvertNodeModel


- (FFBMNomelNodeModel *)nomelNodelModel{
    if (!_nomelNodelModel) {
        _nomelNodelModel = [[FFBMNomelNodeModel alloc] init];
    }
    
    return _nomelNodelModel;
}

- (FFBMXNodeModel *)xnodelModel{
    if (!_xnodelModel) {
        _xnodelModel = [[FFBMXNodeModel alloc] init];
    }
    
    return _xnodelModel;
}

- (void)setNodeType:(NSString *)nodeType{
    _nodeType = nodeType;
    
    if(nodeType.length <= 1){   // 非 X 节点
        NSArray *titleList = self.nomelNodelModel.titleList;
        NSArray *twoBonusNodeList = self.nomelNodelModel.twoBonusNodeList;
        NSArray *twoGetNodeList = self.nomelNodelModel.twoGetNodeList;
        NSArray *needDayList = self.nomelNodelModel.needDayList;
        NSArray *imageList = self.nomelNodelModel.imageList;
        
        if ([nodeType isEqualToString:@"T"]) {
            _nodeName = titleList[1];               // 节点名称
            _bonusNodeFactor = twoBonusNodeList[1]; // 节点加成
            _nodeAmount = twoGetNodeList[1];        // 节点持币量
            _nodeImageName = imageList[1];          // 节点图标
            _needDay = needDayList[0];              // 锁定时间
            _nodeIndex = @"2";                      // 服务端索引
            
        }else if ([nodeType isEqualToString:@"M"]) {
            _nodeName = titleList[2];               // 节点名称
            _bonusNodeFactor = twoBonusNodeList[2]; // 节点加成
            _nodeAmount = twoGetNodeList[2];        // 节点持币量
            _nodeImageName = imageList[2];          // 节点图标
            _needDay = needDayList[0];              // 锁定时间
            _nodeIndex = @"3";                      // 服务端索引
            
        }else { // S 类型
            _nodeName = titleList[0];               // 节点名称
            _bonusNodeFactor = twoBonusNodeList[0]; // 节点加成
            _nodeAmount = twoGetNodeList[0];        // 节点持币量
            _nodeImageName = imageList[0];          // 节点图标
            _needDay = needDayList[0];              // 锁定时间
            _nodeIndex = @"1";                      // 服务端索引
        }
        
    }else { // x 节点
        NSArray *titleListX = self.xnodelModel.titleListX;
        NSArray *threeBonusNodeList = self.xnodelModel.threeBonusNodeList;
        NSArray *threeGetNodeList = self.xnodelModel.threeGetNodeList;
        NSArray *xNeedDayList = self.xnodelModel.xNeedDayList;
        NSArray *threeXNodeList = self.xnodelModel.threeXNodeList;
        NSArray *imageList = self.xnodelModel.imageList;
        
        if ([nodeType isEqualToString:@"XS"]) {
            _nodeName = titleListX[1];                // 节点名称
            _bonusNodeFactor = threeBonusNodeList[1]; // 节点加成
            _xNodeFactor = threeXNodeList[1];         // X 节点加成
            _nodeAmount = threeGetNodeList[1];        // 节点持币量
            _nodeImageName = imageList[1];            // 节点图标
            _needDay = xNeedDayList[1];               // 锁定时间
            _nodeIndex = @"5";                        // 服务端索引
            
        }else if ([nodeType isEqualToString:@"XT"]) {
            _nodeName = titleListX[2];                // 节点名称
            _bonusNodeFactor = threeBonusNodeList[2]; // 节点加成
            _xNodeFactor = threeXNodeList[2];         // X 节点加成
            _nodeAmount = threeGetNodeList[2];        // 节点持币量
            _nodeImageName = imageList[2];            // 节点图标
            _needDay = xNeedDayList[2];               // 锁定时间
            _nodeIndex = @"6";                        // 服务端索引
            
        }else if ([nodeType isEqualToString:@"XM"]) {
            _nodeName = titleListX[3];                // 节点名称
            _bonusNodeFactor = threeBonusNodeList[3]; // 节点加成
            _xNodeFactor = threeXNodeList[3];         // X 节点加成
            _nodeAmount = threeGetNodeList[3];        // 节点持币量
            _nodeImageName = imageList[3];            // 节点图标
            _needDay = xNeedDayList[3];               // 锁定时间
            _nodeIndex = @"7";                        // 服务端索引
            
        }else { // XV类型
            _nodeName = titleListX[0];                // 节点名称
            _bonusNodeFactor = threeBonusNodeList[0]; // 节点加成
            _xNodeFactor = threeXNodeList[0];         // X 节点加成
            _nodeAmount = threeGetNodeList[0];        // 节点持币量
            _nodeImageName = imageList[0];            // 节点图标
            _needDay = xNeedDayList[0];               // 锁定时间
            _nodeIndex = @"4";                        // 服务端索引
        }
    }
}

- (void)setNodeAmount:(NSString *)nodeAmount {
    _nodeAmount = nodeAmount;
    
    NSString *amount = @"0";
    if ([nodeAmount containsString:@" VET"]) {
        amount = [nodeAmount substringWithRange:NSMakeRange(0, nodeAmount.length - 4)];
        
    }else {
        amount = _nodeAmount;
    }
    
    _amount = [amount stringByReplacingOccurrencesOfString:@"," withString:@""];   // 1200300.12345
}

@end
