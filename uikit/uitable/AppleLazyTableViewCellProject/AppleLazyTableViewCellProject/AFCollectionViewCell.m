//
//  AFCollectionViewCell.m
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 6/27/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "AFCollectionViewCell.h"
#import "ProModel.h"
#import "Webservice.h"
#import "UIImageView+AFNetworking.h"

@interface AFCollectionViewCell()

@end

@implementation AFCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.width)];
        [self.contentView addSubview:_avatarImage];
    }
    return self;
}

- (void)configure:(ProModel *)model webSerivce:(Webservice *)webService completion:(void(^)(UIImage *image))completion {
    NSString *imgURL;
    if ([model.avatarURL rangeOfString:@"http"].location != NSNotFound) {
        imgURL = model.avatarURL;
    } else {
        imgURL = [NSString stringWithFormat:@"https://s3.amazonaws.com/mobilestyles/%@", model.avatarURL];
    }
    [self.avatarImage setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
}

@end
