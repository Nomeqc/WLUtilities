//
//  WLAuthorizationManager.h
//  WLUtilities_Example
//
//  Created by Fallrainy on 2018/5/3.
//  Copyright © 2018年 nomeqc@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WLAuthorizationManagerDeniedReason) {
    WLAuthorizationManagerDeniedReasonUserDenied = 1,
    WLAuthorizationManagerDeniedReasonRestricted = 2
};

typedef void (^WLAuthorizationManagerDeniedHandler)(WLAuthorizationManagerDeniedReason reason);

@interface WLAuthorizationManager : NSObject

+ (void)requestVideoAuthorizationWithGrantedHandler:(dispatch_block_t)grantedHandler deniedHandler:(WLAuthorizationManagerDeniedHandler)deniedHandler;

+ (void)requestAudioAuthorizationWithGrantedHandler:(dispatch_block_t)grantedHandler deniedHandler:(WLAuthorizationManagerDeniedHandler)deniedHandler;

+ (void)requestPhotoAuthorizationWithGrantedHandler:(dispatch_block_t)grantedHandler deniedHandler:(WLAuthorizationManagerDeniedHandler)deniedHandler;

@end
