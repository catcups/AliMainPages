//
//  main.m
//  QuartzCoreCode
//
//  Created by QH on 2017/8/25.
//  Copyright © 2017年 QH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "QHApplication.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        //return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        return UIApplicationMain(argc, argv, NSStringFromClass([QHApplication class]), NSStringFromClass([AppDelegate class]));
    }
}
