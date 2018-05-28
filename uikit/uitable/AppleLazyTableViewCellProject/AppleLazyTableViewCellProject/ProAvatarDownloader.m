//
//  ProAvatarDownloader.m
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 5/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "ProAvatarDownloader.h"
#import "ProServicesTableViewCell.h"
#import "Webservice.h"
#import "Constants.h"

@interface ProAvatarDownloader()

@end

@implementation ProAvatarDownloader

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)startDownload:(NSString *)urlString webService:(Webservice *)webService{
    [webService getImage:urlString success:^(NSData *data) {
        UIImage *image = [[UIImage alloc] initWithData:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{

            // Set appIcon and clear temporary data/image

            if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
            {
                CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [image drawInRect:imageRect];
                self.avatarImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            else
            {
                self.avatarImage = image;
            }
//            DLog(@"self.avatarImage：%@", self.avatarImage);
            // call our completion handler to tell our client that our icon is ready for display
            if(self.completionHandler != nil) {
                self.completionHandler();
            }
        }];
        
    } failure:^(NSError *error) {
    }];
    
}

- (void)cancelDownload {
    
}
@end
