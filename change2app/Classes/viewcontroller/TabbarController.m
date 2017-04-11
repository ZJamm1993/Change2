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

@implementation TabbarController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    HomePageController* home=[[HomePageController alloc]init];
    NaviController* homeNav=[[NaviController alloc]initWithRootViewController:home];
    homeNav.title=@"首页";
    [self addChildViewController:homeNav];
}

@end
