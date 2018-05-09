//
//  WLRequest.m
//  WLUtilities_Example
//
//  Created by Fallrainy on 2018/5/9.
//  Copyright © 2018年 nomeqc@gmail.com. All rights reserved.
//

#import "WLRequest.h"
#import "AFHTTPSessionManager.h"
#import "YTKNetworkAgent.h"
#import <YYCache/YYCache.h>

#ifndef NSFoundationVersionNumber_iOS_8_0
#define NSFoundationVersionNumber_With_QoS_Available 1140.11
#else
#define NSFoundationVersionNumber_With_QoS_Available NSFoundationVersionNumber_iOS_8_0
#endif

@implementation WLRequest

+ (void)initialize {
    if (self == [WLRequest class]) {
        AFHTTPSessionManager *manager = [[YTKNetworkAgent sharedAgent] valueForKey:@"_manager"];
        //增加contentType，以防止json数据解析异常
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        AFJSONResponseSerializer *jsonResponseSerializer = [[YTKNetworkAgent sharedAgent] valueForKey:@"jsonResponseSerializer"];
        jsonResponseSerializer.acceptableContentTypes = manager.responseSerializer.acceptableContentTypes;
    }
}

static dispatch_queue_t ytkrequest_cache_writing_queue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attr = DISPATCH_QUEUE_SERIAL;
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_With_QoS_Available) {
            attr = dispatch_queue_attr_make_with_qos_class(attr, QOS_CLASS_BACKGROUND, 0);
        }
        queue = dispatch_queue_create("com.yuantiku.ytkrequest.caching", attr);
    });
    return queue;
}

+ (YYCache *)sharedCache {
    static YYCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[YYCache alloc] initWithName:@"WLRequestCache"];
        cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    });
    return cache;
}

+ (NSMutableArray *)sharedDefaultAccessory {
    static dispatch_once_t onceToken;
    static NSMutableArray *sharedAccessories = nil;
    dispatch_once(&onceToken, ^{
        sharedAccessories = [NSMutableArray new];
    });
    return sharedAccessories;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if ([self enableDefaultAccessory]) {
        [[WLRequest sharedDefaultAccessory] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addAccessory:obj];
        }];
    }
    
    return self;
}
// MARK: Helper
+ (void)addDefaultAccessory:(id<YTKRequestAccessory>)accessory {
    if ([accessory conformsToProtocol:@protocol(YTKRequestAccessory)]) {
        [[WLRequest sharedDefaultAccessory] addObject:accessory];
    }
}

// MARK: Override
- (void)requestCompletePreprocessor {
    //先检查是否开启自定义缓存
    if ([self enableCache]) {
        if (self.writeCacheAsynchronously) {
            dispatch_async(ytkrequest_cache_writing_queue(), ^{
                [self saveResponseToCache:[super responseObject]];
            });
        } else {
            [self saveResponseToCache:[super responseObject]];
        }
    } else {
        //如果没有启用自定义缓存 再转给YTKNetworking自带缓存
        [super requestCompletePreprocessor];
    }
}

#pragma mark - Custom
- (void)saveResponseToCache:(id)responseObject {
    if ([responseObject isKindOfClass:[NSDictionary class]] &&
        [self isJsonStatusOK]) {
        [[WLRequest sharedCache] setObject:responseObject forKey:[self _apiCacheKey]];
    }
}

- (id)cacheResponseJSONObject {
    //检查是否开启缓存
    if (![self enableCache]) {
        return nil;
    }
    YYCache *sharedCache = [WLRequest sharedCache];
    //获取缓存key
    NSString *cacheKey = [self apiCacheKey];
    //查询缓存
    if (![sharedCache containsObjectForKey:cacheKey]) {
        return nil;
    }
    //取得缓存数据
    id cacheJson = [sharedCache objectForKey:cacheKey];
    return cacheJson;
}

- (NSString *)apiCacheKey {
    return [self _apiCacheKey];
}

- (NSString *)_apiCacheKey {
    NSString *prefix = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSDictionary *param = [self requestArgument];
    if (!param) {
        return [NSString stringWithFormat:@"%@:%@",prefix,[self requestUrl]];
    } else {
        NSMutableString *paramString = [[NSMutableString alloc] initWithString:@""];
        [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [paramString appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
        }];
        if (paramString.length > 0) {
            //删除最后一个多余的&
            [paramString deleteCharactersInRange:NSMakeRange(paramString.length-1, 1)];
        }
        return [NSString stringWithFormat:@"%@:%@?%@",prefix,[self requestUrl],paramString];
    }
}


// MARK: 可供子类重载定制
- (BOOL)enableDefaultAccessory {
    return YES;
}

- (BOOL)enableCache {
    return NO;
}

- (BOOL)isJsonStatusOK {
    NSString *msg = [NSString stringWithFormat:@"子类必须重载%s方法",__func__];
    NSAssert(NO, msg);
    return YES;
}

@end
