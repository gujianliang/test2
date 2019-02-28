//
//  WalletChooseNetworkView.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "WalletChooseNetworkView.h"
#import "WalletSdkMacro.h"

@implementation WalletChooseNetworkView
{
    NSMutableArray *_newList;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = UIColor.clearColor;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [bgView setAlpha:0.4];
    bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
    [bgView addGestureRecognizer:tap];
    [tap setNumberOfTapsRequired:1];
    
    
    UIView *chooseNetworkCotainView = [[UIView alloc] init];
    chooseNetworkCotainView.backgroundColor = UIColor.whiteColor;
    [self addSubview:chooseNetworkCotainView];
    
    NSArray *netList = [[NSUserDefaults standardUserDefaults] objectForKey:@"netList"];
    _newList = [NSMutableArray array];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setObject:@"Product Network" forKey:@"serverName"];
    [dict1 setObject:Main_BlockHost forKey:@"serverUrl"];
    [_newList addObject:dict1];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:@"Develop Network" forKey:@"serverName"];
    [dict2 setObject:Test_BlockHost forKey:@"serverUrl"];
    [_newList addObject:dict2];

    if (netList.count > 0) {
        [_newList addObjectsFromArray:netList];
    }
    
    if (_newList.count >= 6) {
        chooseNetworkCotainView.frame = CGRectMake(self.frame.size.width - 200, 80, 180, 50 * 6 + 10 + 50);
        
    }else {
        chooseNetworkCotainView.frame = CGRectMake(self.frame.size.width - 200, 80, 180, 50 * _newList.count + 10 + 50);
    }
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:chooseNetworkCotainView.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [chooseNetworkCotainView addSubview:tableView];
    
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 50)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(15, 0, 165, 50);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitle:@"Add Network" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addNetwork) forControlEvents:UIControlEventTouchUpInside];
    [footV addSubview:btn];
    tableView.tableFooterView = footV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _newList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndef = @"cellIndef";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndef];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndef];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(15, 49, 165, 1.0)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:line];
    }
    NSDictionary *dict = _newList[indexPath.row];
    cell.textLabel.text = dict[@"serverName"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = _newList[indexPath.row];
    NSString *serverName = dict[@"serverName"];
    NSString *serverUrl = dict[@"serverUrl"];
    
    if (_block) {
        _block(serverName, serverUrl);
    }
    
    if (serverUrl.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"CurrentNet"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self removeFromSuperview];
}

- (void)addNetwork{
    
    if (_block) {
        _block(@"Custom", @"");
    }
    
    [self removeFromSuperview];
}

@end
