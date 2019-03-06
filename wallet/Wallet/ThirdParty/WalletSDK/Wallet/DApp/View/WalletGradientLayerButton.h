//
//  WalletGradientLayerButton.h
//  VeWallet
//
//  Created by  VechainIOS on 2018/5/23.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    lowBlueType = 0,         // 深灰--》淡灰
    
    highBlueType = 1,        // 蓝色--》紫色
    
    lowYellowType = 2,       // 浅黄--》浅黄
    
    highYellowType = 3,      // 深黄--》浅黄
    
    PurpleType = 4,          // 浅紫--》深紫
    
    cyanType = 5,            // 青色--》青色
    
    bgBlueType = 6,          // 彩蓝--》彩紫
    
    bgWhiteType = 7,          // 白色--》白色
    
}GradientLayerType;

@interface WalletGradientLayerButton : UIButton

/* isEnable
YES: 蓝色---紫色
NO: 浅灰色---浅白色
 */
- (void)setGrayGradientLayerType:(GradientLayerType)type;
- (void)setDisableGradientLayer:(BOOL)isEnable;

@end
