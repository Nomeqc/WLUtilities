//
//  WLRequestAccessory.h
//  WLUtilities_Example
//
//  Created by Fallrainy on 2018/5/9.
//  Copyright © 2018年 nomeqc@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKBaseRequest.h"

typedef void (^WLRequestAccessoryHandler) (id request);

@interface WLRequestAccessory : NSObject <YTKRequestAccessory>

/// 请求将开始 处理
@property (nonatomic, copy) WLRequestAccessoryHandler requestWillStartHandler;

/// 请求将停止 处理
@property (nonatomic, copy) WLRequestAccessoryHandler requestWillStopHandler;

/// 请求已经停止 处理
@property (nonatomic, copy) WLRequestAccessoryHandler requestDidStopHandler;

@end
