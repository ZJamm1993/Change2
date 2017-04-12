//
//  FileTool.m
//  change2app
//
//  Created by jam on 17/4/12.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "FileTool.h"
#import "AFNetworking.h"

static FileTool* fileToolInstance;

@implementation FileTool
{
    
}

+(instancetype)sharedInstancetype
{
    if (fileToolInstance==nil) {
        fileToolInstance=[[FileTool alloc]init];
    }
    return fileToolInstance;
}

-(NSString*)defaultRootPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}

-(BOOL)existFileName:(NSString*)fileName
{
    NSString* fullPath=[NSString stringWithFormat:@"%@/%@",[self defaultRootPath],fileName];
    BOOL exist=[[NSFileManager defaultManager]fileExistsAtPath:fullPath];
    return exist;
}

-(NSString*)getNameFromUrlString:(NSString*)str
{
    NSArray* conpo=[str componentsSeparatedByString:@"/"];
    return conpo.lastObject;
}

-(void)downloadFile:(NSString*)url
{
    NSString* savingName=[self getNameFromUrlString:url];
    
}

@end
