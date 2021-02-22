//
//  NEDADVideoLockView.m
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/22.
//

#import "NEDADVideoLockView.h"
#import "NEDADVideoTitleBar.h"
#import "NEDADVideoPlayerImage.h"
@import NEDMacros;
@import Masonry;

@interface NEDADVideoLockView ()

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *actionIcon;
@property (nonatomic, strong) UILabel *actionTitleLabel;
@property (nonatomic, strong) UIView *actionContainer;
@property (nonatomic, strong) NEDADVideoTitleBar *titleBar;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *label;

@end

@implementation NEDADVideoLockView


/// 无标题类型
- (instancetype)initWithAction:(void (^)(void))action {
    self = [super init];
    if (self) {
        [self __setupSubviews];
    }
    return self;
}

/// 有标题的类型
/// @param title 视频标题内容
/// @param label 视频标签内容
- (instancetype)initWithTitle:(NSString *)title label:(NSString *)label {
    self = [super init];
    if (self) {
        self.title = title;
        self.label = label;
    }
    return self;
}

- (void)__setupSubviews {
    self.backgroundColor = [UIColor clearColor];
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
    
    BOOL hasTitle = self.title && ![self.title isEqualToString:@""];
    if (hasTitle) {
        [self addSubview:self.titleBar];
        [self.titleBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
        }];
        
        [self.actionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleBar.mas_bottom).offset(26);
            make.centerX.mas_equalTo(self);
        }];
        
    } else {
        [self.actionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
    }
}

- (void)tapAction {
    
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
}

@end
