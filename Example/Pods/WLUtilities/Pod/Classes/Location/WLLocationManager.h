//
//  XDBLoacationManager.h
//  XinDianBao
//
//  Created by Fallrainy on 2017/12/27.
//  Copyright © 2017年 iOSDeveloper003. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

typedef void (^WLLocationManagerLocationUpdateHandler)(NSArray<CLPlacemark *> *placemarks, CLLocationDegrees longitude, CLLocationDegrees latitude, NSError *error);

@interface WLLocationManager : NSObject

+ (instancetype)sharedInstance;

/// 标识是否正在访问用户位置
@property (nonatomic, readonly , getter=isRequestingLocation) BOOL requestingLocation;

/// 请求访问用户位置 或者 停止访问用户位置
- (void)requestLocation;

/// 查询定位授权状态 如果 拒绝授权执行block
- (void)queryAuthorizationStatusWithDeniedHandler:(dispatch_block_t)deniedHandler;

///定位更新处理
@property (nonatomic, copy) WLLocationManagerLocationUpdateHandler locationUpdateHandler;
@property (nonatomic, copy) dispatch_block_t deniedHandler;

- (void)requestLocationWithUpdateHandler:(WLLocationManagerLocationUpdateHandler)updateHandler deniedHandler:(dispatch_block_t)deniedHandler;

@end
