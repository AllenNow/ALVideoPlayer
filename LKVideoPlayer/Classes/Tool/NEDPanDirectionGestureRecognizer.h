//
//  NEDPanDirectionGestureRecognizer.h
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NEDPanGestureRecognizerDirection) {
    NEDPanGestureRecognizerDirectionVertical,
    NEDPanGestureRecognizerDirectionHorizontal
};

@interface NEDPanDirectionGestureRecognizer : UIPanGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action andDirection:(NEDPanGestureRecognizerDirection)direction;

@end

NS_ASSUME_NONNULL_END
