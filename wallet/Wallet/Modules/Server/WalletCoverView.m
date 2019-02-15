//
//  CoverView.m
//  walletSDKDemo
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 demo. All rights reserved.
//

#import "WalletCoverView.h"


@implementation WalletCoverView
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeFromSuperview)];
    [bgView addGestureRecognizer:tap];
    [tap setNumberOfTapsRequired:1];
    
    
    UIView *coverView = [[UIView alloc]init];
    coverView.frame = CGRectMake(self.frame.size.width - 200, 80, 180, 150);
    coverView.backgroundColor = UIColor.whiteColor;
    [self addSubview:coverView];
    
    NSArray *netList = [[NSUserDefaults standardUserDefaults]objectForKey:@"netList"];
    _newList = [NSMutableArray array];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setObject:@"生产节点" forKey:@"serverName"];
    [dict1 setObject:@"https://vethor-node.vechain.com" forKey:@"serverUrl"];
    [_newList addObject:dict1];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:@"测试节点" forKey:@"serverName"];
    [dict2 setObject:@"https://vethor-node-test.vechaindev.com" forKey:@"serverUrl"];
    [_newList addObject:dict2];

    if (netList.count > 0) {
        [_newList addObjectsFromArray:netList];
    }
    
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    [dict3 setObject:@"添加自定义节点" forKey:@"serverName"];
    [dict3 setObject:@"11" forKey:@"serverUrl"];
    [_newList addObject:dict3];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:coverView.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [coverView addSubview:tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    NSDictionary *dict = _newList[indexPath.row];
    cell.textLabel.text = dict[@"serverName"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NetType netType = TestServer;
    if (indexPath.row == 0) {
        netType = ProductServer;
        
    }else if (indexPath.row == 1)
    {
         netType = TestServer;
    }else if(indexPath.row  == _newList.count - 1)
    {
        netType = CustomServer;
    }
    NSDictionary *dict = _newList[indexPath.row];
    if (_block) {
        _block(dict[@"serverName"],dict[@"serverUrl"]);
    }
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"CurrentNet"];
    [self removeFromSuperview];
}

- (void)selectNode:(UIButton *)sender
{
    NetType netType = TestServer;
    if (sender.tag == 10) {
        netType = ProductServer;
        
       
        
    }else if (sender.tag == 20)
    {
        netType = TestServer;
    }else if (sender.tag == 30)
    {
        netType = CustomServer;
    }
//    if (_block) {
//        _block(netType);
//    }
    [self removeFromSuperview];
}

@end
