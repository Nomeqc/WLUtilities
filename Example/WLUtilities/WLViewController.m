//
//  WLViewController.m
//  WLUtilities
//
//  Created by nomeqc@gmail.com on 03/26/2018.
//  Copyright (c) 2018 nomeqc@gmail.com. All rights reserved.
//

#import "WLViewController.h"
#import "WLLocationManager.h"
#import "WLAuthorizationManager.h"

@interface WLViewController ()

@end

@implementation WLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}
- (IBAction)didTapVideoButton:(id)sender {
    [WLAuthorizationManager requestVideoAuthorizationWithGrantedHandler:^{
        NSLog(@"相机授权允许");
    } deniedHandler:^(WLAuthorizationManagerDeniedReason reason) {
        [self printReasonDescWithReason:reason];
    }];
}
- (IBAction)didTapAudioButton:(id)sender {
    [WLAuthorizationManager requestAudioAuthorizationWithGrantedHandler:^{
        NSLog(@"麦克风授权允许");
    } deniedHandler:^(WLAuthorizationManagerDeniedReason reason) {
        [self printReasonDescWithReason:reason];
    }];
    
}
- (IBAction)didTapPhotoButton:(UIButton *)sender {
    [WLAuthorizationManager requestPhotoAuthorizationWithGrantedHandler:^{
        NSLog(@"照片授权允许");
    } deniedHandler:^(WLAuthorizationManagerDeniedReason reason) {
        [self printReasonDescWithReason:reason];
    }];
}

- (void)printReasonDescWithReason:(WLAuthorizationManagerDeniedReason)reason {
    switch (reason) {
        case WLAuthorizationManagerDeniedReasonUserDenied:
        {
            NSLog(@"被用户拒绝");
        }
            break;
            case WLAuthorizationManagerDeniedReasonRestricted:
        {
            NSLog(@"家长控制");
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
