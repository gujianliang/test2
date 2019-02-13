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
    
    // 移除旧的渐变色
    [self.gradientLayer removeFromSuperlayer];
    
    // 添加新的渐变色
    NSArray *colorsArr = nil;
    switch (type) {
        case lowBlueType:    // 深灰--》淡灰
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#BDCEFC"].CGColor,  // 深灰
                          (__bridge id)[UIColor colorWithHexString:@"#CBC3FD"].CGColor,  // 浅灰
                          ];
            break;
            
        case highBlueType:  // 蓝色--》紫色
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#618BFD"].CGColor,  // 蓝色
                          (__bridge id)[UIColor colorWithHexString:@"#8570FE"].CGColor,  // 紫色
                          ];
            break;
            
        case lowYellowType:  // 浅黄--》浅黄
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#F7DA9B"].CGColor,  // 浅黄
                          (__bridge id)[UIColor colorWithHexString:@"#F7DA9B"].CGColor,  // 浅黄
                          ];
            break;
            
        case highYellowType: // 深黄--》浅黄
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#FFAE03"].CGColor,  // 深灰
                          (__bridge id)[UIColor colorWithHexString:@"#FFC240"].CGColor,  // 浅灰
                          ];
            break;
          
        case PurpleType:    // 浅紫--》深紫
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#7374A6"].CGColor,  // 浅紫色
                          (__bridge id)[UIColor colorWithHexString:@"#3F406D"].CGColor,  // 深紫色
                          ];
            break;
            
        case cyanType:    // 青色--》青色
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#6BDBF3"].CGColor,  // 青色
                          (__bridge id)[UIColor colorWithHexString:@"#6BDBF3"].CGColor,  // 青色
                          ];
            break;
            
        case bgBlueType:    // 彩蓝--》彩紫
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#53A6EE"].CGColor,  // 青色
                          (__bridge id)[UIColor colorWithHexString:@"#AC6BCA"].CGColor,  // 青色
                          ];
            break;
            
        case bgWhiteType:    // 白色--》白色
            colorsArr = @[
                          (__bridge id)[UIColor whiteColor].CGColor,  // 白色
                          (__bridge id)[UIColor whiteColor].CGColor,  // 白色
                          ];
            break;
            
        default:        // 深灰--》淡灰
            
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            colorsArr = @[
                          (__bridge id)[UIColor colorWithHexString:@"#BDCEFC"].CGColor,  // 深灰
                          (__bridge id)[UIColor colorWithHexString:@"#CBC3FD"].CGColor,  // 浅灰
                          ];
            break;
    }
    
    //初始化渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    [self.layer insertSublayer:gradientLayer atIndex:0];
    self.gradientLayer = gradientLayer;
    
    //设置渐变颜色方向:从左往右---》
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    //设定颜色组
    gradientLayer.colors = colorsArr;
    
    //设定颜色分割点
    gradientLayer.locations = @[@(0.3f), @(1.0f)];
}

- (void)setDisableGradientLayer:(BOOL)isEnable {
    
    _type = (isEnable) ? highBlueType : lowBlueType;
    
    [self setGrayGradientLayerType:_type];
    
    [self setUserInteractionEnabled:isEnable];
}

@end
