//
//  SocketRocketUtility.h
//  SUN
//
//  Created by shunjun on 17/2/16.
//  Copyright © 2017年 SUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"


extern NSString * const kNeedPayOrderNote;
extern NSString * const kWebSocketDidOpenNote;
extern NSString * const kWebSocketDidCloseNote;
extern NSString * const kWebSocketdidReceiveMessageNote;

@interface SocketRocketUtility : NSObject


@property (nonatomic,assign,readonly) SRReadyState socketReadyState;


- (void)SRWebSocketOpenWithURLString:(NSString *)urlString;


- (void)SRWebSocketClose;


- (void)sendData:(id)data;

+ (SocketRocketUtility *)instance;


@property (nonatomic,copy) NSArray *requestIdList;
@property (nonatomic,copy) NSString *callbackId;

@end
