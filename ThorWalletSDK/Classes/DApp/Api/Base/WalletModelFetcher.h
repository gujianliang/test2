//
//  WalletModelFetcher.h
//  Wallet
//
//  Created by Tom on 18/4/7.
//  Copyright © VECHAIN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^responseBlock)(NSDictionary *responseDict, NSDictionary *responseHeaderFields,NSError *error);

@interface WalletModelFetcher : NSObject

+ (void)requestGetWithUrl:(NSString*)aUrl
                   params:(NSMutableDictionary*)dict
            responseBlock:(responseBlock)block;

+ (void)requestPostWithUrl:(NSString*)aUrl
                    params:(NSMutableDictionary*)dict
             responseBlock:(responseBlock)block;

@end
