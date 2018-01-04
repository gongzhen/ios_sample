//
//  CollapsibleTableViewHeader.m
//  CollapseTableView
//
//  Created by Zhen Gong on 12/15/17.
//  Copyright © 2017 Zhen Gong. All rights reserved.
//

#import "CollapsibleTableViewHeader.h"

@implementation CollapsibleTableViewHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setCollapsed:(BOOL)collapsed {
    if(collapsed == YES) {
        self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
    } else {
        self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
    }
}

- (void)updateHeader:(NSString *)headerTitle {

}

@end
