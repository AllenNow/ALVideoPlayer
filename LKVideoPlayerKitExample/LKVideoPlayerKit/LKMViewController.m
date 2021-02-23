//
//  LKViewController.m
//  LKVideoPlayerKit
//
//  Created by allennow@126.com on 04/24/2020.
//  Copyright (c) 2020 allennow@126.com. All rights reserved.
//

#import "LKMViewController.h"
#import <Masonry/Masonry.h>
@import NEDMacros;
#import "LKMTestCell.h"

@interface LKMViewController () <UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *url;

/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 离开页面时候是否开始过播放 */
@property (nonatomic, assign) BOOL isStartPlay;

@end

@implementation LKMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKMTestCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(LKMTestCell.class)];
    NEDADVideoPlayerModel *model = [[NEDADVideoPlayerModel alloc] init];
    model.videoURLString = @"http://xiyou.sc.diyixin.com/dev-video-xiyou/20190823/15665420442175.mp4";
    model.lockTime = 130;
    model.title = @"街拍市场竞争的日趋激烈，清纯美女转型，靠性感博出位引得粉丝无数街拍市场竞争的日趋激烈，清纯美女转型，靠性感博出位引得粉丝无数";
    model.videoLabel = @"精彩推荐";
    [cell createPlayerWithModel:model indexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.rowHeight = UI_SCREEN_WIDTH * 9 / 16.0;
        [_tableView registerClass:[LKMTestCell class] forCellReuseIdentifier:NSStringFromClass(LKMTestCell.class)];
    }
    return _tableView;
}

@end
