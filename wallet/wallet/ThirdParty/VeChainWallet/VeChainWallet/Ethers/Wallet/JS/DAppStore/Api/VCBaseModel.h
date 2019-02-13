//
//  VCBaseModel.h
//  Wallet
//
//  Created by 曾新 on 16/4/7.
//  Copyright © 2016年 Eagle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface VCBaseModel : NSObject <NSCoding,NSCopying>

//custom key mapper
+(NSDictionary *)modelCustomPropertyMapper;

+ (NSDictionary *)modelContainerPropertyGenericClass;

@end
