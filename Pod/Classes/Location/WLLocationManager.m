//
//  XDBLoacationManager.m
//  XinDianBao
//
//  Created by Fallrainy on 2017/12/27.
//  Copyright © 2017年 iOSDeveloper003. All rights reserved.
//

#import "WLLocationManager.h"

@import CoreLocation;

@interface WLLocationManager () <CLLocationManagerDelegate>

/// 管理位置的授权的位置的更新
@property (nonatomic) CLLocationManager *manager;

/// 标识是否正在访问用户位置
@property (nonatomic, readwrite , getter=isRequestingLocation) BOOL requestingLocation;



@end


@implementation WLLocationManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    [_manager requestWhenInUseAuthorization];
    
    return self;
}

- (void)requestLocation {
    if (self.isRequestingLocation) {
        [self.manager stopUpdatingHeading];
        self.requestingLocation = NO;
        return;
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            self.requestingLocation = YES;
            [self.manager requestWhenInUseAuthorization];
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            self.requestingLocation = YES;
            if (@available(iOS 9, *)) {
                [self.manager requestLocation];
            } else {
                [self.manager startUpdatingLocation];
            }
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            NSLog(@"用户已经拒绝定位授权");
            if (self.deniedHandler) {
                self.deniedHandler();
            }
        }
            break;
            
        default:
        {
            NSLog(@"非预期的授权错误");
        }
            break;
    }
}

- (void)queryAuthorizationStatusWithDeniedHandler:(dispatch_block_t)deniedHandler {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied) {
        if (deniedHandler) {
            deniedHandler();
        }
    } 
}


- (void)requestLocationWithUpdateHandler:(WLLocationManagerLocationUpdateHandler)updateHandler deniedHandler:(dispatch_block_t)deniedHandler {
    self.locationUpdateHandler = updateHandler;
    self.deniedHandler = deniedHandler;
    self.requestingLocation = NO;
    [self requestLocation];
}

// MARK: CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                                            objectForKey:@"AppleLanguages"];
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]
                                              forKey:@"AppleLanguages"];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    __weak typeof(self) weakSelf = self;
    [geoCoder reverseGeocodeLocation:locations.lastObject completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        typeof(weakSelf) self = weakSelf;
        CLPlacemark *placemark = placemarks.firstObject;
        CLLocation *locaiton = nil;
        if (placemark.locality) {
            NSLog(@"%@",placemark.locality);
            locaiton = placemark.location;
            NSLog(@"经度：%f,纬度：%f",locaiton.coordinate.longitude,locaiton.coordinate.latitude);
        } else {
            NSLog(@"无法定位当前城市");
        }
        NSLog(@"%@",placemark.name);
        
        if (self.locationUpdateHandler) {
            self.locationUpdateHandler(placemarks, locaiton.coordinate.longitude, locaiton.coordinate.latitude, error);
        }
        // 还原Device 的语言
        [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        self.requestingLocation = NO;
        NSLog(@"%@",error.localizedDescription);
    });
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
//        if (self.isRequestingLocation) {
//            return;
//        }
        switch (status) {
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            case kCLAuthorizationStatusAuthorizedAlways:
            {
                if (@available(iOS 9, *)) {
                    [self.manager requestLocation];
                } else {
                    [self.manager startUpdatingLocation];
                }
            }
                break;
                
            case kCLAuthorizationStatusDenied:
            {
                self.requestingLocation = NO;
                NSLog(@"定位授权被拒绝");
                if (self.deniedHandler) {
                    self.deniedHandler();
                }
            }
                break;
            default:
            {
                self.requestingLocation = NO;
                NSLog(@"未预期的授权错误");
            }
                break;
        }
    });
    
}

@end
