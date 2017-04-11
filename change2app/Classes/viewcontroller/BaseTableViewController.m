//
//  BaseTableViewController.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "BaseTableViewController.h"
#import "VideoDetailController.h"

#define MY_PAGE_KEY @"page"
#define MY_PER_PAGE_KEY @"per_page"

@interface BaseTableViewController()

@end

@implementation BaseTableViewController
{
}

-(instancetype)init
{
    self=[super init];
    if (self) {
        
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _usingPage=YES;
    _url=[ApiTool videoJSON];
    _page=1;
    _per_page=20;
    
    _params=[NSMutableDictionary dictionary];
    _dataSource=[NSMutableArray array];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.rowHeight=160;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    _refreshControl=[[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refreshNew) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_dataSource.count==0) {
        [self refreshNew];
    }
}

-(void)refreshNew
{
    [_params setValue:[NSNumber numberWithInteger:1] forKey:MY_PAGE_KEY];
    [_params setValue:[NSNumber numberWithInteger:_per_page] forKey:MY_PER_PAGE_KEY];
    [HttpTool get:_url params:_usingPage?[NSDictionary dictionaryWithDictionary:_params]:nil success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        _page=1;
        [self didRefreshWithDictionary:responseObject];
        [_tableView reloadData];
        [_refreshControl endRefreshing];
    } failure:^(NSError *error) {
//        NSLog(@"%@",error.description);
    }];
}

-(void)loadMore
{
    if (_usingPage) {
        [_params setValue:[NSNumber numberWithInteger:_page+1] forKey:MY_PAGE_KEY];
        [_params setValue:[NSNumber numberWithInteger:_per_page] forKey:MY_PER_PAGE_KEY];
        [HttpTool get:_url params:_usingPage?[NSDictionary dictionaryWithDictionary:_params]:nil success:^(id responseObject) {
//            NSLog(@"%@",responseObject);
            _page++;
            [self didLoadMoreWithDictionary:responseObject];
            [_tableView reloadData];
        } failure:^(NSError *error) {
//            NSLog(@"%@",error.description);
        }];
    }
}

-(void)didRefreshWithDictionary:(NSDictionary *)dictionary
{
    [_dataSource removeAllObjects];
    [self buildDataSourceWithDictionary:dictionary];
}

-(void)didLoadMoreWithDictionary:(NSDictionary *)dictionary
{
    [self buildDataSourceWithDictionary:dictionary];
}

-(void)buildDataSourceWithDictionary:(NSDictionary*)dictionary
{
    NSArray* videos=[dictionary valueForKey:@"videos"];
    for (NSDictionary* vid in videos) {
        VideoObject* vo=[[VideoObject alloc]initWithDictionary:vid];
        [_dataSource addObject:vo];
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    NSInteger rowss=[tableView numberOfRowsInSection:indexPath.section];
    if (row>=rowss-1) {
        //显示最后一行就加载更多
        [self loadMore];
    }
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoObject* video=[_dataSource objectAtIndex:indexPath.row];
    VideoDetailController* detail=[[VideoDetailController alloc]init];
    detail.video=video;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
