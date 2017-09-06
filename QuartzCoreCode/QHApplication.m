//
//  QHApplication.m
//  QuartzCoreCode
//
//  Created by QH on 2017/8/25.
//  Copyright © 2017年 QH. All rights reserved.
//

#import "QHApplication.h"
//NSString *const notiScreenTouch = @"notiScreenTouch";

@implementation QHApplication {
    NSInteger start;
}
- (instancetype)init {
    start = 0;
    return [super init];
}
- (void)sendEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeTouches) {
        if (event.allTouches.count > 1) {
            start++;
            if ([[event.allTouches anyObject] phase] == UITouchPhaseBegan) {
            }
        }else{
            if ([[event.allTouches anyObject] phase] == UITouchPhaseBegan) {
            }
        }
        [super sendEvent:event];
    }
}

@end
