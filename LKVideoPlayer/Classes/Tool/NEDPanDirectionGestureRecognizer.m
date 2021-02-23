//
//  NEDPanDirectionGestureRecognizer.m
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/23.
//

#import "NEDPanDirectionGestureRecognizer.h"

@interface NEDPanDirectionGestureRecognizer()

@property (nonatomic, assign) NEDPanGestureRecognizerDirection direction;

@end

@implementation NEDPanDirectionGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action andDirection:(NEDPanGestureRecognizerDirection)direction {
    self = [super initWithTarget:target action:action];
    if (self) {
        self.direction = direction;
    }
    return self;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if(self.state == UIGestureRecognizerStateBegan){
        CGPoint velocity =  [self velocityInView:self.view];
        switch (self.direction) {
            case NEDPanGestureRecognizerDirectionHorizontal:
                if (fabs(velocity.y) > fabs(velocity.x)) {
                    self.state = UIGestureRecognizerStateCancelled;
                }
                break;
            case NEDPanGestureRecognizerDirectionVertical:
                if (fabs(velocity.x) > fabs(velocity.y)) {
                    self.state = UIGestureRecognizerStateCancelled;
                }
                break;
            default:
                break;
        }
    }
}

@end
