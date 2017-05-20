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
#import "FileTool.h"
#import "CollectionTool.h"
#import "ShareTool.h"
#import "UIImageView+WebCache.h"

@interface VideoDetailController()<VideoPreviewDelegate,UIActionSheetDelegate>

@end

@implementation VideoDetailController
{
    NSInteger descriptionNumberOfLines;
    BOOL isDownLoaded;
    BOOL isCollected;
    UIImageView* thumbImageView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"video:\n%@",self.video.dictionary);
    
    self.page=0;
    self.title=@"";
    
    descriptionNumberOfLines=2;
    
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight=90;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.url=[ApiTool videoRelatedJSON:self.video.id_];
    [self.refreshControl removeFromSuperview];
    
    thumbImageView=[[UIImageView alloc]init];
    [thumbImageView sd_setImageWithURL:[NSURL URLWithString:self.video.poster]];
    
    UIBarButtonItem* shareItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    UIBarButtonItem* collectItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"like"] style:UIBarButtonItemStylePlain target:self action:@selector(collect)];
    UIBarButtonItem* downloadItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"download"] style:UIBarButtonItemStylePlain target:self action:@selector(download)];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:shareItem, collectItem, downloadItem, nil];
    
    if ([[FileTool sharedInstancetype]existDownloadedUrl:self.video.url]) {
        [self setIsDownLoaded];
    }
    if ([CollectionTool hasCollectedVideo:self.video]) {
        [self setIsCollected];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadProgressNotification:) name:FILE_DOWNLOAD_PROCESS_NOTIFICATION object:nil];
    
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setIsDownLoaded
{
    isDownLoaded=YES;
    UIBarButtonItem* dow=self.navigationItem.rightBarButtonItems.lastObject;
    dow.image=nil;
    dow.title=@"已缓存";
    dow.enabled=NO;
}

-(void)setIsCollected
{
    if(isCollected==NO)
    {
        isCollected=YES;
        UIBarButtonItem* coll=[self.navigationItem.rightBarButtonItems objectAtIndex:1];
        coll.image=[[UIImage imageNamed:@"liked"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        isCollected=NO;
        UIBarButtonItem* coll=[self.navigationItem.rightBarButtonItems objectAtIndex:1];
        coll.image=[UIImage imageNamed:@"like"];
    }
}

-(void)downloadProgressNotification:(NSNotification*)notification
{
    NSDictionary* user=notification.userInfo;
    DownLoadProgress* pro=[user valueForKey:@"progress"];
    if ([pro.url isEqualToString:self.video.url]) {
//        statements
        
        if (pro.finished==NO) {
            if (pro.totalData!=0) {
                CGFloat per=((CGFloat)pro.completedData)/((CGFloat)pro.totalData)*100;
                long perp=(long)per;
                if (!isDownLoaded) {
                    UIBarButtonItem* dow=self.navigationItem.rightBarButtonItems.lastObject;
                    dow.image=nil;
                    dow.title=[NSString stringWithFormat:@"%ld%%",(long)perp];
//                    NSLog(@"%@",[NSThread currentThread]);
                }
            }
        }
        else
        {
            [self setIsDownLoaded];
        }
    }
}

-(void)download
{
    if (!isDownLoaded) {
        [[FileTool sharedInstancetype]downloadVideo:self.video];
    }
}

-(void)collect
{
    if (isCollected) {
        [CollectionTool deleteCollectionVideo:self.video];
    }
    else
    {
        [CollectionTool collectVideo:self.video];
    }
    [self setIsCollected];
}

-(void)share
{
    UIActionSheet* sheet=[[UIActionSheet alloc]initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"微信朋友圈",@"复制分享链接",@"Safari打开", nil];
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //@"微信好友",@"微信朋友圈",@"复制链接",@"Safari打开",
    NSString* sharedUrl=self.video.share_url;
    
    NSLog(@"%d",(int)buttonIndex);
    if (buttonIndex==0) {
        [[ShareTool alloc]shareWeChatWithUrl:sharedUrl title:self.video.name description:self.video.desc thumbImage:thumbImageView.image scene:WXSceneSession];
    }
    else if(buttonIndex==1)
    {
        [[ShareTool alloc]shareWeChatWithUrl:sharedUrl title:self.video.name description:self.video.desc thumbImage:thumbImageView.image scene:WXSceneTimeline];
    }
    else if(buttonIndex==2)
    {
        [[UIPasteboard generalPasteboard]setString:sharedUrl];
    }
    else if(buttonIndex==3)
    {
        NSURL* url=[NSURL URLWithString:sharedUrl];
        [[UIApplication sharedApplication]openURL:url];
    }
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
//        if([[[UIDevice currentDevice]systemVersion]floatValue]>=8)
//            return UITableViewAutomaticDimension;
//        else
//        {
//            
//        }
//        cell00.video=self.video;
//        return [cell00.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        UITableViewCell* cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        CGFloat hei=[cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+1;
        NSLog(@"hei:%f",hei);
        return hei;
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
    if (isDownLoaded) {
        play.url=[[FileTool sharedInstancetype]filePathWithDownloadedUrl:self.video.url];
        play.isLocal=YES;
    }
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
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView beginUpdates];
//    [self.tableView endUpdates];
    [self.tableView reloadData];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

@end
