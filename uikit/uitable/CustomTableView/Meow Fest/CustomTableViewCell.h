//
//  CustomTableViewCell.h
//  Meow Fest
//
//  Created by ULS on 3/21/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellModel;

@interface CustomTableViewCell : UITableViewCell

- (void)configure:(CellModel *)model completion:(void(^)(UIImage *image))completion;

@end
