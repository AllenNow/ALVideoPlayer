//
//  NEDADVideoLoadingView.m
//  NEDADVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import "NEDADVideoLoadingView.h"
#import "LKMaterialDesignSpinner.h"
#import "NEDADVideoPlayerImage.h"
@import Masonry;

@interface NEDADVideoLoadingView ()

@property (nonatomic, strong) LKMaterialDesignSpinner *activity;

@end

@implementation NEDADVideoLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.activity];
        
        [self makeSubViewsConstraints];
        
        self.backgroundColor = [UIColor blackColor];
        
        // 拦截手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction)];
        [doubleTap setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTap];
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection)];
        [self addGestureRecognizer:panRecognizer];
        
        [self.activity startAnimating];
    }
    return self;
}

#pragma mark - Action
- (void)tapAction {}
- (void)doubleTapAction {}
- (void)panDirection {}

#pragma mark - 添加子控件约束
- (void)makeSubViewsConstraints {
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.with.height.mas_equalTo(45);
    }];
}

#pragma mark - getter

- (LKMaterialDesignSpinner *)activity {
    if (!_activity) {
        _activity = [[LKMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 1;
        _activity.duration  = 1;
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
    return _activity;
}

@end
