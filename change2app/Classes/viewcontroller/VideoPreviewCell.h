//
//  VideoPreviewCell.h
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoObject.h"

@protocol VideoPreviewDelegate <NSObject>

-(void)videoPreviewShouldPlayVideo;
-(void)videoPreviewShouldReloadHeight;

@end

@interface VideoPreviewCell : UITableViewCell

@property (nonatomic,weak) id<VideoPreviewDelegate> delegate;
@property (nonatomic,strong) VideoObject* video;
@property (nonatomic,assign) NSInteger descriptionNumberOfLines;

@end
