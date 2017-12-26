//
//  TabbarController.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "TabbarController.h"
#import "NaviController.h"
#import "HomePageController.h"
#import "CategoryPageController.h"
#import "RankingPageController.h"
#import "ProfilePageController.h"

@implementation TabbarController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar.tintColor=[UIColor blackColor];
    
    [self addChildViewController:[[HomePageController alloc]init] title:@"change" imageName:@"home"];
//    [self addChildViewController:[[CategoryPageController alloc]init] title:@"分类" imageName:@"categories"];
//    [self addChildViewController:[[RankingPageController alloc]init] title:@"排行" imageName:@"ranking"];
    [self addChildViewController:[[ProfilePageController alloc]init] title:@"我" imageName:@"profile"];
}

-(void)addChildViewController:(UIViewController*)controller title:(NSString*)title imageName:(NSString*)imageName
{
    if (controller==nil) {
        return;
    }
    NaviController* nav=[[NaviController alloc]initWithRootViewController:controller];
    nav.tabBarItem.title=title;
    nav.tabBarItem.image=[UIImage imageNamed:imageName];
    [self addChildViewController:nav];
}

@end
