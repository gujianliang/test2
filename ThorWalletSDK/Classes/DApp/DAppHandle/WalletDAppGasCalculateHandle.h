//
//  WalletDAppGasCalculateHandle.h
//  AFNetworking
//
//  Created by 曾新 on 2019/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppGasCalculateHandle : NSObject

+ (int)getGas:(NSArray *)clauseList;

@end

NS_ASSUME_NONNULL_END
