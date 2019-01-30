//
//  WalletExchangeStatusCell.h
//  VeWallet
//
//  Created by 曾新 on 2018/10/8.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletManageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletExchangeWalletCell : UITableViewCell

@property (strong, nonatomic) WalletManageModel *model;

- (void)setModel:(WalletManageModel *)model amount:(NSString *)amount;

- (instancetype)initWithTable:(UITableView *)table;

@end

NS_ASSUME_NONNULL_END
