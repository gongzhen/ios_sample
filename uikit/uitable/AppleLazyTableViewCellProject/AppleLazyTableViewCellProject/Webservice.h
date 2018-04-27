//
//  Webservice.h
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 4/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Success)(NSArray *results);

@interface Webservice : NSObject

- (void) get:(NSURL *)url callBack:(Success)success;

@end
