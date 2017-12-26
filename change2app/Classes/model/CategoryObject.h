//
//  CategoryObject.h
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryObject : NSObject

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@property NSInteger id_;
@property NSString* name;
@property NSString* desc;
@property NSString* cover;
@property NSString* parent_id;
@property NSInteger lft;
@property NSInteger rgt;
@property NSInteger depth;
@property NSInteger children_count;
@property NSInteger videos_count;
@property NSString* created_at;
@property NSString* updated_at;
@property NSInteger order;

@end

/*
"category":{
    "id":5,
    "name":"潮流",
    "desc":"",
    "cover":"http://images.cdn.change.so/category-cover-5773c292455bda8388db649c87e30b89.jpeg",
    "parent_id":null,
    "lft":5,
    "rgt":6,
    "depth":0,
    "children_count":0,
    "videos_count":529,
    "created_at":"2016-03-17T09:05:34.000Z",
    "updated_at":"2017-03-07T08:40:56.000Z",
    "order":7
}
*/