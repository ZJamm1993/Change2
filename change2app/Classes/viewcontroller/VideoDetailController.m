//
//  VideoDetailController.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "VideoDetailController.h"
#import "SmallCell.h"
#import "VideoPreviewCell.h"
#import "Masonry.h"
#import "PlayerController.h"

@interface VideoDetailController()<VideoPreviewDelegate>

@end

@implementation VideoDetailController
{
    VideoPreviewCell* cell000;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    cell000=[[VideoPreviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"a"];
    cell000.video=self.video;
    
    self.page=0;
    self.title=@"";
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight=90;
    self.url=[ApiTool videoRelatedJSON:self.video.id_];
    [self.refreshControl removeFromSuperview];
//    [self.navigationController setNavigationBarHidden:YES];
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if (self.dataSource.count==0) {
//        [self loadMore];
//    }
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else{
        return self.dataSource.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8)
            return UITableViewAutomaticDimension;
        else
        {
            
        }
//        cell00.video=self.video;
//        return [cell00.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        UITableViewCell* cell=cell000;
        CGFloat hei=[cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+1;
        NSLog(@"hei:%f",hei);
        return hei;
//        return 500;
    }
    else
    {
        return 90;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        NSString* idd=@"videopreviewcell";
        VideoPreviewCell* cell=[tableView dequeueReusableCellWithIdentifier:idd];
        if (cell==nil) {
            cell=[[VideoPreviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idd];
            cell.delegate=self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.video=self.video;
        return cell;
    }
    else
    {
        NSString* idd=@"smallcell";
        SmallCell* cell=[tableView dequeueReusableCellWithIdentifier:idd];
        if (cell==nil) {
            cell=[[SmallCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idd];
        }
        VideoObject* video=[self.dataSource objectAtIndex:indexPath.row];
        cell.video=video;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return;
    }
    NSInteger row=indexPath.row;
    NSInteger rowss=[tableView numberOfRowsInSection:indexPath.section];
    if (row>=rowss-1) {
        //显示最后一行就加载更多
        [self loadMore];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

-(void)refreshNew
{
    [self loadMore];
}

-(void)videoPreviewShouldPlayVideo
{
    PlayerController* play=[[PlayerController alloc]init];
    play.url=self.video.url;
    [self presentMoviePlayerViewControllerAnimated:play];
}

@end
