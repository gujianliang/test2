//
//  WalletGradientLayerButton.h
//  VeWallet
//
//  Created by  VechainIOS on 2018/5/23.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"

typedef enum {
    lowBlueType = 0,         // Dark gray--light gray
    
    highBlueType = 1,        // Blue -- Purple
    
    lowYellowType = 2,       // Light yellow -- light yellow
    
    highYellowType = 3,      // Dark yellow -- light yellow
    
    PurpleType = 4,          // Light purple -- deep purple
    
    cyanType = 5,            // Cyan -- Cyan
    
    bgBlueType = 6,          // Color blue -- Color purple
    
    bgWhiteType = 7,          // White -- white
    
}GradientLayerType;

@interface WalletGradientLayerButton : UIButton

/* isEnable
YES: Blue -- Purple
NO: Light gray---light white
 */
- (void)setGrayGradientLayerType:(GradientLayerType)type;
- (void)setDisableGradientLayer:(BOOL)isEnable;

@end
