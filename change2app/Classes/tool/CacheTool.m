//
//  CacheTool.m
//  change2app
//
//  Created by jam on 17/4/12.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "CacheTool.h"

@implementation CacheTool

+(void)saveCacheWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        if (dictionary.count>0) {
            NSData* data=[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
            if ([data isKindOfClass:[NSData class]]) {
                if (data.length>0) {
                    [[NSUserDefaults standardUserDefaults]setValue:data forKey:key];
                }
            }
        }
    }
}

+(NSDictionary*)dictionaryWithCacheForKey:(NSString *)key
{
    NSData* data=[[NSUserDefaults standardUserDefaults]valueForKey:key];
    if ([data isKindOfClass:[NSData class]]) {
        if (data.length>0) {
            NSDictionary* cache=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([cache isKindOfClass:[NSDictionary class]]) {
                if (cache.count>0) {
                    return cache;
                }
            }
        }
    }
    return [NSDictionary dictionary];
}

@end
