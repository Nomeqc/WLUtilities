//
//  WLHUDRequestAccessory.m
//  WLUtilities_Example
//
//  Created by Fallrainy on 2018/5/9.
//  Copyright © 2018年 nomeqc@gmail.com. All rights reserved.
//

#import "WLRequestAccessory.h"

@implementation WLRequestAccessory

- (void)requestWillStart:(id)request {
    if (_requestWillStartHandler) {
        _requestWillStartHandler(request);
    }
}

///  Inform the accessory that the request is about to stop. This method is called
///  before executing `requestFinished` and `successCompletionBlock`.
///
///  @param request The corresponding request.
- (void)requestWillStop:(id)request {
    if (_requestWillStopHandler) {
        _requestWillStopHandler(request);
    }
}

///  Inform the accessory that the request has already stoped. This method is called
///  after executing `requestFinished` and `successCompletionBlock`.
///
///  @param request The corresponding request.
- (void)requestDidStop:(id)request {
    if (_requestDidStopHandler) {
        _requestDidStopHandler(request);
    }
}

@end
