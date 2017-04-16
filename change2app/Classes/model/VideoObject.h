//
//  VideoObject.h
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryObject.h"
#import "ChannelObject.h"
#import "NSDate+StringFormater.h"
#import "DownLoadProgress.h"

@interface VideoObject : NSObject

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@property NSDictionary* dictionary;

@property NSInteger id_;
@property NSInteger channel_id;
@property NSInteger category_id;
@property NSString* name;
@property NSString* desc;
@property NSString* url;
@property NSInteger duration;
@property NSInteger width;
@property NSInteger height;
@property NSInteger size;
@property NSString* poster;
@property NSInteger favorites_count;
@property NSString* created_at;
@property NSString* updated_at;
@property NSString* random_id;
@property NSTimeInterval published_at;
@property NSInteger played_count;
@property NSString* share_url;
@property NSArray* tag_list;
@property ChannelObject* channel;
@property CategoryObject* category;

@property DownLoadProgress* progress;

@end

/*
 {
     "id":665,
     "channel_id":8,
     "category_id":5,
     "name":"男人心里想的VS.女人心里想的",
     "desc":"约会能不能多一点真诚，少一点套路？ 这内心戏，实在是太足了。来源Timothy DeLaGhetto",
     "url":"http://videos.cdn.change.so/video-0c61280807380b4b278f7a06664cf312.mp4",
     "duration":252.608,
     "width":1280,
     "height":720,
     "size":38332925,
     "poster":"http://images.cdn.change.so/video-poster-57f8d3a8d7543bd0b8d00114c413936f.jpeg",
     "shares_count":335,
     "favorites_count":64,
     "created_at":"2016-09-09T11:45:47.000Z",
     "updated_at":"2016-11-08T05:36:40.000Z",
     "random_id":"2nAiaQ",
     "published_at":"2016-09-13T04:00:00.000Z",
     "played_count":6667,
     "share_url":"http://change.so/2nAiaQ",
     "tag_list":[
         "搞笑",
         "美女",
         "约会",
         "生活",
         "两性"
     ],
     "channel":{
         "id":8,
         "name":"RandomShit",
         "avatar":"http://7xqt58.com2.z0.glb.qiniucdn.com/channel-avatar-699b57cbe13cea602eb822388ae574a5.jpeg",
         "desc":"",
         "videos_count":846,
         "subscriptions_count":0,
         "created_at":"2016-03-18T07:53:16.000Z",
         "updated_at":"2016-03-18T08:03:23.000Z"
     },
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
 }
 */
