//
//  ProServicesCollectionViewCell.m
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 6/4/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "ProServicesCollectionViewCell.h"
#import "ProModel.h"
#import "Webservice.h"

@interface ProServicesCollectionViewCell()

@end

@implementation ProServicesCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.width)];
        [self.contentView addSubview:_avatarImage];
    }
    return self;
}

- (void)configure:(ProModel *)model webSerivce:(Webservice *)webService completion:(void(^)(UIImage *image))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [webService getImage:model.avatarURL success:^(NSData *data) {
//            UIImage *image = [[UIImage alloc] initWithData:data];
//            model.avatarImage = image;
//            completion(image);
//        } failure:^(NSError *error) {
//
//        }];
        [webService getImageFromRoute:model.avatarURL success:^(UIImage *image) {
            model.avatarImage = image;
            completion(image);
        } failire:^(NSError *error) {

        }];
    });
}

@end
