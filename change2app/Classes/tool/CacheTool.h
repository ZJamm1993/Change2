//
//  CacheTool.h
//  change2app
//
//  Created by jam on 17/4/12.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheTool : NSObject

+(void)saveCacheWithDictionary:(NSDictionary*)dictionary forKey:(NSString*)key;
+(NSDictionary*)dictionaryWithCacheForKey:(NSString*)key;

@end
