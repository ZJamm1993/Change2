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
    return @"http://api.change.so/v1";
}

+(NSString*)video
{
    return [NSString stringWithFormat:@"%@/videos",[ApiTool main]];
}

+(NSString*)videoRankingJSON
{
    return [NSString stringWithFormat:@"%@/ranking.json",[ApiTool video]];
}

+(NSString*)videoJSON
{
    return [NSString stringWithFormat:@"%@.json",[ApiTool video]];
}

+(NSString*)videoRelatedJSON:(NSInteger)videoId
{
    return [NSString stringWithFormat:@"%@/%ld/related.json",[ApiTool video],(long)videoId];
}

@end
