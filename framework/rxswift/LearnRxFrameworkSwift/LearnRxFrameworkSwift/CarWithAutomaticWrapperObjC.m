//
//  CarWithAutomaticWrapperObjC.m
//  LearnRxFrameworkSwift
//
//  Created by Zhen Gong on 5/19/19.
//  Copyright © 2019 Zhen Gong. All rights reserved.
//

#import "CarWithAutomaticWrapperObjC.h"

typedef void(^AutomaticSpeedUpdateHandler)(float);

@interface ObserverTokenObjCClass: NSObject
@property(nonatomic, assign) void (^unsubscribe)(void);
@end

@implementation ObserverTokenObjCClass

- (instancetype)initWithUnsubscribe:(void (^)(void))unsubscribe {
    self = [super init];
    if (self) {
        _unsubscribe = unsubscribe;
    }
    return self;
}

- (void)dealloc {
    self.unsubscribe();
}

@end

@interface SpeedUpdateHandlerWrapperObjC: NSObject
@property (copy, nonatomic) NSString *identity;
@property (assign, nonatomic) AutomaticSpeedUpdateHandler observer;
@end

@implementation SpeedUpdateHandlerWrapperObjC

- (instancetype)initWithObserver:(AutomaticSpeedUpdateHandler)observer {
    self = [super init];
    if (self) {
        self.observer = observer;
    }
    return self;
}

@end

@interface CarWithAutomaticWrapperObjC()

@property (strong, nonatomic) NSMutableArray<SpeedUpdateHandlerWrapperObjC *> *observers;
@property (assign, nonatomic) CGFloat speed;
                              
@end

@interface SpeedometerObjC : NSObject
@property(strong, nonatomic)CarWithAutomaticWrapperObjC *car;
@property(strong, nonatomic)ObserverTokenObjCClass *observerToken;

- (instancetype)initWith:(CarWithAutomaticWrapperObjC *)car;

@end

@implementation CarWithAutomaticWrapperObjC

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
    _speed = speed;
    for (SpeedUpdateHandlerWrapperObjC *wrapper in self.observers) {
        wrapper.observer(speed);
    }
}

- (ObserverTokenObjCClass *)addObserver:(AutomaticSpeedUpdateHandler)observer {
    SpeedUpdateHandlerWrapperObjC* wrapper = [[SpeedUpdateHandlerWrapperObjC alloc] initWithObserver:observer];
    [self.observers addObject:wrapper];
    ObserverTokenObjCClass *token = [[ObserverTokenObjCClass alloc] initWithUnsubscribe:^{
        
    }];
    return token;
}

- (void)removeObserver:(NSString *)token {
    [self.observers filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        SpeedUpdateHandlerWrapperObjC *wrapperObject = (SpeedUpdateHandlerWrapperObjC *)evaluatedObject;
        if ([wrapperObject.identity isEqualToString:token]) {
            return NO;
        }
        return YES;
    }]];
}

- (void)accelerateAmount:(CGFloat)amount {
    self.speed += amount;
}

- (void)main {
    CarWithAutomaticWrapperObjC* car = [CarWithAutomaticWrapperObjC new];
    SpeedometerObjC *speedometer = [[SpeedometerObjC alloc] initWith:car];
    [car accelerateAmount:10];
    [car accelerateAmount:20];
    speedometer = nil;
    [car accelerateAmount:30];
}

@end

@implementation SpeedometerObjC

- (instancetype)initWith:(CarWithAutomaticWrapperObjC *)car {
    self = [super init];
    if (self) {
        self.car = car;
        self.observerToken = [car addObserver:^(float speed) {
            [self showSpeed:speed];
        }];
    }
    return self;
}

- (void)showSpeed:(CGFloat)speed {
    NSLog(@"New speed %.02f", speed);
}

@end
