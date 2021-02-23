//
//  LKMTestCell.h
//  LKVideoPlayerKit_Example
//
//  Created by Allen Gao on 2021/2/23.
//  Copyright © 2021 allennow@126.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NEDADVideoPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKMTestCell : UITableViewCell

@property (nonatomic, strong) NEDADVideoPlayerModel *model;

- (void)createPlayerWithModel:(NEDADVideoPlayerModel *)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
