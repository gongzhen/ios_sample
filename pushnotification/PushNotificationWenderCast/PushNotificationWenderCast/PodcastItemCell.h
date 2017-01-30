//
//  PodcastItemCell.h
//  PushNotificationWenderCast
//
//  Created by gongzhen on 1/7/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PodcastItem.h"

@interface PodcastItemCell : UITableViewCell

- (void)updateWithPodcastItem:(PodcastItem *)item;

@end
