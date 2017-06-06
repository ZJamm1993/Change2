//
//  VideoObject.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "VideoObject.h"

@implementation VideoObject

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self=[super init];
    if (self) {
        _dictionary=[NSDictionary dictionaryWithDictionary:dictionary];
        _id_=[[dictionary valueForKey:@"id"]integerValue];
        _channel_id=[[dictionary valueForKey:@"channel_id"]integerValue];
        _category_id=[[dictionary valueForKey:@"category_id"]integerValue];
        _name=[dictionary valueForKey:@"name"];
        _desc=[dictionary valueForKey:@"desc"];
        _url=[dictionary valueForKey:@"url"];
        _duration=[[dictionary valueForKey:@"duration"]integerValue];
        _width=[[dictionary valueForKey:@"width"]integerValue];
        _height=[[dictionary valueForKey:@"height"]integerValue];
        _size=[[dictionary valueForKey:@"size"]integerValue];
        _poster=[dictionary valueForKey:@"poster"];
        _favorites_count=[[dictionary valueForKey:@"favorites_count"]integerValue];
        _created_at=[dictionary valueForKey:@"created_at"];
        _updated_at=[dictionary valueForKey:@"updated_at"];
        _random_id=[dictionary valueForKey:@"random_id"];
        _published_at=[[dictionary valueForKey:@"published_at"]doubleValue];
        _played_count=[[dictionary valueForKey:@"played_count"]integerValue];
        _share_url=[dictionary valueForKey:@"share_url"];
        _tag_list=[dictionary valueForKey:@"tag_list"];
        _channel=[[ChannelObject alloc]initWithDictionary:[dictionary valueForKey:@"channel"]];
        _category=[[CategoryObject alloc]initWithDictionary:[dictionary valueForKey:@"category"]];
        
//        if ([_url rangeOfString:@"app-upgrade-notification"].location!=NSNotFound) {
//            return nil;
//        }
    }
    return self;
}

@end
