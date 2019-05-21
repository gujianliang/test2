//
//  WalletGradientLayerButton.m
//  VeWallet
//
//  Created by  VechainIOS on 2018/5/23.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletGradientLayerButton.h"

@interface WalletGradientLayerButton ()
{
    GradientLayerType _type;
}
@property (weak, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation WalletGradientLayerButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setGrayGradientLayerType: _type];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setGrayGradientLayerType: _type];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self setGrayGradientLayerType: _type];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.gradientLayer.frame = self.bounds;
}

- (void)setGrayGradientLayerType:(GradientLayerType)type {
    
    _type = type;
    
    // Remove old gradients
    [self.gradientLayer removeFromSuperlayer];
    
    // Add a new gradient
    NSArray *colorsArr = nil;
    switch (type) {
        case lowBlueType:    // Dark gray--light gray
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#BDCEFC"].CGColor,  // Dark gray
                          (__bridge id)[UIColor colorWithHexString:@"#CBC3FD"].CGColor,  // Light gray
                          ];
            break;
            
        case highBlueType:  //Blue -- Purple
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#618BFD"].CGColor,  // blue
                          (__bridge id)[UIColor colorWithHexString:@"#8570FE"].CGColor,  // purple
                          ];
            break;
            
        case lowYellowType:  // Light yellow -- light yellow
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#F7DA9B"].CGColor,  //  Light yellow
                          (__bridge id)[UIColor colorWithHexString:@"#F7DA9B"].CGColor,  //  Light yellow
                          ];
            break;
            
        case highYellowType: // Dark yellow -- light yellow
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#FFAE03"].CGColor,  // Dark gray
                          (__bridge id)[UIColor colorWithHexString:@"#FFC240"].CGColor,  // Light gray
                          ];
            break;
          
        case PurpleType:    // Light purple -- deep purple
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#7374A6"].CGColor,  // Light purple
                          (__bridge id)[UIColor colorWithHexString:@"#3F406D"].CGColor,  // Dark purple
                          ];
            break;
            
        case cyanType:    // Cyan -- Cyan
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#6BDBF3"].CGColor,  // blue
                          (__bridge id)[UIColor colorWithHexString:@"#6BDBF3"].CGColor,  // blue
                          ];
            break;
            
        case bgBlueType:    // Color blue -- Color purple
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#53A6EE"].CGColor,  // blue
                          (__bridge id)[UIColor colorWithHexString:@"#AC6BCA"].CGColor,  // blue
                          ];
            break;
            
        case bgWhiteType:    // white
            colorsArr = @[
                          (__bridge id)[UIColor whiteColor].CGColor,  // white
                          (__bridge id)[UIColor whiteColor].CGColor,  // white
                          ];
            break;
            
        default:        // Dark gray -- light gray
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#BDCEFC"].CGColor,  // Dark gray
                          (__bridge id)[UIColor colorWithHexString:@"#CBC3FD"].CGColor,  // light gray
                          ];
            break;
    }
    
    // Initialize the gradient layer
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    [self.layer insertSublayer:gradientLayer atIndex:0];
    self.gradientLayer = gradientLayer;
    
    //Set the gradient color direction: from left to right
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    //Set color group
    gradientLayer.colors = colorsArr;
    
    //Set color split point
    gradientLayer.locations = @[@(0.3f), @(1.0f)];
}

- (void)setDisableGradientLayer:(BOOL)isEnable {
    
    _type = (isEnable) ? highBlueType : lowBlueType;
    
    [self setGrayGradientLayerType:_type];
    
    [self setUserInteractionEnabled:isEnable];
}

@end
