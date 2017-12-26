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

//-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

+(instancetype)objectWithDictionary:(NSDictionary*)dictionary;

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
@property BOOL pro;
@property NSString* share_url;
@property NSArray* tag_list;
@property ChannelObject* channel;
@property CategoryObject* category;

@property DownLoadProgress* progress;

@end

/*
 videos": [{
     "id": 664,
     "channel_id": 8,
     "category_id": 4,
     "name": "明星变型记part3",
     "desc": "身材爆炸的好莱坞男星们，告诉你他们身材变化的真正秘密：刻苦，坚持，饮食，专注。没有其他。 来看看有没有你的男神吧！来源EpicMashups",
     "url": "http:videos.ali.cdn.change.so/video-b3e6d2afbe67cb1b046d7e230a1e7a6d.mp4",
     "duration": 631.258,
     "width": 1280,
     "height": 720,
     "size": 109600429,
     "poster": "http:images.cdn.change.so/video-poster-f0ba6346b76c38880ac086f51f482d6d.jpeg?imageView/1/w/256/h/144",
     "shares_count": 7466,
     "favorites_count": 3510,
     "created_at": "2016-09-09T11:36:07.000Z",
     "updated_at": "2017-07-30T15:37:15.000Z",
     "random_id": "AbWhIg",
     "published_at": "2016-09-12T16:00:00.000Z",
     "played_count": 81888,
     "anonymous_favorites_count": 141,
     "pro": false,
     "downloadable": false,
     "demo_url": "",
     "comments_count": 0,
     "sort_index": 664,
     "count": 4,
     "share_name": "明星变型记part3 | Change 健身潮流文化社区",
     "share_url": "http:change.so/AbWhIg",
     "tag_list": ["明星", "肌肉", "增肌", "帅哥", "大片", "举铁", "励志", "好莱坞", "EpicMashups", "减脂", "记录"],
     "channel": {
         "id": 8,
         "name": "全球精选",
         "avatar": "http:images.cdn.change.so/channel-avatar-cb01c8d8d98041ccf637ca1dbaf152ec.png?imageView/1/w/160/h/160",
         "desc": "网罗全球健身视频资讯 ",
         "videos_count": 629,
         "subscriptions_count": 0,
         "created_at": "2016-03-18T07:53:16.000Z",
         "updated_at": "2017-08-02T04:00:00.000Z",
         "recommended": true,
         "videos_played_count": 23605835,
         "videos_shares_count": 467439,
         "videos_favorites_count": 171675,
         "last_published_video_published_at": "2017-08-02T04:00:00.000Z",
         "avatar_full": "http:images.cdn.change.so/channel-avatar-cb01c8d8d98041ccf637ca1dbaf152ec.png"
     },
     "category": {
         "id": 4,
         "name": "励志",
         "desc": "",
         "cover": "http:7xqt58.com2.z0.glb.qiniucdn.com/category-cover-32ce12a4d80153dd5d30142c6461355a.jpeg",
         "parent_id": null,
         "lft": 3,
         "rgt": 4,
         "depth": 0,
         "children_count": 0,
         "videos_count": 218,
         "created_at": "2016-03-17T09:05:15.000Z",
         "updated_at": "2016-06-28T08:47:48.000Z",
         "order": 3
     },
     "favorited_by_current_user": false
 },
 */
