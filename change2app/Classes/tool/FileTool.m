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
#import "SDImageCache.h"

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
    [self cancelDownloadVideo:video];
    NSString* path=[self filePathWithDownloadedUrl:video.url];
    NSFileManager* ma=[NSFileManager defaultManager];
    if ([ma fileExistsAtPath:path]) {
        [ma removeItemAtPath:path error:nil];
    }
}

-(void)cancelDownloadVideo:(VideoObject*)video
{
    for (NSURLSessionDownloadTask* task in downloadingFiles) {
        BOOL isThisURL=[task.originalRequest.URL.absoluteString isEqualToString:video.url];
        if (isThisURL) {
            [task cancel];
        }
    }
}

-(void)downloadVideo:(VideoObject *)video
{
    NSMutableDictionary* di=[NSMutableDictionary dictionaryWithDictionary:[CacheTool dictionaryWithCacheForKey:DOWNLOAD_VIDEO_KEY]];
    NSMutableArray* videos=[NSMutableArray arrayWithArray:[di valueForKey:@"videos"]];
    
    BOOL hasCache=NO;
    for (NSDictionary* vd in videos) {
        VideoObject* vo=[VideoObject objectWithDictionary:vd];//[[VideoObject alloc]initWithDictionary:vd];
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
    [self downloadFile:url];
}

-(void)saveVideo:(VideoObject *)video
{
    NSString* url=video.url;
    NSString* downloadedUrl=[self filePathWithDownloadedUrl:url];
//    NSURL* filePath=[NSURL fileURLWithPath:downloadedUrl];
    UISaveVideoAtPathToSavedPhotosAlbum(downloadedUrl, nil, nil, nil);
}

-(void)downloadFile:(NSString*)url
{
    BOOL isDownLoaded=[self existDownloadedUrl:url];
    BOOL isDownLoading=[self existDownloadingUrl:url];
    if (isDownLoaded||isDownLoading) {
        return;
    }
    
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
        NSHTTPURLResponse* httpRes=([response isKindOfClass:[NSHTTPURLResponse class]])?(NSHTTPURLResponse*)response:nil;
        DownLoadProgress* pro=[[DownLoadProgress alloc]init];
        pro.totalData=1;
        pro.completedData=0;
        pro.url=url;
        pro.finished=(httpRes.statusCode==200);
        pro.failed=!pro.finished;
        [self sendNotificationWithProgress:pro];
        if(pro.failed)
        {
            [self downloadFile:url];
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

-(double)sizeForDocument
{
    NSString* path=[self defaultRootPath];
    // 1.获得文件夹管理者
    NSFileManager *manger = [NSFileManager defaultManager];
    // 2.检测路径的合理性
    BOOL dir = NO;
    BOOL exits = [manger fileExistsAtPath:path isDirectory:&dir];
    if (!exits) return 0;
    // 3.判断是否为文件夹
    if (dir) { // 文件夹, 遍历文件夹里面的所有文件
        // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
        NSArray *subpaths = [manger subpathsAtPath:path];
        int totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullsubpath = [path stringByAppendingPathComponent:subpath];
            BOOL dir = NO;
            [manger fileExistsAtPath:fullsubpath isDirectory:&dir];
            if (!dir) { // 子路径是个文件
                NSDictionary *attrs = [manger attributesOfItemAtPath:fullsubpath error:nil];
                totalSize += [attrs[NSFileSize] intValue];
            }
        }
        return totalSize / (1024 * 1024.0);
    } else { // 文件
        NSDictionary *attrs = [manger attributesOfItemAtPath:path error:nil];
        return [attrs[NSFileSize] intValue] / (1024.0 * 1024.0);
    }
}

-(double)sizeForImageCache
{
    NSUInteger size=[[SDImageCache sharedImageCache]getSize];
    double sizeMb=((double)size)/1024.0/1024.0;
    return sizeMb;
}

-(double)cacheFilesSize
{
    return [self sizeForDocument]+[self sizeForImageCache];
}

-(void)deleteCacheFiles
{
    [[SDImageCache sharedImageCache]clearDisk];
    
    NSString* path=[self defaultRootPath];
    // 1.获得文件夹管理者
    NSFileManager *manger = [NSFileManager defaultManager];
    NSArray* subPaths=[manger subpathsAtPath:path];
    for (NSString* fi in subPaths) {
        NSString* fullPath=[NSString stringWithFormat:@"%@/%@",path,fi];
        [manger removeItemAtPath:fullPath error:nil];
    }
}

@end
