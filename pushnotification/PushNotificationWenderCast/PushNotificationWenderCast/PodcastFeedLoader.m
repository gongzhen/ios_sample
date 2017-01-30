//
//  PodcastFeedLoader.m
//  PushNotificationWenderCast
//
//  Created by gongzhen on 1/7/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "PodcastFeedLoader.h"
#import <UIKit/UIKit.h>
#import "PodcastItem.h"
#import "DateParser.h"

NSString *const FeedURL = @"https://www.raywenderlich.com/category/podcast/feed";

@interface PodcastFeedLoader ()

@property (nonatomic, strong) NSXMLParser *xmlParser;

@property (nonatomic, strong) NSMutableArray *arrNeighboursData;

@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage;

@property (nonatomic, strong) NSMutableString *foundValue;

@property (nonatomic, strong) NSString *currentElement;

@property (nonatomic, strong) NSArray *feedItems;

@end

@implementation PodcastFeedLoader

-(void)loadFeed:(void(^)(NSArray *))completion {
    NSURL *url = [NSURL URLWithString:FeedURL];
    if (!url) {
        return ;
    }
    
    // __weak typeof(self)weakSelf = self;
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (statusCode != 200) {
                return;
            }
        }
        
        if (data && [data isKindOfClass:[NSData class]]) {
            self.xmlParser = [[NSXMLParser alloc] initWithData:data];
            self.xmlParser.delegate = self;
            
            self.foundValue = [[NSMutableString alloc] init];
            
            [self.xmlParser parse];
            
            NSMutableArray *items = [NSMutableArray array];
            for (id data in self.arrNeighboursData) {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    NSString *title = [data objectForKey:@"title"];
                    NSDate *pubDate = [DateParser dateWithPodcastDateString:[data objectForKey:@"pubDate"]];
                    
                    NSString *link = [data objectForKey:@"link"];
                    PodcastItem *item = [[PodcastItem alloc] initWithTitle:title publishDate:pubDate link:link];
                    [items addObject:item];
                }
            }
            _feedItems = [items copy];
            completion(_feedItems);
        }
    }] resume];
}

#pragma mark

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.arrNeighboursData = [[NSMutableArray alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    // DLog(@"%@", self.arrNeighboursData);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    DLog(@"%@", [parseError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if ([elementName isEqualToString:@"item"]) {
        self.dictTempDataStorage = [[NSMutableDictionary alloc] init];
    }
    
    self.currentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"item"]) {
        [self.arrNeighboursData addObject:[[NSDictionary alloc] initWithDictionary:self.dictTempDataStorage]];
    } else if ([elementName isEqualToString:@"title"]) {
        // DLog(@"%@", self.foundValue);
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"title"];
    } else if ([elementName isEqualToString:@"pubDate"]) {
        // DLog(@"%@", self.foundValue);
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"pubDate"];
    } else if ([elementName isEqualToString:@"link"]) {
        // DLog(@"%@", self.foundValue);
        [self.dictTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"link"];
    }
    
    [self.foundValue setString:@""];

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.currentElement isEqualToString:@"pubDate"] ||
        [self.currentElement isEqualToString:@"title"] ||
        [self.currentElement isEqualToString:@"link"]) {
        if (![string isEqualToString:@"\n"]) {
            [self.foundValue appendString:string];
        }
    }
}

@end
