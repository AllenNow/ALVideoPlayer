//
//  LMCoverView.m
//  拉面视频Demo
//
//  Created by 李小南 on 16/9/26.
//  Copyright © 2016年 lamiantv. All rights reserved.
//  未播放状态下的封面

#import "LKCoverControlView.h"
#import "LKVideoPlayerImage.h"
@import Masonry;
@import SDWebImage;

@interface LKCoverControlView ()
/** 背景图片 */
@property (nonatomic, strong) UIImageView *backgroundImageView;
/** 播放Icon */
@property (nonatomic, strong) UIImageView *playerImageView;
@end

@implementation LKCoverControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.playerImageView];

        // 添加子控件的约束
        [self makeSubViewsConstraints];
        self.backgroundColor = [UIColor blackColor];
        [self makeSubViewsAction];
    }
    return self;
}

- (void)makeSubViewsAction {
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundImageViewTapAction)];
    self.backgroundImageView.userInteractionEnabled = YES;
    [self.backgroundImageView addGestureRecognizer:tapGes];
}

#pragma mark - Action

- (void)backgroundImageViewTapAction {
    if ([self.delegate respondsToSelector:@selector(coverControlViewBackgroundImageViewTapAction)]) {
        [self.delegate coverControlViewBackgroundImageViewTapAction];
    }
}

#pragma mark - Public method
/** 更新封面图片 */
- (void)syncCoverImageViewWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    // 设置网络占位图片
    if (urlString.length) {
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[LKVideoPlayerImage imageNamed:@"封面占位"]];;
    } else {
        self.backgroundImageView.image = placeholderImage;
    }
}

#pragma mark - 添加子控件约束
- (void)makeSubViewsConstraints {

    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self.playerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(75);
    }];
    
}


#pragma mark - getter
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
    }
    return _backgroundImageView;
}

- (UIImageView *)playerImageView {
    if (!_playerImageView) {
        _playerImageView = [[UIImageView alloc] init];
        _playerImageView.image = [LKVideoPlayerImage imageNamed:@"btn_playplus"];
        _playerImageView.contentMode = UIViewContentModeCenter;
    }
    return _playerImageView;
}

@end
