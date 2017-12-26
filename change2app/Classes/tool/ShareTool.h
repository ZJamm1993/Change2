//
//  ShareTool.h
//  change2app
//
//  Created by jam on 17/4/17.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"

@interface ShareTool : NSObject

-(void)shareWeChatWithUrl:(NSString*)url title:(NSString*)title description:(NSString*)description thumbImage:(UIImage*)thumbImage scene:(int)scene;

@end
