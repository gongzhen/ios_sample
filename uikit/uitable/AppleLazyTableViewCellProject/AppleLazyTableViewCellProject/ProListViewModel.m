//
//  ProListViewModel.m
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 4/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "ProListViewModel.h"
#import "Webservice.h"


/// static NSString *const TopPaidAppsFeed = @"http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=75/xml";
/// https://dev.mobilestyles.com/users?query=HAIRCUT&lat=34.119302&lng=-118.256236
static NSString *const TopPaidAppsFeed = @"https://dev.mobilestyles.com/users?query=HAIRCUT&lat=34.119302&lng=-118.256236";

@interface ProListViewModel()

@property(strong, nonatomic) Webservice* webService;

@end

@implementation ProListViewModel

- (instancetype)initWithService:(Webservice *)webService {
    if(self = [super init]) {
        self.webService = webService;
    }
    return self;
}


- (void)getProList:(void(^)(NSArray *))proList {
    NSURL *url = [NSURL URLWithString:TopPaidAppsFeed];
    [self.webService get:url callBack:^(NSArray *results) {
        
    }];
}


@end
