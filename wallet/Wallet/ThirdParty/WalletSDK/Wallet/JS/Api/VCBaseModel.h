//
//  VCBaseModel.h
//  Wallet
//
//  Created by 曾新 on 18/4/7.
//  Copyright © VECHAIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface VCBaseModel : NSObject <NSCoding,NSCopying>

//custom key mapper
+(NSDictionary *)modelCustomPropertyMapper;

+ (NSDictionary *)modelContainerPropertyGenericClass;

@end
