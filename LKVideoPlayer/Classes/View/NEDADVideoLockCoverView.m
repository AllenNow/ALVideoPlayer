//
//  NEDADVideoLockView.m
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/22.
//

#import "NEDADVideoLockCoverView.h"
#import "NEDADVideoTitleBar.h"
#import "NEDADVideoPlayerImage.h"
@import NEDMacros;
@import Masonry;

@interface NEDADVideoLockCoverView ()

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *actionIcon;
@property (nonatomic, strong) UILabel *actionTitleLabel;
@property (nonatomic, strong) UIView *actionContainer;
@property (nonatomic, strong) NEDADVideoTitleBar *titleBar;
@property (nonatomic, copy) void (^action)(void);

@end

@implementation NEDADVideoLockCoverView


/// 无标题类型
- (instancetype)initWithAction:(void (^)(void))action {
    self = [super init];
    if (self) {
        self.action = action;
        [self __setupSubviews];
    }
    return self;
}


- (void)__setupSubviews {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.actionContainer];
    [self.actionContainer addSubview:self.actionIcon];
    [self.actionContainer addSubview:self.actionTitleLabel];
    [self addSubview:self.descLabel];
    
    [self.actionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(37);
        make.top.bottom.inset(10);
    }];
    
    [self.actionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.actionIcon.mas_right).offset(8);
        make.right.inset(40);
        make.centerY.mas_equalTo(self.actionIcon);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.actionContainer.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.actionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
}

- (void)tapAction {
    if (self.action) {
        self.action();
    }
}

/// 有标题的类型
/// @param title 视频标题内容
/// @param label 视频标签内容
- (void)updateTitle:(NSString *)title label:(NSString *)label {
    BOOL hasTitle = title && ![title isEqualToString:@""];
    if (hasTitle) {
        [self addSubview:self.titleBar];
        [self.titleBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
        }];
        
        [self.actionContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleBar.mas_bottom).offset(26);
            make.centerX.mas_equalTo(self);
        }];
        self.titleBar.label = label;
        self.titleBar.title = title;
    } else {
        [self.titleBar removeFromSuperview];
        [self.actionContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
    }
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 1;
        label.text = @"观看广告后可永久解锁该视频";
        _descLabel = label;
    }
    return _descLabel;
}

- (UILabel *)actionTitleLabel {
    if (!_actionTitleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 1;
        label.text = @"立即解锁";
        _actionTitleLabel = label;
    }
    return _actionTitleLabel;
}

- (UIView *)actionContainer {
    if (!_actionContainer) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xD33333);
        view.layer.cornerRadius = 4;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [view addGestureRecognizer:tap];
        _actionContainer = view;
    }
    return _actionContainer;
}

- (NEDADVideoTitleBar *)titleBar {
    if (!_titleBar) {
        _titleBar = [[NEDADVideoTitleBar alloc] init];
    }
    return _titleBar;
}

- (UIImageView *)actionIcon {
    if (!_actionIcon) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[NEDADVideoPlayerImage imageNamed:@"icon_advideo_tv"]];
        _actionIcon = imageView;
    }
    return _actionIcon;
}

- (void)setIsPreview:(BOOL)isPreview {
    _isPreview = isPreview;
    self.descLabel.text = isPreview ? @"试看结束，观看广告后可永久解锁该视频" : @"观看广告后可永久解锁该视频";
    if (isPreview) {
        [self updateTitle:nil label:nil];
    }
}

- (void)hide {
    self.hidden = YES;
}

- (void)show {
    self.hidden = NO;
}

@end
