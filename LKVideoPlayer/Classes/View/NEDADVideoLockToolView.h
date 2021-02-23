//
//  NEDADVideoLockToolView.h
//  LKVideoPlayer
//
//  Created by Allen Gao on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NEDADVideoLockToolView : UIView

@property (nonatomic, assign) NSInteger lockSecond;

- (instancetype)initWithAction:(void (^)(void))action;

@end

NS_ASSUME_NONNULL_END
