//
//  CarWithClosureObjC.m
//  LearnRxFrameworkSwift
//
//  Created by Zhen Gong on 5/19/19.
//  Copyright © 2019 Zhen Gong. All rights reserved.
//

#import "CarWithClosureObjC.h"

typedef void(^SpeedUpdateHandler)(float);

@interface CarWithClosureObjC()

@property(nonatomic, assign)CGFloat speed;
@property(nonatomic, strong)NSMutableArray<SpeedUpdateHandler> *observers;

@end

@implementation CarWithClosureObjC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.speed = 0.f;
        self.observers = [NSMutableArray new];
    }
    return self;
}

// didSet speed.
- (void)setSpeed:(CGFloat)speed {
    for (SpeedUpdateHandler observer in self.observers) {
        _speed = speed;
        observer(speed);
    }
}

- (void)addObserver:(SpeedUpdateHandler)observer {
    [self.observers addObject:observer];
}

- (void)accelerateAmount:(CGFloat)amount {
    self.speed += amount;
}

- (void)main {
    [self observableClosure];
}

- (void)observableClosure {
    CarWithClosureObjC* car = [CarWithClosureObjC new];
    [car addObserver:^(float speed) {
        NSLog(@"didSet spped:%0.02f", speed);
    }];
    [car accelerateAmount:10];
    [car accelerateAmount:20];
    [car accelerateAmount:30];
}

@end
