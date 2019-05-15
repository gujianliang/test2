//
//  WalletModelFetcher.h
//  Wallet
//
//  Created by 曾新 on 18/4/7.
//  Copyright © VECHAIN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^responseBlock)(NSDictionary *responseDict, NSDictionary *responseHeaderFields,NSError *error);

@interface WalletModelFetcher : NSObject

+ (void)requestGetWithUrl:(NSString*)aUrl
                   params:(NSMutableDictionary*)dict
                    error:(NSError **)error
            responseBlock:(responseBlock)block;

+ (void)requestPostWithUrl:(NSString*)aUrl
                    params:(NSMutableDictionary*)dict
                     error:(NSError **)error
             responseBlock:(responseBlock)block;

@end
