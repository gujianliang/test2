//
//  WalletChooseNetworkView.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "WalletChooseNetworkView.h"
#import "WalletSdkMacro.h"


@interface WalletChooseNetworkView()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_newList;    /* It is used to save all the network environment */
}
@end


@implementation WalletChooseNetworkView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


/**
*  Config subviews and load it.
*/
- (void)initView{
    
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
    
    NSArray *netList = [[NSUserDefaults standardUserDefaults] objectForKey:@"nodeList"];
    _newList = [NSMutableArray array];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setObject:@"Main Node" forKey:@"nodeName"];
    [dict1 setObject:Main_Node forKey:@"nodeUrl"];
    [_newList addObject:dict1];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:@"Test Node" forKey:@"nodeName"];
    [dict2 setObject:Test_Node forKey:@"nodeUrl"];
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
    [btn setTitle:@"Add Node" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addNetwork) forControlEvents:UIControlEventTouchUpInside];
    [footV addSubview:btn];
    tableView.tableFooterView = footV;
}


#pragma mark -- UITableViewDataSource, UITableViewDelegate
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
    cell.textLabel.text = dict[@"nodeName"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = _newList[indexPath.row];
    NSString *serverName = dict[@"nodeName"];
    NSString *serverUrl = dict[@"nodeUrl"];
    
    if (_block) {
        _block(serverName, serverUrl);
    }
    
    if (serverUrl.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"CurrentNode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self removeFromSuperview];
}


/**
*  When you click the foot View will call this method.
*/
- (void)addNetwork{
    
    if (_block) {
        _block(@"Custom", @"");
    }
    
    [self removeFromSuperview];
}


@end
