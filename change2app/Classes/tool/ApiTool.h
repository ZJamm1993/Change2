//
//  ApiTool.h
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiTool : NSObject

+(NSString*)main;

+(NSString*)videoRankingJSON;
+(NSString*)videoJSON;
+(NSString*)videoRelatedJSON:(NSInteger)videoId;

+(NSString*)categoriesJSON;
+(NSString*)categoriesVideosJSON:(NSInteger)categoryId;

+(NSString*)searchJSON;

@end
