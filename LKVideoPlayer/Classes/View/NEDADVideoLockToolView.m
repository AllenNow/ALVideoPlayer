//
//  NEDADVideoLockToolView.m
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/23.
//

#import "NEDADVideoLockToolView.h"
@import NEDMacros;
@import Masonry;

@interface NEDADVideoLockToolView ()

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *unLockButton;
@property (nonatomic, copy) void (^action)(void);

@end

@implementation NEDADVideoLockToolView

- (instancetype)initWithAction:(void (^)(void))action {
    self = [super init];
    if (self) {
        self.action = action;
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
    [self addSubview:self.tipsLabel];
    [self addSubview:self.unLockButton];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(16);
        make.top.bottom.inset(10);
    }];
    
    [self.unLockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(self.tipsLabel);
        make.left.mas_equalTo(self.tipsLabel.mas_right);
    }];
}

- (NSString *)createTimeString:(NSInteger)time {
    NSInteger second = time % 60;
    NSInteger minute = time / 60 % 60;
    NSInteger hour = time / (60 * 60);
    
    NSString *timeString = [NSString stringWithFormat:@"%ld秒", (long)second];
    if (hour > 0) {
        timeString = [[NSString stringWithFormat:@"%ld小时%ld分", (long)hour,(long)minute] stringByAppendingString:timeString];
    } else if (minute > 0) {
        timeString = [[NSString stringWithFormat:@"%ld分", (long)minute] stringByAppendingString:timeString];
    }
    return timeString;
}

- (void)__tapAction {
    if (self.action) {
        self.action();
    }
}

- (UIButton *)unLockButton {
    if (!_unLockButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"解锁视频" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xD33333) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(__tapAction) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = NEDFontMedium(12);
        _unLockButton = button;
    }
    return _unLockButton;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 1;
        label.font =  NEDFontMedium(12);
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (void)setLockSecond:(NSInteger)lockSecond {
    _lockSecond = lockSecond;
    
    NSString * timeString = [self createTimeString:lockSecond];
    NSString *string = [NSString stringWithFormat:@"免费观看前%@，完整观看请解锁视频",timeString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName
                         value:UIColorFromRGB(0xD33333)
                         range:[string rangeOfString:timeString]];
    self.tipsLabel.attributedText = attributedString;
}

@end
