//
//  DownLoadProgress.h
//  change2app
//
//  Created by jam on 17/4/12.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadProgress : NSObject

@property (nonatomic,strong) NSString* url;
@property (nonatomic,assign) int64_t totalData;
@property (nonatomic,assign) int64_t completedData;
@property (nonatomic,assign) BOOL finished;

@end
