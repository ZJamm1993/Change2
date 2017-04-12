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
    NSInteger descriptionNumberOfLines;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.page=0;
    self.title=@"";
    
    descriptionNumberOfLines=2;
    
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight=90;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.url=[ApiTool videoRelatedJSON:self.video.id_];
    [self.refreshControl removeFromSuperview];
//    [self.navigationController setNavigationBarHidden:YES];
    
    UIBarButtonItem* shareItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    UIBarButtonItem* collectItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"like"] style:UIBarButtonItemStylePlain target:self action:@selector(collect)];
    UIBarButtonItem* downloadItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"download"] style:UIBarButtonItemStylePlain target:self action:@selector(download)];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:shareItem, collectItem, downloadItem, nil];
}

-(void)download
{
    
}

-(void)collect
{
    
}

-(void)share
{
    
}

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
        
        UITableViewCell* cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
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
        cell.descriptionNumberOfLines=descriptionNumberOfLines;
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

-(void)videoPreviewShouldReloadHeight
{
    if (descriptionNumberOfLines==0) {
        descriptionNumberOfLines=2;
    }
    else
    {
        descriptionNumberOfLines=0;
    }
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView reloadData];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

@end
