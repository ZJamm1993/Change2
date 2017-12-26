//
//  RankingPageController.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "RankingPageController.h"

#define SINCE_KEY @"since"

@implementation RankingPageController
{
    UISegmentedControl* seg;
    NSInteger oldSegmentSelectedIndex;
    NSMutableArray* weeksData;
    NSMutableArray* monthsData;
    NSMutableArray* totalsData;
    CGPoint weeksOffset;
    CGPoint monthsOffset;
    CGPoint totalsOffset;
    NSInteger weeksPage;
    NSInteger monthsPage;
    NSInteger totalsPage;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.url=[ApiTool videoRankingJSON];
    
    weeksData=[NSMutableArray array];
    monthsData=[NSMutableArray array];
    totalsData=[NSMutableArray array];
    
    weeksOffset=CGPointZero;
    monthsOffset=CGPointZero;
    totalsOffset=CGPointZero;
    
    weeksPage=1;
    monthsPage=1;
    totalsPage=1;
    
    seg=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"周排名",@"月排名",@"总排名", nil]];
    seg.selectedSegmentIndex=0;
    oldSegmentSelectedIndex=seg.selectedSegmentIndex;
    [seg addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView=seg;
    
    [self segmentValueChanged:seg];
}

-(void)segmentValueChanged:(UISegmentedControl*)segment
{
    NSInteger old=oldSegmentSelectedIndex;
    
    if (old==0) {
        [weeksData removeAllObjects];
        [weeksData addObjectsFromArray:self.dataSource];
        weeksOffset=self.tableView.contentOffset;
        weeksPage=self.page;
    }
    else if (old==1) {
        [monthsData removeAllObjects];
        [monthsData addObjectsFromArray:self.dataSource];
        monthsOffset=self.tableView.contentOffset;
        monthsPage=self.page;
    }
    else if (old==2) {
        [totalsData removeAllObjects];
        [totalsData addObjectsFromArray:self.dataSource];
        totalsOffset=self.tableView.contentOffset;
        totalsPage=self.page;
    }
    
    oldSegmentSelectedIndex=segment.selectedSegmentIndex;
    NSInteger new=segment.selectedSegmentIndex;
    
    NSString* value=@"unknown";
    if (new==0) {
        value=@"weekly";
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:weeksData];
        self.tableView.contentOffset=weeksOffset;
        self.page=weeksPage;
    }
    else if(new==1)
    {
        value=@"monthly";
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:monthsData];
        self.tableView.contentOffset=monthsOffset;
        self.page=monthsPage;
    }
    else if(new==2)
    {
        value=@"all";
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:totalsData];
        self.tableView.contentOffset=totalsOffset;
        self.page=totalsPage;
    }
    
    [self.params setValue:value forKey:SINCE_KEY];
    if (self.dataSource.count==0) {
        [self.tableView reloadData];
        [self refreshNew];
    }
    else
    {
        [self.tableView reloadData];
    }
}

@end
