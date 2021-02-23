//
//  LKMTestCell.m
//  LKVideoPlayerKit_Example
//
//  Created by Allen Gao on 2021/2/23.
//  Copyright © 2021 allennow@126.com. All rights reserved.
//

#import "LKMTestCell.h"
#import <NEDADVideoPlayer.h>
#import <NEDADPalyerKit.h>
@import Masonry;

@interface LKMTestCell()<NEDADVideoPlayerDelegate>

@property (nonatomic, strong) NEDADVideoPlayer *player;
@property (nonatomic, strong) UIView *playerView;

@end

@implementation LKMTestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self __setupSubviews];
    }
    return self;
}

- (void)__setupSubviews {
    [self.contentView addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}


- (void)playerWillOpenAD:(NEDADVideoPlayer *)player {
    dispatch_after(3000, dispatch_get_main_queue(), ^{
        [self.player unLockVideo];
    });
}

- (void)createPlayerWithModel:(NEDADVideoPlayerModel *)model indexPath:(NSIndexPath *)indexPath {
    self.player = [[NEDADPalyerKit defaultKit] createPlayerWithView:self.playerView delegate:self playerModel:model indexPath:indexPath];
}

- (UIView *)playerView {
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
    }
    return _playerView;
}

@end
