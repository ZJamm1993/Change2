//
//  NaviController.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "NaviController.h"

@implementation NaviController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.tintColor=[UIColor blackColor];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count!=0) {
        viewController.hidesBottomBarWhenPushed=YES;
    }
    else
    {
        
    }
    [super pushViewController:viewController animated:animated];
}

@end
