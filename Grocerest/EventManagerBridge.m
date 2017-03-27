//
//  EventManagerBridge.m
//  Grocerest
//
//  Created by Davide Bertola on 16/03/2017.
//  Copyright © 2017 grocerest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(EventManager, NSObject)

RCT_EXTERN_METHOD(emit:(NSString *)event data:(NSDictionary *)data)
RCT_EXTERN_METHOD(supportedEventsAdd:(NSString *)event)


// Just an example of a complete callable method
// RCT_EXTERN_METHOD(call:(NSDictionary *)data callback:(RCTResponseSenderBlock)callback)

@end
