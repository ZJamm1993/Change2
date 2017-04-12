//
//  ProfilePageController.m
//  change2app
//
//  Created by jam on 17/4/12.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "ProfilePageController.h"
#import "CollectionController.h"
#import "DownloadedController.h"
#import "SettingController.h"
#import "Masonry.h"

@interface ProfilePageController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ProfilePageController
{
    UITableView* _tableView;
    NSArray* _controllers;
    NSArray* _texts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的";
    self.view.backgroundColor=[UIColor whiteColor];
    
    _controllers=[NSArray arrayWithObjects:
                  [[CollectionController alloc]init],
                  [[DownloadedController alloc]init],
                  [[SettingController alloc]init], nil];
    _texts=[NSArray arrayWithObjects:@"收藏",@"缓存",@"设置", nil];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=66;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _controllers.count<_texts.count?_controllers.count:_texts.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* idd=@"profilecell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:idd];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idd];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text=[_texts objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[_controllers objectAtIndex:indexPath.row] animated:YES];
}

@end
