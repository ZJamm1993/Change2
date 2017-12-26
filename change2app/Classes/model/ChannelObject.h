//
//  ChannelObject.h
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelObject : NSObject

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@property NSInteger id_;
@property NSString* name;
@property NSString* avatar;
@property NSString* desc;
@property NSInteger videos_count;
@property NSInteger subscriptions_count;
@property NSString* created_at;
@property NSString* updated_at;

@end

/*
 "channel":{
     "id":8,
     "name":"RandomShit",
     "avatar":"http:7xqt58.com2.z0.glb.qiniucdn.com/channel-avatar-699b57cbe13cea602eb822388ae574a5.jpeg",
     "desc":"",
     "videos_count":846,
     "subscriptions_count":0,
     "created_at":"2016-03-18T07:53:16.000Z",
     "updated_at":"2016-03-18T08:03:23.000Z"
 },
*/