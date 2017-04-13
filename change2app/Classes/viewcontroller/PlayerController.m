//
//  PlayerController.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "PlayerController.h"

@implementation PlayerController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isLocal) {
        self.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
        self.moviePlayer.contentURL=[NSURL fileURLWithPath:self.url];
    }
    else
    {
        self.moviePlayer.movieSourceType=MPMovieSourceTypeStreaming;
        self.moviePlayer.contentURL=[NSURL URLWithString:self.url];
    }
    [self.moviePlayer play];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end
