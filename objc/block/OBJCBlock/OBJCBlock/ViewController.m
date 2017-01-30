//
//  ViewController.m
//  OBJCBlock
//
//  Created by gongzhen on 11/27/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ViewController.h"

@interface TestCell : NSObject

@property(nonatomic, strong) NSString *sizeLabelText;

@end

@implementation TestCell


- (instancetype)initWithLabelText:(NSString *)text {
    self = [super init];
    if (self) {
        self.sizeLabelText = text;
    }
    return self;
}

@end

@interface ViewController ()

@end

static int count = 1;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat height = [self testBlockFunction:1
                               forIdentifier:@"cell"
                                 configBlock:^(TestCell* cell, NSString* text) {
                                     cell.sizeLabelText = text;
                                     DLog(@"cell: %@", cell);
                                     DLog(@"text: %@", text);
    }];
    DLog(@"height: %ff", height);
    
    height = [self testBlockFunction:2
                       forIdentifier:@"cell"
                         configBlock:nil];
    DLog(@"height:%ff", height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)testBlockFunction:(NSInteger)index
               forIdentifier:(NSString *)identifier
                 configBlock:(void (^)(id cell, id model))configBlack {
    TestCell *cell = [[TestCell alloc] initWithLabelText:@"cellLabel"];
    id model = cell.sizeLabelText;
    count++;
    DLog(@"count %d", count);
    if (configBlack) {
        DLog(@"configBlock: %@", configBlack);
        configBlack(cell, model);
    }
    
    CGFloat height = 0;
    height += 1.f;
    DLog(@"height %f", height);
    return height;
}

@end
