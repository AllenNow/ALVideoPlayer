//
//  NEDADVideoGradientView.m
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/22.
//

#import "NEDADVideoGradientView.h"
@import NEDMacros;

@implementation NEDADVideoGradientView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __setupSubviews:frame];
    }
    return self;
}

- (void)__setupSubviews:(CGRect)frame {
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = frame;
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithWhite:0 alpha:0.6].CGColor,
                  (__bridge id)[UIColor colorWithWhite:0 alpha:0].CGColor];
    gl.locations = @[@(0),@(1.0f)];
    [self.layer addSublayer:gl];
}


@end
