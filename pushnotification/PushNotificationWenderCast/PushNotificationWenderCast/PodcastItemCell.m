//
//  PodcastItemCell.m
//  PushNotificationWenderCast
//
//  Created by gongzhen on 1/7/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "PodcastItemCell.h"
#import "DateParser.h"

@implementation PodcastItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithPodcastItem:(PodcastItem *)item {
    DLog(@"%@", item.title);DLog(@"%@", item.publishedDate)
    self.textLabel.text = item.title;
    self.detailTextLabel.text = [DateParser displayStringForDate:item.publishedDate];
}

@end
