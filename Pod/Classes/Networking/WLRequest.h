//
//  WLRequest.h
//  WLUtilities_Example
//
//  Created by Fallrainy on 2018/5/9.
//  Copyright © 2018年 nomeqc@gmail.com. All rights reserved.
//

#import "YTKRequest.h"

@interface WLRequest : YTKRequest

+ (void)addDefaultAccessory:(id<YTKRequestAccessory>)accessory;

@property (nonatomic, readonly, copy) NSDictionary *cacheResponseJSONObject;

/// 是否启用默认Accessory
- (BOOL)enableDefaultAccessory;

/// 是否开启缓存
- (BOOL)enableCache;

/// json状态是否OK
- (BOOL)isJsonStatusOK;

@end
