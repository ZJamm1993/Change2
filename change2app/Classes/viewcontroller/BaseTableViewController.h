//
//  BaseTableViewController.h
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpTool.h"
#import "ApiTool.h"
#import "Masonry.h"
#import "VideoObject.h"
#import "BaseCell.h"

@interface BaseTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString* url;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger per_page;
@property (nonatomic,strong) NSMutableDictionary* params;
@property (nonatomic,assign) BOOL usingPage;
@property (nonatomic,strong) NSMutableArray* dataSource;
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) UIRefreshControl* refreshControl;
@property (nonatomic,strong) NSString* cacheKey;

-(void)refreshNew;
-(void)loadMore;
-(void)didRefreshWithDictionary:(NSDictionary*)dictionary;
-(void)didLoadMoreWithDictionary:(NSDictionary*)dictionary;
-(BOOL)shouldSaveCache;
-(void)saveCacheWithDictionary:(NSDictionary*)dictionary;
-(void)loadWithCache;

@end
