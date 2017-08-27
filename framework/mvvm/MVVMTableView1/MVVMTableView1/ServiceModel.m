//
//  ServiceModel.m
//  MVVMTableView1
//
//  Created by zhen gong on 8/7/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ServiceModel.h"
#import <UIKit/UIKit.h>

@interface ServiceModel()

@property(nonatomic, strong) NSArray *allOptions;
@property(nonatomic, strong) NSArray *hairOptions;
@property(nonatomic, strong) NSArray *careOptions;
@property(nonatomic, strong) NSArray *childrenOptions;
@property(nonatomic, strong) NSArray *makeUpOptions;

@end

@implementation ServiceModel

- (instancetype)init {
    if(self = [super init]) {
        _hairOptions = @[@"BARBER",
                         @"HAIRCUT",
                         @"EXTENSIONS",
                         @"TWISTS",
                         @"COLOR",
                         @"NATURAL",
                         @"STYLE",
                         @"STRAIGHTEN",
                         @"BRAIDS",
                         @"WEAVES"];

        _careOptions = @[@"NAILS",
                         @"ESTHETICIAN",
                         @"MASSAGE",
                         @"TANNING"];
        
        _makeUpOptions = @[@"FULL FACE",
                           @"GLAM",
                           @"AIR BRUSH",
                           @"WEDDING"];
        
        _childrenOptions = @[@"TODDLERS",
                            @"TEENAGE BOYS",
                            @"TEENAGE GIRLS",
                            @"YOUNG BOYS",
                            @"YOUNG GIRLS"];
        _allOptions = [@[_hairOptions, _makeUpOptions, _careOptions, _childrenOptions] valueForKeyPath: @"@unionOfArrays.self"];
        _dataSource = @[
                        @{@"name": @"HAIR", @"options": _hairOptions},
                        @{@"name": @"MAKE UP", @"options": _makeUpOptions},
                        @{@"name": @"CARE", @"options": _careOptions},
                        @{@"name": @"ALL", @"options": _allOptions}
                        ];
    }
    return  self;
}

@end
