//
//  WLAuthorizationManager.m
//  WLUtilities_Example
//
//  Created by Fallrainy on 2018/5/3.
//  Copyright © 2018年 nomeqc@gmail.com. All rights reserved.
//

#import "WLAuthorizationManager.h"

@import AVFoundation;
@import Photos;


@implementation WLAuthorizationManager


+ (void)requestVideoAuthorizationWithGrantedHandler:(dispatch_block_t)grantedHandler deniedHandler:(WLAuthorizationManagerDeniedHandler)deniedHandler {
    dispatch_block_t successBlock = ^{
        if (grantedHandler) {
            grantedHandler();
        }
    };
    WLAuthorizationManagerDeniedHandler failedBlock = ^(WLAuthorizationManagerDeniedReason reason){
        if (deniedHandler) {
            deniedHandler(reason);
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未获得授权访问相机" message:@"请从设置中启用相机功能" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL]];
            UIAlertAction *gotoAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:settingURL]) {
                    [[UIApplication sharedApplication] openURL:settingURL];
                }
            }];
            [alert addAction:gotoAction];
            if (@available (iOS 9,*)) {
                alert.preferredAction = gotoAction;
            }
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    };
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    successBlock();
                } else {
                    failedBlock(WLAuthorizationManagerDeniedReasonUserDenied);
                }
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized: {
            successBlock();
        }
            break;
        case AVAuthorizationStatusDenied: {
            failedBlock(WLAuthorizationManagerDeniedReasonUserDenied);
        }
            break;
        case AVAuthorizationStatusRestricted:
        {
            failedBlock(WLAuthorizationManagerDeniedReasonRestricted);
        }
            break;
            
        default:
            break;
    }
}

+ (void)requestAudioAuthorizationWithGrantedHandler:(dispatch_block_t)grantedHandler deniedHandler:(WLAuthorizationManagerDeniedHandler)deniedHandler {
    dispatch_block_t successBlock = ^{
        if (grantedHandler) {
            grantedHandler();
        }
    };
    WLAuthorizationManagerDeniedHandler failedBlock = ^(WLAuthorizationManagerDeniedReason reason){
        if (deniedHandler) {
            deniedHandler(reason);
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未获得授权访问麦克风" message:@"请前往设置中启用麦克风功能" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL]];
            UIAlertAction *gotoAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:settingURL]) {
                    [[UIApplication sharedApplication] openURL:settingURL];
                }
            }];
            [alert addAction:gotoAction];
            if (@available (iOS 9,*)) {
                alert.preferredAction = gotoAction;
            }
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    };
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启麦克风
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    successBlock();
                } else {
                    failedBlock(WLAuthorizationManagerDeniedReasonUserDenied);
                }
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
        {
            failedBlock(WLAuthorizationManagerDeniedReasonRestricted);
        }
            break;
        case AVAuthorizationStatusDenied:
            //玩家未授权
        {
            failedBlock(WLAuthorizationManagerDeniedReasonUserDenied);
        }
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
        {
            successBlock();
        }
            break;
        default:
            break;
    }
}

+ (void)requestPhotoAuthorizationWithGrantedHandler:(dispatch_block_t)grantedHandler deniedHandler:(WLAuthorizationManagerDeniedHandler)deniedHandler {
    dispatch_block_t successBlock = ^{
        if (grantedHandler) {
            grantedHandler();
        }
    };
    WLAuthorizationManagerDeniedHandler failedBlock = ^(WLAuthorizationManagerDeniedReason reason){
        if (deniedHandler) {
            deniedHandler(reason);
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未获得授权访问照片" message:@"请前往设置中启用照片功能" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL]];
            UIAlertAction *gotoAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:settingURL]) {
                    [[UIApplication sharedApplication] openURL:settingURL];
                }
            }];
            [alert addAction:gotoAction];
            if (@available (iOS 9,*)) {
                alert.preferredAction = gotoAction;
            }
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    };
    
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthorStatus) {
        case PHAuthorizationStatusAuthorized:
        {
            successBlock();
        }
            break;
        case PHAuthorizationStatusDenied:
        {
            failedBlock(WLAuthorizationManagerDeniedReasonUserDenied);
        }
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                switch (status) {
                    case PHAuthorizationStatusAuthorized:
                    {
                        successBlock();
                    }
                        break;
                    case PHAuthorizationStatusDenied:
                    {
                        failedBlock(WLAuthorizationManagerDeniedReasonUserDenied);
                    }
                        break;
                    case PHAuthorizationStatusRestricted:
                    {
                        failedBlock(WLAuthorizationManagerDeniedReasonRestricted);
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
            break;
        case PHAuthorizationStatusRestricted:
        {
            failedBlock(WLAuthorizationManagerDeniedReasonRestricted);
        }
            break;
        default:
            break;
    }
}

@end
