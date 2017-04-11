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
    
    NSURL *moveURl = [NSURL URLWithString:self.url];
    self.moviePlayer.movieSourceType=MPMovieSourceTypeStreaming;
    self.moviePlayer.contentURL=moveURl;
    
    [self.moviePlayer play];
}

@end
