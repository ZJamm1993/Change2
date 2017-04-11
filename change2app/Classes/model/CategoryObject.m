//
//  CategoryObject.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "CategoryObject.h"

@implementation CategoryObject

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self=[super init];
    if (self) {
        _id_=[[dictionary valueForKey:@"id"]integerValue];
        _name=[dictionary valueForKey:@"name"];
        _desc=[dictionary valueForKey:@"desc"];
        _cover=[dictionary valueForKey:@"cover"];
        _parent_id=nil;
        _lft=[[dictionary valueForKey:@"lft"]integerValue];
        _rgt=[[dictionary valueForKey:@"rgt"]integerValue];
        _depth=[[dictionary valueForKey:@"depth"]integerValue];
        _children_count=[[dictionary valueForKey:@"children_count"] integerValue];
        _videos_count=[[dictionary valueForKey:@"videos_count"]integerValue];
        _created_at=[dictionary valueForKey:@"created_at"];
        _updated_at=[dictionary valueForKey:@"updated_at"];
        _order=[[dictionary valueForKey:@"order"]integerValue];
    }
    return self;
}

@end
