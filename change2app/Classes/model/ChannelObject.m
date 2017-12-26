//
//  ChannelObject.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "ChannelObject.h"

@implementation ChannelObject

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self=[super init];
    if (self) {
        _id_=[[dictionary valueForKey:@"id"]integerValue];
        _name=[dictionary valueForKey:@"name"];
        _avatar=[dictionary valueForKey:@"avatar"];
        _desc=[dictionary valueForKey:@"desc"];
        _videos_count=[[dictionary valueForKey:@"videos_count"]integerValue];
        _subscriptions_count=[[dictionary valueForKey:@"subscriptions_count"]integerValue];
        _created_at=[dictionary valueForKey:@"created_at"];
        _updated_at=[dictionary valueForKey:@"updated_at"];
    }
    return self;
}

@end
