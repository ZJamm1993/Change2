//
//  BaseCell.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "BaseCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation BaseCell
{
    UIImageView* _backgroundImageView;
    UIView* _tintView;
    UILabel* _nameLabel;
    UILabel* _descLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backgroundImageView=[[UIImageView alloc]init];
        _backgroundImageView.contentMode=UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds=YES;
        [self.contentView addSubview:_backgroundImageView];
        
        _tintView=[[UIView alloc]init];
        _tintView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.4];
        [self.contentView addSubview:_tintView];
        
        _nameLabel=[[UILabel alloc]init];
        _nameLabel.numberOfLines=2;
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        _nameLabel.textColor=[UIColor whiteColor];
        _nameLabel.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
        
        _descLabel=[[UILabel alloc]init];
        _descLabel.numberOfLines=1;
        _descLabel.textAlignment=NSTextAlignmentCenter;
        _descLabel.textColor=[UIColor whiteColor];
        _descLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_descLabel];
        
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.contentView);
        }];
        
        [_tintView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.contentView);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).offset(-20);
            make.left.equalTo(self.contentView.mas_left).offset(40);
            make.right.equalTo(self.contentView.mas_right).offset(-40);
        }];
        
        [_descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).offset(20);
            make.left.equalTo(_nameLabel.mas_left);
            make.right.equalTo(_nameLabel.mas_right);
        }];
    }
    return self;
}

-(void)setVideo:(VideoObject *)video
{
    _video=video;
    
    _nameLabel.text=video.name;
    
    NSString* cate=video.category.name;
    NSDate* date=[NSDate dateWithString:video.created_at];
    NSString* dateDesc=date.simpleDescription;
    NSString* desc=[NSString stringWithFormat:@"#%@ | %@",cate,dateDesc];
    _descLabel.text=desc;
    
    [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:video.poster]];
}

-(void)setCategory:(CategoryObject *)category
{
    _category=category;
    
    _nameLabel.text=[NSString stringWithFormat:@"\n%@",category.name];
    _descLabel.text=@"";
    [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:category.cover]];
}

@end
