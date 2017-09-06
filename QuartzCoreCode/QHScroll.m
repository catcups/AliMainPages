//
//  QHScroll.m
//  QuartzCoreCode
//
//  Created by QH on 2017/9/5.
//  Copyright © 2017年 QH. All rights reserved.
//

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

#import "QHScroll.h"
#import "MJRefresh.h"
#import "BackCell.h"

@interface QHScroll () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headerView;       // 头部视图
@property (nonatomic, strong) UIScrollView *scrollView; // 子ScrollView
@property (nonatomic, strong) NSMutableArray *datas;             // 数据
@property (nonatomic, strong) NSMutableArray<UIColor *> *colors; // 颜色
@property (nonatomic, strong) NSMutableArray<UITableView *> *tableViews;
@property (nonatomic, strong) NSMutableArray *gestures; // 存放多个tableView的手势数组
@end
@implementation QHScroll {
    NSInteger currentIndex; // 当前tableView坐标
    CGFloat currentChangeY; // 切换tableView前的偏移量
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self qh_setupViews];
    }
    return self;
}
- (void)qh_setupViews {
    self.frame = [UIScreen mainScreen].bounds;
    currentIndex = 0;
    self.datas = [NSMutableArray array];
    self.colors = [NSMutableArray array];
    for (int i = 0; i < 300; i++) {
        NSString *str = [NSString stringWithFormat:@"%d, wwwwww", i + 1];
        [self.datas addObject:str];
        UIColor *col = [UIColor colorWithRed:1.0 * arc4random_uniform(256) / 255 green:1.0 * arc4random_uniform(256) / 255 blue:1.0 * arc4random_uniform(256) / 255 alpha:1];
        [self.colors addObject:col];
    }
    
    [self addSubview:self.scrollView];
    [self addSubview:self.headerView];
    for (UITableView *tableV in self.tableViews) {
        [self.scrollView addSubview:tableV];
        [self.gestures addObject:tableV.gestureRecognizers];
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * self.tableViews.count, 0);
    [self removeNowGestureRecognizerToAddNewGestureRecognizers:self.gestures[0]];
}
- (NSMutableArray<UITableView *> *)tableViews {
    if (!_tableViews) {
        _tableViews = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            // 设置多个tableView;
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 40, kScreenWidth,kScreenHeight - 40 - 64) style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(200, 0, 0, 0);
            tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
            tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [tableView.mj_header endRefreshing];
            }];
            [tableView registerClass:[BackCell class] forCellReuseIdentifier:NSStringFromClass([BackCell class])];
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
            [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [_tableViews addObject:tableView];
        }
    }
    return _tableViews;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (change[@"new"]) {
        CGPoint point = [(NSValue *)change[@"new"] CGPointValue];
        if (point.y<=-200) {// 下拉
            [UIView animateWithDuration:0.25 animations:^{
                self.headerView.mj_origin = CGPointMake(0, 0);
            }];
        } else if (point.y >= 0) {
            [UIView animateWithDuration:0.25 animations:^{
                self.headerView.mj_origin = CGPointMake(0, -200);
            }];
        } else {
            self.headerView.mj_origin = CGPointMake(0, -200 - point.y);
        }
        currentChangeY = point.y;
    }
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _scrollView.backgroundColor = [UIColor cyanColor];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}
- (NSMutableArray *)gestures {
    if (!_gestures) {
        _gestures = [NSMutableArray array];
    }
    return _gestures;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
        _headerView.backgroundColor = [UIColor cyanColor];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, kScreenWidth-80, 200)];
        imageV.image = [UIImage imageNamed:@"bgImage"];
        [_headerView addSubview:imageV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 40)];
        label.text = @"添加tags 点击";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor blueColor];
        [_headerView addSubview:label];
    }
    return _headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableViews[0]) {
        BackCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BackCell class]) forIndexPath:indexPath];
        cell.str = self.datas[indexPath.row];
        cell.back = self.colors[indexPath.row];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
        cell.backgroundColor = self.colors[299 - indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"2333");
}

// 手势
- (void)removeNowGestureRecognizerToAddNewGestureRecognizers:(NSArray *)gestureRecognizers {
    //移除主scrollView原有手势操作
    NSMutableArray *list = [NSMutableArray arrayWithArray:self.gestureRecognizers];
    for (UIGestureRecognizer *gestureRecognizer in list) {
        [self removeGestureRecognizer:gestureRecognizer];
    }
    //将需要的手势操作加到主scrollView中
    for (UIGestureRecognizer *gestureRecognizer in gestureRecognizers) {
        [self addGestureRecognizer:gestureRecognizer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        CGFloat contentOffset = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (contentOffset < 0 || contentOffset > self.tableViews.count - 1) {
            return;
        }
        NSInteger index = (NSInteger)contentOffset;
        
        CGFloat progress = contentOffset - index;
        
        if (progress == 0) {
            currentIndex = index;
            [self removeNowGestureRecognizerToAddNewGestureRecognizers:self.gestures[currentIndex]];
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        
        if (_headerView.mj_origin.y <= 0) {
            NSLog(@"当前header的Y为<=0");
            for (UITableView *tableV in self.tableViews) {
                if (tableV == self.tableViews[currentIndex]) {
                    continue;
                }
                if (tableV.contentOffset.y < 0 && self.tableViews[currentIndex].contentOffset.y <= 0) {
                    
                    if (tableV.contentOffset.y <= self.tableViews[currentIndex].contentOffset.y) {
                        [tableV setContentOffset:CGPointMake(0, self.tableViews[currentIndex].contentOffset.y)];
                    }
                }
                if (tableV.contentOffset.y < 0 && self.tableViews[currentIndex].contentOffset.y > 0) {
                    [tableV setContentOffset:CGPointMake(0, 0)];
                }
                if (tableV.contentOffset.y >= 0 && self.tableViews[currentIndex].contentOffset.y <= 0) {
//                    [tableV setContentOffset:CGPointMake(0, self.tableViews[currentIndex].contentOffset.y)];
                }
            }
        } else if (_headerView.mj_origin.y >= -200) {
            NSLog(@"当前header的Y为>=-200");
        } else {
            NSLog(@"当前header的Y为0-200之间");
        }
    }
}
@end
