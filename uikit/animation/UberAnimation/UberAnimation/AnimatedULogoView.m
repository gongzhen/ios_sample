//
//  AnimatedULogoView.m
//  UberAnimation
//
//  Created by zhen gong on 4/20/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "AnimatedULogoView.h"
#import <QuartzCore/QuartzCore.h>

@interface AnimatedULogoView()

@property(strong, nonatomic)CAMediaTimingFunction *strokeEndTimingFunction;
@property(strong, nonatomic)CAMediaTimingFunction *squareLayerTimingFunction;
@property(strong, nonatomic)CAMediaTimingFunction *circleLayerTimingFunction;
@property(strong, nonatomic)CAMediaTimingFunction *fadeInSquareTimingFunction;

@property(assign, nonatomic)CGFloat radius;
@property(assign, nonatomic)CGFloat squareLayerLength;
@property(assign, nonatomic)CGFloat startTimeOffset;

@property(strong, nonatomic)CAShapeLayer* circleLayer;
@property(strong, nonatomic)CAShapeLayer* squareLayer;
@property(strong, nonatomic)CAShapeLayer* lineLayer;
@property(strong, nonatomic)CAShapeLayer* maskLayer;

@end

@implementation AnimatedULogoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _circleLayer = [self generateCircleLayer];
    return self;
}

#pragma mark - private helper method

-(CAShapeLayer *)generateCircleLayer{
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    layer.lineWidth = self.radius;
    layer.path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:self.radius / 2 startAngle:-(M_PI_2) endAngle:(3 * M_PI_2) clockwise:true].CGPath;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    return layer;
}


                    
@end
