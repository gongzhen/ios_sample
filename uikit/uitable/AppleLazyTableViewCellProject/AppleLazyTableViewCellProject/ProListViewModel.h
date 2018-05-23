//
//  ProListViewModel.h
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 4/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GetProListModel)(void);

@class Webservice;

@interface ProListViewModel : NSObject

- (instancetype)initWithService:(Webservice *)webService;

- (void)getProListFromUrl:(NSURL *)url success:(void(^)(NSArray *))success;

@end
