//
//  CollectionTool.h
//  change2app
//
//  Created by jam on 17/4/13.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoObject.h"
#import "CacheTool.h"

@interface CollectionTool : NSObject

+(void)deleteCollectionVideo:(VideoObject*)video;
+(void)collectVideo:(VideoObject*)video;
+(NSDictionary*)collectionVideos;
+(BOOL)hasCollectedVideo:(VideoObject*)video;

@end
