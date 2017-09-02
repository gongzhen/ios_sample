//
//  ViewController.m
//  Delegate
//
//  Created by zhen gong on 5/22/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ViewController.h"
#import "ChooseYesOrNoView.h"
#import "WeatherService.h"

@interface ViewController () <WeatherServiceDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
    ChooseYesOrNoView *chooseYesOrNoView = [[ChooseYesOrNoView alloc]
                                            initWithFrame:CGRectMake(30,160,260,110)];
    chooseYesOrNoView.delegate = self;
    chooseYesOrNoView.backgroundColor = [UIColor whiteColor];
    chooseYesOrNoView = [chooseYesOrNoView display];
    [self.view addSubview:chooseYesOrNoView];
    
    WeatherService *tempWeatherService = [[WeatherService alloc] init];
    
    // register ourselves as a delegate for the weather service
    tempWeatherService.delegate = self;
    
    // call the service - which is in turn calling us...
    [tempWeatherService fetchWeather];
}


- (void) chooseYesOrNoResponse:(BOOL)response
{
    if(response) {
        NSLog(@"YES was chosen");
        self.view.backgroundColor = [UIColor greenColor];
    }
    else {
        NSLog(@"NO was chosen");
        self.view.backgroundColor = [UIColor redColor];
    }
}

-(void)didFetchWeather:(Weather *)weather {
    self.currentTempLabel.text = [NSString stringWithFormat:@"%ld", (long)weather.currentTemperature];
}

@end
