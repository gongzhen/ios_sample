//
//  ProServicesTableViewCell.h
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 5/23/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProModel;

@interface ProServicesTableViewCell : UITableViewCell

- (void)configure:(ProModel *)model index:(NSInteger)index;

@end
