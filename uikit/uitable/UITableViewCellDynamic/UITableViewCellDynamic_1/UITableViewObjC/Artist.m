//
//  Artist.m
//  UITableViewCellDynamic_1
//
//  Created by gongzhen on 12/4/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "Artist.h"
#import "Work.h"

@implementation Artist


- (instancetype)initWithName:(NSString *)name
                         bio:(NSString *)bio
                       image:(UIImage *)image
                       works:(NSMutableArray *)works {
    self = [super init];
    if (self) {
        _name = name;
        _bio = bio;
        _image = image;
        _works = [[NSMutableArray alloc] initWithArray:works];
    }
    return self;
}

+ (NSMutableArray *)artistsFromBundle {
    NSMutableArray *artists = [[NSMutableArray alloc] init];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"artists" withExtension:@"json"];
    
    if (!url) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url];
    id rootObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error: &error];
    
    if ([rootObject isKindOfClass:NSDictionary.class]) {
        id artistObjects = [rootObject objectForKey:@"artists"];
        
        if ([artistObjects isKindOfClass:NSArray.class]) {
            // DLog(@"artistObjects %@", artistObjects);
            
            for (id artistObject in artistObjects) {
                
                if ([artistObject objectForKey:@"name"] != [NSNull null]) {
                    NSString *name = [artistObject objectForKey:@"name"];
                    if ([name isEqualToString:@""] == NO) {
                        NSString *bio = [artistObject objectForKey:@"bio"];
                        NSString *imageName = [artistObject objectForKey:@"image"];
                        UIImage *image = [UIImage imageNamed:imageName];
                        id workObjects = [artistObject objectForKey:@"works"];
                        NSMutableArray *works = [NSMutableArray array];
                        if ([workObjects isKindOfClass:NSArray.class]) {
                            for (id workObject in workObjects) {
                                if ([workObject objectForKey:@"title"] != [NSNull null]) {
                                    NSString* workTitle = [workObject objectForKey:@"title"];
                                    if ([workTitle isEqualToString:@""] == NO) {
                                        NSString *workImageName = [workObject objectForKey:@"image"];
                                        UIImage *workImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", workImageName]];
                                        NSString *info = [workObject objectForKey:@"info"];
                                        Work *work = [[Work alloc] initWithTitle:workTitle image:workImage info:info isExpanded:false];
                                        [works addObject:work];
                                    }
                                }
                            }
                            
                            Artist *artist = [[Artist alloc] initWithName:name bio:bio image:image works:works];
                            [artists addObject:artist];
                        }
                    }
                }
            }
        }
    }
    
    return artists;
}

@end
