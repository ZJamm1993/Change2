//
//  NSDate+StringFormater.h
//  myTalk
//
//  Created by jam on 17/4/10.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (StringFormater)

-(NSString*)simpleDescription;

+(NSDate*)dateWithString:(NSString*)str;

@end
