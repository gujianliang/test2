//
//  WalletChooseNetworkView.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "WalletChooseNetworkView.h"


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
    chooseNetworkCotainView.frame = CGRectMake(self.frame.size.width - 200, 80, 180, 150);
    chooseNetworkCotainView.backgroundColor = UIColor.whiteColor;
    [self addSubview:chooseNetworkCotainView];
    
    NSArray *netList = [[NSUserDefaults standardUserDefaults] objectForKey:@"netList"];
    _newList = [NSMutableArray array];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setObject:@"Product Network" forKey:@"serverName"];
    [dict1 setObject:@"https://vethor-node.vechain.com" forKey:@"serverUrl"];
    [_newList addObject:dict1];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:@"Develop Network" forKey:@"serverName"];
    [dict2 setObject:@"https://vethor-node-test.vechaindev.com" forKey:@"serverUrl"];
    [_newList addObject:dict2];

    if (netList.count > 0) {
        [_newList addObjectsFromArray:netList];
    }
    
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    [dict3 setObject:@"Custom Network" forKey:@"serverName"];
    [dict3 setObject:@"" forKey:@"serverUrl"];
    [_newList addObject:dict3];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:chooseNetworkCotainView.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [chooseNetworkCotainView addSubview:tableView];
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
    if (_block) {
        _block(dict[@"serverName"], dict[@"serverUrl"]);
    }
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"CurrentNet"];
    [self removeFromSuperview];
}

@end
