//
//  NEDADVideoCoverControlView.m
//  NEDADVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import "NEDADVideoImageCoverView.h"
#import "NEDADVideoPlayerImage.h"
#import "NEDADVideoGradientView.h"
@import NEDMacros;
@import Masonry;
@import SDWebImage;

@interface NEDADVideoImageCoverView ()
/** 背景图片 */
@property (nonatomic, strong) UIImageView *backgroundImageView;
/** 播放Icon */
@property (nonatomic, strong) UIImageView *playerImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *timeContainer;
@property (nonatomic, strong) NEDADVideoGradientView *gradientView;

@end

@implementation NEDADVideoImageCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self __setupSubviews];
    }
    return self;
}

#pragma mark - Action

- (void)tapAction {
    if ([self.delegate respondsToSelector:@selector(coverControlViewDidClick:)]) {
        [self.delegate coverControlViewDidClick:self];
    }
}

#pragma mark - Public method
/** 更新封面图片 */
- (void)syncCoverImageViewWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[NEDADVideoPlayerImage imageNamed:@"bg_advideo_play_placeholder"]];;
}

#pragma mark - 添加子控件
- (void)__setupSubviews {
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.playerImageView];
    [self addSubview:self.countLabel];
    [self addSubview:self.gradientView];
    [self addSubview:self.timeContainer];
    [self.gradientView addSubview:self.titleLabel];
    [self.timeContainer addSubview:self.timeLabel];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    [self.playerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(75);
    }];
    
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(70);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(16);
        make.top.inset(10);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(16);
        make.bottom.inset(14);
    }];
    
    [self.timeContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(10);
        make.bottom.inset(14);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(5);
        make.top.bottom.inset(2);
    }];
}

#pragma mark - getter
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        _backgroundImageView.userInteractionEnabled = YES;
        [_backgroundImageView addGestureRecognizer:tapGes];
    }
    return _backgroundImageView;
}

- (UIImageView *)playerImageView {
    if (!_playerImageView) {
        _playerImageView = [[UIImageView alloc] init];
        _playerImageView.image = [NEDADVideoPlayerImage imageNamed:@"icon_advideo_play"];
        _playerImageView.contentMode = UIViewContentModeCenter;
    }
    return _playerImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        label.numberOfLines = 2;
        label.text = @"街拍市场竞争的日趋激烈，清纯美女转型，靠性感博出位引得粉丝无数街拍市场竞争的日趋激烈，清纯美女转型，靠性感博出位引得粉丝无数";
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10];
        label.numberOfLines = 1;
        label.text = @"0:12";
        _timeLabel = label;
    }
    return _timeLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 1;
        label.text = @"48.3万次观看";
        _countLabel = label;
    }
    return _countLabel;
}

- (UIView *)timeContainer {
    if (!_timeContainer) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.44];
        view.layer.cornerRadius = 2;
        _timeContainer = view;
    }
    return _timeContainer;
}

- (NEDADVideoGradientView *)gradientView {
    if (!_gradientView) {
        _gradientView = [[NEDADVideoGradientView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 70)];
    }
    return _gradientView;;
}

@end
