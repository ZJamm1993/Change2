//
//  CollectionTool.m
//  change2app
//
//  Created by jam on 17/4/13.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "CollectionTool.h"

#define COLLECTION_VIDEO_KEY @"collection_video_key"

@implementation CollectionTool

+(NSDictionary*)collectionVideos
{
    return [CacheTool dictionaryWithCacheForKey:COLLECTION_VIDEO_KEY];
}

+(void)deleteCollectionVideo:(VideoObject *)video
{
    NSDictionary* ca=[CollectionTool collectionVideos];
    NSArray* va=[ca valueForKey:@"videos"];
    NSMutableArray* videos=[NSMutableArray arrayWithArray:va];
    for (NSDictionary* vd in va) {
        VideoObject* vo=[VideoObject objectWithDictionary:vd];//[[VideoObject alloc]initWithDictionary:vd];
        if (vo.id_==video.id_) {
            [videos removeObject:vd];
        }
    }
    NSDictionary* newca=[NSDictionary dictionaryWithObject:videos forKey:@"videos"];
    [CacheTool saveCacheWithDictionary:newca forKey:COLLECTION_VIDEO_KEY];
}

+(void)collectVideo:(VideoObject *)video
{
    if ([CollectionTool hasCollectedVideo:video]) {
        return;
    }
    else
    {
        NSDictionary* ca=[CollectionTool collectionVideos];
        NSMutableArray* videos=[NSMutableArray arrayWithArray:[ca valueForKey:@"videos"]];
        [videos addObject:video.dictionary];
        NSDictionary* newca=[NSDictionary dictionaryWithObject:videos forKey:@"videos"];
        [CacheTool saveCacheWithDictionary:newca forKey:COLLECTION_VIDEO_KEY];
    }
}

+(BOOL)hasCollectedVideo:(VideoObject *)video
{
    NSDictionary* ca=[CollectionTool collectionVideos];
    NSArray* videos=[ca valueForKey:@"videos"];
    for (NSDictionary* vd in videos) {
        VideoObject* vo=[VideoObject objectWithDictionary:vd];//[[VideoObject alloc]initWithDictionary:vd];
        if (vo.id_==video.id_) {
            return YES;
        }
    }
    return NO;
}

@end
