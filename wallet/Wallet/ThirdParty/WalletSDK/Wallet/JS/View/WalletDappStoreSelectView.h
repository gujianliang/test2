//
//  WalletDappStoreSelectView.h
//  VeWallet
//
//  Created by 曾新 on 2019/1/20.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletDappStoreSelectView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy) void(^block)(NSString *from,WalletDappStoreSelectView *viewSelf);
@property(nonatomic,copy) NSString *amount;
@property(nonatomic,copy) NSString *toAddress;

@end

NS_ASSUME_NONNULL_END
