//
//  UIView+Add.m
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 5/28/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "UIView+Add.h"

@implementation UIView (Add)

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

@end
