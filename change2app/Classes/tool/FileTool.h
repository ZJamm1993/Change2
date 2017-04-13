//
//  FileTool.h
//  change2app
//
//  Created by jam on 17/4/12.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoadProgress.h"
#import "VideoObject.h"

#define FILE_DOWNLOAD_PROCESS_NOTIFICATION @"file_download_process_notification"
#define DOWNLOAD_VIDEO_KEY @"download_video_key"

@interface FileTool : NSObject

+(instancetype)sharedInstancetype;

-(void)downloadVideo:(VideoObject*)video;
-(BOOL)existDownloadedUrl:(NSString*)url;
-(void)deleteVideo:(VideoObject*)video;

-(NSString*)filePathWithDownloadedUrl:(NSString*)url;

@end
