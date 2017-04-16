//
//  VideoPreviewCell.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "VideoPreviewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation VideoPreviewCell
{
    UIImageView* imageView;
    UIView* tintView;
    UIButton* playButton;
    UILabel* durationLabel;
    UILabel* titleLabel;
    UILabel* cateTimeLabel;
    UIButton* moreButton;
    UILabel* descLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIColor* grayColor=[UIColor colorWithWhite:0.6 alpha:1];
        
        CGFloat textLabelPreferredMaxWidth=[[UIScreen mainScreen]bounds].size.width-20;
        
        imageView=[[UIImageView alloc]init];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
        [self.contentView addSubview:imageView];
        
        tintView=[[UIView alloc]init];
        tintView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.4];
        [self.contentView addSubview:tintView];
        
        playButton=[[UIButton alloc]init];
        [playButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        [playButton setTitle:@"▶︎" forState:UIControlStateNormal];
        [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [playButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [[playButton titleLabel]setFont:[UIFont systemFontOfSize:24]];
        [playButton addTarget:self action:@selector(playPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:playButton];
        
        durationLabel=[[UILabel alloc]init];
        durationLabel.textColor=[UIColor whiteColor];
        durationLabel.font=[UIFont systemFontOfSize:12];
        durationLabel.textAlignment=NSTextAlignmentRight;
        durationLabel.numberOfLines=1;
        [self.contentView addSubview:durationLabel];
        
        titleLabel=[[UILabel alloc]init];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        titleLabel.numberOfLines=2;
        titleLabel.font=[UIFont systemFontOfSize:16];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.preferredMaxLayoutWidth=textLabelPreferredMaxWidth;
        [self.contentView addSubview:titleLabel];
        
        moreButton=[[UIButton alloc]init];
        [moreButton setTitle:@"☞" forState:UIControlStateNormal];
        moreButton.transform=CGAffineTransformMakeRotation(M_PI/2);
        [moreButton setTitleColor:grayColor forState:UIControlStateNormal];
        [moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [[moreButton titleLabel]setFont:[UIFont systemFontOfSize:24]];
        [moreButton addTarget:self action:@selector(morePressed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:moreButton];
        
        cateTimeLabel=[[UILabel alloc]init];
        cateTimeLabel.textAlignment=NSTextAlignmentLeft;
        cateTimeLabel.numberOfLines=1;
        cateTimeLabel.font=[UIFont systemFontOfSize:12];
        cateTimeLabel.textColor=grayColor;
        [self.contentView addSubview:cateTimeLabel];
        
        descLabel=[[UILabel alloc]init];
        descLabel.textAlignment=NSTextAlignmentLeft;
        descLabel.numberOfLines=self.descriptionNumberOfLines;
        descLabel.font=[UIFont systemFontOfSize:12];
        descLabel.textColor=grayColor;
//        descLabel.lineBreakMode=NSLineBreakByClipping;
        ///what the hell? 添加了这句之后，在iOS7上就可以了??
        descLabel.preferredMaxLayoutWidth=textLabelPreferredMaxWidth;
        //what the hell!
        [self.contentView addSubview:descLabel];
        
        UIEdgeInsets in10=UIEdgeInsetsMake(10, 14, 10, 14);
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.equalTo(@(320));
        }];
        
        [tintView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(imageView);
        }];
        
        [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView.mas_centerX);
            make.centerY.equalTo(imageView.mas_centerY);
            make.width.height.equalTo(@(64));
        }];
        
        [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(imageView).insets(in10);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView).insets(in10);
            make.top.equalTo(imageView.mas_bottom).offset(10);
//            make.height.equalTo(@(16));
        }];
        
        [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(36));
            make.centerY.equalTo(cateTimeLabel.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        [cateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).insets(in10);
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
            make.right.equalTo(moreButton.mas_left).offset(-10);
//            make.height.equalTo(@(12));
        }];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView).insets(in10);
            make.top.equalTo(cateTimeLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    }
    return self;
}

-(void)setDescriptionNumberOfLines:(NSInteger)descriptionNumberOfLines
{
    _descriptionNumberOfLines=descriptionNumberOfLines;
    descLabel.numberOfLines=_descriptionNumberOfLines;
    
    CGFloat rotation=M_PI/2*(_descriptionNumberOfLines==0?1:-1);
    moreButton.transform=CGAffineTransformMakeRotation(rotation);
    [UIView animateWithDuration:0.25 animations:^{
        moreButton.transform=CGAffineTransformMakeRotation(-rotation);
    }];
}

-(void)setVideo:(VideoObject *)video
{
    if (_video==video) {
        return;
    }
    _video=video;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:video.poster]];
    
    NSInteger min=video.duration/60;
    NSInteger sec=video.duration%60;
    durationLabel.text=[NSString stringWithFormat:@"%ld:%02ld",(long)min,(long)sec];
    
    titleLabel.text=video.name;
    
    NSDate* date=[NSDate dateWithString:video.created_at];
    NSString* dateStr=date.simpleDescription;
    NSString* cate=video.category.name;
    NSString* detail=[NSString stringWithFormat:@"%@ ∙ %@",cate,dateStr];
    cateTimeLabel.text=detail;
    
    descLabel.text=video.desc;
//    NSLog(@"\n%@\n",video.desc);
}

-(void)playPressed
{
    if ([self.delegate respondsToSelector:@selector(videoPreviewShouldPlayVideo)]) {
        [self.delegate videoPreviewShouldPlayVideo];
    }
}

-(void)morePressed
{
    if ([self.delegate respondsToSelector:@selector(videoPreviewShouldReloadHeight)]) {
        [self.delegate videoPreviewShouldReloadHeight];
    }
}

@end
