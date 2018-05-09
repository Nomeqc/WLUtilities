//
//  WXBRegisterApi.m
//  WLUtilities_Example
//
//  Created by Fallrainy on 2018/5/9.
//  Copyright © 2018年 nomeqc@gmail.com. All rights reserved.
//

#import "WXBRegisterApi.h"

@implementation WXBRegisterApi


- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return @"api.php?c=index&a=register&invite_mobile=18616555575&mobile=13015957076&pfid=2&password=123456&code=5555";
}

- (id)requestArgument {
    return nil;
}

- (id)jsonValidator {
    return nil;
}

@end
