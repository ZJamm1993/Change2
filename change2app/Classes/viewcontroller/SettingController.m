//
//  SettingController.m
//  change2app
//
//  Created by jam on 17/4/12.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "SettingController.h"
#import "FileTool.h"
#import "Masonry.h"

@interface SettingController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView* _tableView;
    NSString* cacheDetailString;
}
@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    self.view.backgroundColor=[UIColor whiteColor];
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=66;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshCache];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* idd=@"profilecell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:idd];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idd];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text=@"清除缓存";
    cell.detailTextLabel.text=cacheDetailString;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==0)
    {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"删除缓存" message:@"将会删除所有已下载的视频和图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self clearCache];
    }
}

-(void)refreshCache
{
    double size=[[FileTool sharedInstancetype]cacheFilesSize];
    cacheDetailString=[NSString stringWithFormat:@"%.2f MB",size];
    [_tableView reloadData];
}

-(void)clearCache
{
    [[FileTool sharedInstancetype]deleteCacheFiles];
    [self refreshCache];
}

@end
