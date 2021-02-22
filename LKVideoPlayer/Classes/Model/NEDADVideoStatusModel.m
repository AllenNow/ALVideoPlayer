//
//  NEDADVideoPlayer
//
//  Created by Allen Gao on 2021/2/20.
//

#import "NEDADVideoStatusModel.h"

@implementation NEDADVideoStatusModel

/**
 重置状态模型属性
 */
- (void)playerResetStatusModel {
    self.autoPlay = NO;
    self.playDidEnd = NO;
    self.dragged = NO;
    self.didEnterBackground = NO;
    self.pauseByUser = YES;
    self.fullScreen = NO;
}
@end
