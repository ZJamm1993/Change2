//
//  DownloadedController.m
//  change2app
//
//  Created by jam on 17/4/12.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "DownloadedController.h"
#import "Masonry.h"
#import "CacheTool.h"
#import "FileTool.h"
#import "BaseCell.h"
#import "VideoDetailController.h"

@interface DownloadedController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _dataSource;
}
@end

@implementation DownloadedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"缓存";
    
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
    
    UIBarButtonItem* continueItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"download"] style:UIBarButtonItemStylePlain target:self action:@selector(resumeAllDownload)];
    self.navigationItem.rightBarButtonItem=continueItem;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadProgressNotification:) name:FILE_DOWNLOAD_PROCESS_NOTIFICATION object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCache];
}

-(void)loadCache
{
    NSDictionary* cache=[CacheTool dictionaryWithCacheForKey:DOWNLOAD_VIDEO_KEY];
    NSArray* videos=[cache valueForKey:@"videos"];
    [_dataSource removeAllObjects];
    for (NSDictionary* vid in videos) {
        VideoObject* vo=[VideoObject objectWithDictionary:vid];//[[VideoObject alloc]initWithDictionary:vid];
        DownLoadProgress* pro=[[DownLoadProgress alloc]init];
        pro.finished=NO;
        pro.totalData=1;
        pro.completedData=0;
        pro.url=vo.url;
        vo.progress=pro;
        if(![[FileTool sharedInstancetype]existDownloadedUrl:vo.url])
        {
//            [[FileTool sharedInstancetype]downloadVideo:vo];
        }
        else
        {
            pro.finished=YES;
        }
        [_dataSource addObject:vo];
    }
    if (_dataSource.count>0) {
        [_tableView reloadData];
    }
}

-(void)resumeAllDownload
{
    for (VideoObject* video in _dataSource) {
        [[FileTool sharedInstancetype]downloadVideo:video];
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
        VideoObject* vi=[_dataSource objectAtIndex:indexPath.row];
        [_dataSource removeObjectAtIndex:indexPath.row];
        [[FileTool sharedInstancetype]deleteVideo:vi];
        NSMutableArray* newVideos=[NSMutableArray array];
        for (VideoObject* vb in _dataSource) {
            [newVideos addObject:vb.dictionary];
        }
        NSDictionary* newCache=[NSDictionary dictionaryWithObject:newVideos forKey:@"videos"];
        [CacheTool saveCacheWithDictionary:newCache forKey:DOWNLOAD_VIDEO_KEY];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
    VideoObject* vi=[_dataSource objectAtIndex:indexPath.row];
    BOOL downloaded=[[FileTool sharedInstancetype]existDownloadedUrl:vi.url];
    
    UITableViewRowAction* savve=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"保存至相册" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[FileTool sharedInstancetype]saveVideo:vi];
//        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        tableView.editing=NO;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"已保存" message:[NSString stringWithFormat:@"已保存\"%@\"",vi.name] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
    savve.backgroundColor=[UIColor orangeColor];
    
    UITableViewRowAction* delet=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [_dataSource removeObjectAtIndex:indexPath.row];
        [[FileTool sharedInstancetype]deleteVideo:vi];
        NSMutableArray* newVideos=[NSMutableArray array];
        for (VideoObject* vb in _dataSource) {
            [newVideos addObject:vb.dictionary];
        }
        NSDictionary* newCache=[NSDictionary dictionaryWithObject:newVideos forKey:@"videos"];
        [CacheTool saveCacheWithDictionary:newCache forKey:DOWNLOAD_VIDEO_KEY];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    delet.backgroundColor=[UIColor redColor];
    
//    UITableViewRowAction* test=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"yrdy" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        
//    }];
//    test.backgroundColor=[UIColor greenColor];
    
    NSMutableArray* array=[NSMutableArray array];
    [array addObject:delet];
//    [array addObject:test];
    if(downloaded)
    {
        [array addObject:savve];
    }
    return array;
}

-(void)downloadProgressNotification:(NSNotification*)notification
{
    NSDictionary* user=notification.userInfo;
    DownLoadProgress* pro=[user valueForKey:@"progress"];
    for (VideoObject* video in _dataSource) {
        if([video.url isEqualToString:pro.url])
        {
            video.progress=pro;
            NSArray* showingCells=[_tableView visibleCells];
            for (UITableViewCell* cell in showingCells) {
                if ([cell isKindOfClass:[BaseCell class]]) {
                    BaseCell* bc=(BaseCell*)cell;
                    if (bc.video.id_==video.id_) {
                        bc.video=video;
                    }
                }
            }
        }
    }
}

@end
