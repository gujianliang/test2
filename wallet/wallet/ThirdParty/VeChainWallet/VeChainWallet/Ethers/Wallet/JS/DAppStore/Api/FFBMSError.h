//
//  FFBMSError.h
//  FFBMS
//
//  Created by 曾新 on 16/4/7.
//  Copyright © 2016年 Eagle. All rights reserved.
//

#ifndef FFBMSError_h
#define FFBMSError_h

#define kFFBMSErrorDomain                     @"FFBMS"

#define FFBMS_ERROR_INVALID_DATA_FORMAT       40001


#define FFBMS_ERROR_ASIHTTP                   999

#define FFBMS_ERROR_OK                        1

#define FFBMS_TOKEN_OUT                       400001

#define FFBMS_APP_UPDATE                      42600
//#define FFBMS_APP_UPDATE                      42601

#define FFBMS_MSG_DEFAULT                     VCNSLocalizedBundleString(@"Unknown error", nil)
#define FFBMS_MSG_INVALID_DATA_FORMAT         VCNSLocalizedBundleString(@"数据格式错误", nil)
#define FFBMS_MSG_ASIHTTP                     VCNSLocalizedBundleString(@"no_network_hint", nil)

#endif /* FFBMSError_h */
