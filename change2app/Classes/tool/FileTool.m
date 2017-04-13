//
//  FileTool.m
//  change2app
//
//  Created by jam on 17/4/12.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "FileTool.h"
#import "AFNetworking.h"
#import "CacheTool.h"

#define DOWNLOAD_VIDEO_KEY @"download_video_key"

static FileTool* fileToolInstance;

@implementation FileTool
{
    NSMutableArray<NSURLSessionDownloadTask*>* downloadingFiles;
    NSString* rootPath;
    BOOL shouldPostNotification;
}

+(instancetype)sharedInstancetype
{
    if (fileToolInstance==nil) {
        fileToolInstance=[[FileTool alloc]init];
    }
    return fileToolInstance;
}

-(instancetype)init
{
    self=[super init];
    if (self) {
        downloadingFiles=[NSMutableArray array];
        shouldPostNotification=YES;
    }
    return self;
}

-(NSString*)defaultRootPath
{
    if (rootPath.length==0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dir = [paths objectAtIndex:0];
        rootPath=dir;
    }
    return rootPath;
}

-(BOOL)existFileName:(NSString*)fileName
{
    NSString* fullPath=[self filePathWithName:fileName];
    BOOL exist=[[NSFileManager defaultManager]fileExistsAtPath:fullPath];
    return exist;
}

-(NSString*)filePathWithName:(NSString*)name
{
    NSString* fullPath=[NSString stringWithFormat:@"%@/%@",[self defaultRootPath],name];
    return fullPath;
}

-(NSString*)filePathWithDownloadedUrl:(NSString *)url
{
    NSString* name=[self getNameFromUrlString:url];
    return [self filePathWithName:name];
}

-(BOOL)existDownloadedUrl:(NSString *)url
{
    NSString* name=[self getNameFromUrlString:url];
    return [self existFileName:name];
}

-(void)resumeAllTaskIfNeed
{
    for (NSURLSessionDownloadTask* task in downloadingFiles)
    {
        if (task.state==NSURLSessionTaskStateSuspended) {
            [task resume];
        }
    }
}

-(void)cleanUnavailableTask
{
    NSArray* arr=[NSArray arrayWithArray:downloadingFiles];
    for (NSURLSessionDownloadTask* task in arr)
    {
        if (task.state==NSURLSessionTaskStateCanceling||task.state==NSURLSessionTaskStateCompleted) {
            [downloadingFiles removeObject:task];
        }
    }
}

-(void)suspendTaskIfNeed
{
    for (NSURLSessionDownloadTask* task in downloadingFiles)
    {
        if (task.state==NSURLSessionTaskStateRunning) {
            [task suspend];
        }
    }
}

-(BOOL)existDownloadingUrl:(NSString*)url
{
    BOOL isDownLoading=NO;
    
    [self cleanUnavailableTask];
    [self resumeAllTaskIfNeed];
    
    for (NSURLSessionDownloadTask* task in downloadingFiles)
    {
        BOOL isThisURL=[task.originalRequest.URL.absoluteString isEqualToString:url];
        if (isThisURL) {
            isDownLoading=YES;
        }
    }
    return isDownLoading;
}

-(NSString*)getNameFromUrlString:(NSString*)str
{
    NSArray* conpo=[str componentsSeparatedByString:@"/"];
    return conpo.lastObject;
}

-(void)deleteVideo:(VideoObject *)video
{
    NSString* path=[self filePathWithDownloadedUrl:video.url];
    NSFileManager* ma=[NSFileManager defaultManager];
    if ([ma fileExistsAtPath:path]) {
        [ma removeItemAtPath:path error:nil];
    }
}

-(void)downloadVideo:(VideoObject *)video
{
    NSMutableDictionary* di=[NSMutableDictionary dictionaryWithDictionary:[CacheTool dictionaryWithCacheForKey:DOWNLOAD_VIDEO_KEY]];
    NSMutableArray* videos=[NSMutableArray arrayWithArray:[di valueForKey:@"videos"]];
    
    BOOL hasCache=NO;
    for (NSDictionary* vd in videos) {
        VideoObject* vo=[[VideoObject alloc]initWithDictionary:vd];
        if (vo.id_==video.id_) {
            hasCache=YES;
        }
    }
    if (!hasCache) {
        [videos addObject:video.dictionary];
        [di setValue:videos forKey:@"videos"];
        [CacheTool saveCacheWithDictionary:di forKey:DOWNLOAD_VIDEO_KEY];
    }
    
    NSString* url=video.url;
    BOOL isDownLoaded=[self existDownloadedUrl:url];
    BOOL isDownLoading=[self existDownloadingUrl:url];
    if (!(isDownLoaded||isDownLoading)) {
        [self downloadFile:url];
    }
}

-(void)downloadFile:(NSString*)url
{
//    url=@"ht tps://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png";
    NSString* savingName=[self getNameFromUrlString:url];
    if ([savingName rangeOfString:@".mp4"].location==NSNotFound) {
        return;
    }
    
    DownLoadProgress* progress=[[DownLoadProgress alloc]init];
    progress.url=url;
    progress.totalData=1;
    progress.completedData=0;
    progress.finished=NO;
    
    [self sendNotificationWithProgress:progress];
    
    NSURLSessionConfiguration* configuration=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLRequest* req=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager* manager=[[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    NSURLSessionDownloadTask* task=[manager downloadTaskWithRequest:req progress:^(NSProgress* downloadProgress) {
        DownLoadProgress* pro=[[DownLoadProgress alloc]init];
        pro.totalData=downloadProgress.totalUnitCount;
        pro.completedData=downloadProgress.completedUnitCount;
        pro.url=url;
        pro.finished=(pro.totalData==pro.completedData);
        [self sendNotificationWithProgress:pro];
    } destination:^NSURL * (NSURL* targetPath, NSURLResponse* response) {
        NSString* fullPath=[NSString stringWithFormat:@"%@/%@",[self defaultRootPath],[response suggestedFilename]];
//        NSLog(@"saving path: %@",fullPath);
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse* response, NSURL* filePath, NSError* error) {
        if (response) {
            DownLoadProgress* pro=[[DownLoadProgress alloc]init];
            pro.totalData=1;
            pro.completedData=1;
            pro.url=url;
            pro.finished=YES;
            [self sendNotificationWithProgress:pro];
            
            NSLog(@"response:%@",response.description);
            NSLog(@"filepath: %@",filePath.absoluteString);
        }
        else
        {
            NSLog(@"error:%@",error.description);
        }
    }];
    [task resume];
    
    [downloadingFiles addObject:task];
}

-(void)sendNotificationWithProgress:(DownLoadProgress*)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!progress.finished) {
            
            if (shouldPostNotification) {
                shouldPostNotification=NO;
                [self performSelector:@selector(setShouldPostNotification) withObject:nil afterDelay:0.1];
                NSDictionary* userDefault=[NSDictionary dictionaryWithObject:progress forKey:@"progress"];
                [[NSNotificationCenter defaultCenter]postNotificationName:FILE_DOWNLOAD_PROCESS_NOTIFICATION object:nil userInfo:userDefault];
            }
            
        }
        else
        {
            NSDictionary* userDefault=[NSDictionary dictionaryWithObject:progress forKey:@"progress"];
            [[NSNotificationCenter defaultCenter]postNotificationName:FILE_DOWNLOAD_PROCESS_NOTIFICATION object:nil userInfo:userDefault];
        }
    });
}

-(void)setShouldPostNotification
{
    shouldPostNotification=YES;
}

@end
