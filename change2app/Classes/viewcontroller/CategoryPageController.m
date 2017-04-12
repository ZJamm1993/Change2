//
//  CategoryPageController.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "CategoryPageController.h"

@implementation CategoryPageController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"分类";
    self.url=[ApiTool categoriesJSON];
    self.usingPage=NO;
    
    self.cacheKey=@"category_page_cache_key";
}

-(void)refreshNew
{
    [super refreshNew];
}

-(void)loadMore
{
    
}

-(void)didRefreshWithDictionary:(NSDictionary *)dictionary
{
    NSLog(@"%@",dictionary);
    NSArray* categories=[dictionary valueForKey:@"categories"];
    if (categories.count>0) {
        [self.dataSource removeAllObjects];
    }
    for (NSDictionary* ca in categories) {
        CategoryObject* coo=[[CategoryObject alloc]initWithDictionary:ca];
        [self.dataSource addObject:coo];
    }
}

-(void)didLoadMoreWithDictionary:(NSDictionary *)dictionary
{
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* idd=@"basecatecell";
    BaseCell* cell=[tableView dequeueReusableCellWithIdentifier:idd];
    if (cell==nil) {
        cell=[[BaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idd];
    }
    CategoryObject* cate=[self.dataSource objectAtIndex:indexPath.row];
    cell.category=cate;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CategoryObject* cate=[self.dataSource objectAtIndex:indexPath.row];
    BaseTableViewController* base=[[BaseTableViewController alloc]init];
    base.url=[ApiTool categoriesVideosJSON:cate.id_];
    base.title=cate.name;
    [self.navigationController pushViewController:base animated:YES];
}

@end
