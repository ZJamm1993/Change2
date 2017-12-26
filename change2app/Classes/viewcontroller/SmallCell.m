//
//  SmallCell.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "SmallCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation SmallCell
{
    UILabel* titleLabel;
    UILabel* detailLabel;
    UILabel* durationLabel;
    UIView* tintView;
    UIImageView* imageView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageView=[[UIImageView alloc]init];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
        [self.contentView addSubview:imageView];
        
        tintView=[[UIView alloc]init];
        tintView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.4];
        [self.contentView addSubview:tintView];
        
        durationLabel=[[UILabel alloc]init];
        durationLabel.textColor=[UIColor whiteColor];
        durationLabel.font=[UIFont systemFontOfSize:12];
        durationLabel.textAlignment=NSTextAlignmentRight;
        durationLabel.numberOfLines=1;
        [self.contentView addSubview:durationLabel];
        
        titleLabel=[[UILabel alloc]init];
        titleLabel.font=[UIFont systemFontOfSize:16];
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.numberOfLines=2;
        [self.contentView addSubview:titleLabel];
        
        detailLabel=[[UILabel alloc]init];
        detailLabel.font=[UIFont systemFontOfSize:12];
        detailLabel.textColor=[UIColor blackColor];
        detailLabel.numberOfLines=1;
        [self.contentView addSubview:detailLabel];
        
        UIEdgeInsets in10=UIEdgeInsetsMake(10, 10, 10, 10);
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.contentView).insets(in10);
            make.width.equalTo(@(120));
        }];
        
        [tintView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(imageView);
        }];
        
        [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(imageView).insets(UIEdgeInsetsMake(0, 0, 4, 6));
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.contentView).insets(in10);
            make.left.equalTo(imageView.mas_right).offset(10);
            make.height.greaterThanOrEqualTo(@(46));
        }];
        
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self.contentView).insets(in10);
            make.left.equalTo(imageView.mas_right).offset(10);
        }];
    }
    return self;
}

-(void)setVideo:(VideoObject *)video
{
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
    detailLabel.text=detail;
}

@end
