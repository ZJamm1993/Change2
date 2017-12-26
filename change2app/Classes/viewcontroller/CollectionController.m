//
//  CollectionController.m
//  change2app
//
//  Created by jam on 17/4/12.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "CollectionController.h"
#import "Masonry.h"
#import "CacheTool.h"
#import "BaseCell.h"
#import "CollectionTool.h"
#import "VideoDetailController.h"

@interface CollectionController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataSource;
}
@end

@implementation CollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"收藏";
    
    _dataSource=[NSMutableArray array];
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.rowHeight=160;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCache];
}

-(void)loadCache
{
    NSDictionary* cache=[CollectionTool collectionVideos];
    NSArray* videos=[cache valueForKey:@"videos"];
    [_dataSource removeAllObjects];
    for (NSDictionary* vid in videos) {
        VideoObject* vo=[VideoObject objectWithDictionary:vid];//[[VideoObject alloc]initWithDictionary:vid];
        [_dataSource addObject:vo];
    }
    if (_dataSource.count>0) {
        [_tableView reloadData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* idd=@"basecell";
    BaseCell* cell=[tableView dequeueReusableCellWithIdentifier:idd];
    if (cell==nil) {
        cell=[[BaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idd];
    }
    VideoObject* video=[_dataSource objectAtIndex:indexPath.row];
    cell.video=video;
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoObject* video=[_dataSource objectAtIndex:indexPath.row];
    VideoDetailController* detail=[[VideoDetailController alloc]init];
    detail.video=video;
    [self.navigationController pushViewController:detail animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        VideoObject* deleVideo=[_dataSource objectAtIndex:indexPath.row];
        [_dataSource removeObjectAtIndex:indexPath.row];
        [CollectionTool deleteCollectionVideo:deleVideo];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
