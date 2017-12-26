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
{
    SearchPageController* searchPage;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Changer";
    
    UIBarButtonItem* sea=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(goSearch)];
    self.navigationItem.rightBarButtonItem=sea;
    
    self.cacheKey=@"home_page_cache_key";
}

-(void)goSearch
{
    if (searchPage==nil) {
        searchPage=[[SearchPageController alloc]init];
    }
//    sc.preSearchingString=@"阿诺";
    [self.navigationController pushViewController:searchPage animated:YES];
}

@end
