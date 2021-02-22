//
//  NEDADVideoTitleBar.m
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/22.
//

#import "NEDADVideoTitleBar.h"
@import NEDMacros;
@import Masonry;

@interface NEDADVideoTitleBar ()

@property (nonatomic, strong) UILabel *labelLabel;
@property (nonatomic, strong) UIView *labelContainer;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation NEDADVideoTitleBar

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
    [self addSubview:self.titleLabel];
    [self addSubview:self.labelContainer];
    [self.labelContainer addSubview:self.labelLabel];
    
    [self.labelContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(13);
    }];
    
    [self.labelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.inset(4);
        make.top.bottom.inset(1);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.inset(16);
        make.top.mas_equalTo(12);
    }];
}

- (UILabel *)labelLabel {
    if (!_labelLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 1;
        label.text = @"精彩推荐";
        _labelLabel = label;
    }
    return _labelLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        label.numberOfLines = 2;
        label.text = @"              大热的智能家居风口，小豚当家靠什么“出道”即“出位”大热的智能家居风口，小豚当家靠什么“出道”即“出位”";
        
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIView *)labelContainer {
    if (!_labelContainer) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xD33333);
        view.layer.cornerRadius = 2;
        _labelContainer = view;
    }
    return _labelContainer;
}

- (void)setLabel:(NSString *)label {
    _label = label;
    if (self.label && ![self.label isEqualToString:@""]) {
        self.labelContainer.hidden = NO;
    } else {
        self.labelContainer.hidden = YES;
    }
    self.labelLabel.text = label;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    if (self.label && ![self.label isEqualToString:@""]) {
        self.titleLabel.text = [NSString stringWithFormat:@"    %@",title];
    } else {
        self.titleLabel.text = title;
    }
}

@end
