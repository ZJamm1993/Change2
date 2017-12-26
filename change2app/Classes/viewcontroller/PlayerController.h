//
//  PlayerController.h
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface PlayerController : MPMoviePlayerViewController

@property (nonatomic,strong) NSString* url;
@property (nonatomic,assign) BOOL isLocal;

@end
