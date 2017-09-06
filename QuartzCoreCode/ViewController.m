//
//  ViewController.m
//  QuartzCoreCode
//
//  Created by QH on 2017/8/25.
//  Copyright © 2017年 QH. All rights reserved.
//

#import "ViewController.h"
#import "YYFPSLabel.h"
#import <objc/runtime.h>
#import "QHScroll.h"

@interface ViewController ()
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@property (nonatomic, strong) QHScroll *scroll;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scroll];
    self.title = @"首页";
//    [self testFPSLabel];
}

- (QHScroll *)scroll {
    if (!_scroll) {
        _scroll = [[QHScroll alloc] init]; // 主ScrollView;
    }
    return _scroll;
}

#pragma mark - FPS

- (void)testFPSLabel {
    _fpsLabel = [YYFPSLabel new];
    _fpsLabel.frame = CGRectMake(10, 74, 50, 30);
    [_fpsLabel sizeToFit];
    [self.view addSubview:_fpsLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
