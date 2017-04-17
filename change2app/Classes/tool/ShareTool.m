//
//  ShareTool.m
//  change2app
//
//  Created by jam on 17/4/17.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "ShareTool.h"
@implementation ShareTool

-(void)shareWeChatWithUrl:(NSString*)url title:(NSString*)title description:(NSString*)description thumbImage:(UIImage*)thumbImage scene:(int)scene
{
//    if (title.length>100) {
//        title=[title substringToIndex:99];
//    }
//    
//    if (description) {
//        <#statements#>
//    }
    
    WXMediaMessage* message=[WXMediaMessage message];
    message.title=title;
    message.description=description;
    [message setThumbImage:[self reSizeImage:thumbImage toSize:CGSizeMake(64, 64)]];
    
    //
    
    WXWebpageObject* webpageObject=[WXWebpageObject object];
    webpageObject.webpageUrl=url;
    message.mediaObject=webpageObject;
    
    //
    if (scene<0||scene>2) {
        scene=0;
    }
    
    SendMessageToWXReq* req=[[SendMessageToWXReq alloc]init];
    req.bText=NO;
    req.message=message;
    req.scene=scene;
    
    [WXApi sendReq:req];
}

-(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

@end
