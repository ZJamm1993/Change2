//
//  ApiTool.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "ApiTool.h"

@implementation ApiTool

+(NSString*)main
{
    return @"https://api.change.so/v2";
}

+(NSString*)videoRankingJSON
{
    return [NSString stringWithFormat:@"%@/videos/ranking.json",[ApiTool main]];
}

+(NSString*)videoJSON
{
    return [NSString stringWithFormat:@"%@/videos",[ApiTool main]];
}

+(NSString*)videoRelatedJSON:(NSInteger)videoId
{
    return [NSString stringWithFormat:@"%@/videos/%ld/related.json",[ApiTool main],(long)videoId];
}

+(NSString*)categoriesJSON
{
    return [NSString stringWithFormat:@"%@/categories.json",[ApiTool main]];
}

+(NSString*)categoriesVideosJSON:(NSInteger)categoryId
{
    //categories/2/videos.json
    return [NSString stringWithFormat:@"%@/categories/%ld/videos.json",[ApiTool main],(long)categoryId];
}

+(NSString*)searchJSON
{
    return [NSString stringWithFormat:@"%@/videos/search.json",[ApiTool main]];
}

@end
