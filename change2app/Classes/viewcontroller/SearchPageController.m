//
//  SearchPageController.m
//  change2app
//
//  Created by jam on 17/4/12.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "SearchPageController.h"

#define S_KEY @"q"

@interface SearchPageController()<UISearchBarDelegate>

@end

@implementation SearchPageController
{
    UISearchBar* search;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.url=[ApiTool searchJSON];
    
    search=[[UISearchBar alloc]init];
    search.showsCancelButton=YES;
    search.placeholder=@"搜索视频";
    search.delegate=self;
    search.text=self.preSearchingString;
    self.navigationItem.titleView=search;
    
    if (self.preSearchingString.length>0) {
        [self searchVideoName:self.preSearchingString];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [search resignFirstResponder];
}

-(void)searchVideoName:(NSString*)name
{
    [self.params setValue:name forKey:S_KEY];
    [self refreshNew];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self searchVideoName:searchBar.text];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

@end
