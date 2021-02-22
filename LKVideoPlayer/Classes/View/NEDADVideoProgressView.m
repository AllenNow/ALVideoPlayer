//
//  NEDADVideoProgressView.m
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/22.
//

#import "NEDADVideoProgressView.h"
@import NEDMacros;
@import Masonry;

@interface NEDADVideoProgressView ()

@property (nonatomic, strong) UIProgressView *playProgressView;
@property (nonatomic, strong) UIProgressView *cacheProgressView;

@end

@implementation NEDADVideoProgressView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self __setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __setupSubviews];
    }
    return self;
}

- (void)__setupSubviews {
    [self addSubview:self.cacheProgressView];
    [self addSubview:self.playProgressView];
    
    [self.cacheProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.playProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
        if (mode == UIUserInterfaceStyleDark) {
            self.cacheProgressView.progressTintColor = UIColorFromRGB(0x8F8F8F);
            self.cacheProgressView.trackTintColor = UIColorFromRGB(0x3A3A3A);
        } else {
            self.cacheProgressView.progressTintColor = [UIColor whiteColor];
            self.cacheProgressView.trackTintColor = UIColorFromRGB(0xCCCCCC);
        }
    }
}

- (UIProgressView *)playProgressView {
    if (!_playProgressView) {
        _playProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _playProgressView.progressTintColor =  UIColorFromRGB(0xD33333);
        _playProgressView.trackTintColor  = [UIColor clearColor];
        _playProgressView.tintColor = [UIColor whiteColor];
    }
    return _playProgressView;
}

- (UIProgressView *)cacheProgressView {
    if (!_cacheProgressView) {
        _cacheProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _cacheProgressView.progressTintColor = [UIColor whiteColor];
        _cacheProgressView.trackTintColor = UIColorFromRGB(0xCCCCCC);
    }
    return _cacheProgressView;
}

- (void)setPlayProgress:(CGFloat)playProgress {
    _playProgress = playProgress;
    self.playProgressView.progress = playProgress;
}

- (void)setCacheProgress:(CGFloat)cacheProgress {
    _cacheProgress = cacheProgress;
    self.cacheProgressView.progress = cacheProgress;
}

@end
