//
//  HomePageController.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "HomePageController.h"
#import "SearchPageController.h"

@implementation HomePageController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Change";
    
    UIBarButtonItem* sea=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(goSearch)];
    self.navigationItem.rightBarButtonItem=sea;
    
    self.cacheKey=@"home_page_cache_key";
}

-(void)goSearch
{
    SearchPageController* sc=[[SearchPageController alloc]init];
//    sc.preSearchingString=@"阿诺";
    [self.navigationController pushViewController:sc animated:YES];
}

@end
