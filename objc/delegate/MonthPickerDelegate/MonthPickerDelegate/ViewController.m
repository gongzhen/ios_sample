//
//  ViewController.m
//  MonthPickerDelegate
//
//  Created by zhen gong on 9/2/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//  https://github.com/simonrice/SRMonthPicker
//

#import "ViewController.h"
#import "GZMonthPicker.h"

@interface ViewController() <GZMonthPickerDelegate> {
    CGFloat _yOffPadding;
}

@property (strong, nonatomic) GZMonthPicker *monthPicker;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIButton *setToOct2009Btn;
@property (strong, nonatomic) UIButton *setToThisMonthBtn;


@end

@implementation ViewController

- (GZMonthPicker *)monthPicker {
    if (_monthPicker == nil) {
        CGRect pickerFrame = CGRectMake(20, _yOffPadding + 50, self.view.bounds.size.width - 20, 200);
        _monthPicker = [[GZMonthPicker alloc] initWithFrame:pickerFrame];
    }
    return _monthPicker;
}

- (UILabel *)label {
    if(_label == nil) {
        CGRect labelFrame = CGRectMake(20, _yOffPadding, self.view.bounds.size.width - 40, 40);
        _label = [[UILabel alloc] initWithFrame:labelFrame];
        _label.numberOfLines = 1;
        _label.font = [UIFont systemFontOfSize:18];
        _label.baselineAdjustment = YES;
        _label.textColor = [UIColor redColor];
    }
    return _label;
}

- (UIButton *)setToOct2009Btn {
    if(_setToOct2009Btn == nil) {
        CGRect btnRect = CGRectMake(20, _yOffPadding + 300, 300, 40);
        _setToOct2009Btn = [[UIButton alloc] initWithFrame:btnRect];
        [_setToOct2009Btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_setToOct2009Btn addTarget:self action:@selector(setToOct2009:) forControlEvents:UIControlEventTouchUpInside];
        [_setToOct2009Btn setTitle:@"Set to 2009 Oct" forState:UIControlStateNormal];
    }
    return _setToOct2009Btn;
}

- (UIButton *)setToThisMonthBtn {
    if(_setToThisMonthBtn == nil) {
        CGRect btnRect = CGRectMake(20, _yOffPadding + 450, 300, 40);
        _setToThisMonthBtn = [[UIButton alloc] initWithFrame:btnRect];
        [_setToThisMonthBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_setToThisMonthBtn setTitle:@"Set to this month" forState:UIControlStateNormal];
        [_setToThisMonthBtn addTarget:self action:@selector(setToThisMonth:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setToThisMonthBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _yOffPadding = 60;
    // Do any additional setup after loading the view, typically from a nib.
    self.monthPicker.monthPickerDelegate = self;
    self.label.text = [NSString stringWithFormat:@"Selected:%@", [self formatDate:self.monthPicker.date]];
    
    self.monthPicker.maximumYear = 2020;
    self.monthPicker.minimumYear = 1980;
    self.monthPicker.yearFirst = YES;
    [self.monthPicker setEnableColourRow:YES];
    self.monthPicker.fontColor = [UIColor redColor];
    
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.monthPicker];
    [self.view addSubview:self.setToOct2009Btn];
    [self.view addSubview:self.setToThisMonthBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GZMonthPickerDelegate method

- (void)monthPickerWillChangeDate:(GZMonthPicker *)monthPicker
{
    // Show the date is changing (with a 1 second wait mimicked)
    self.label.text = [NSString stringWithFormat:@"Was: %@", [self formatDate:monthPicker.date]];
}

- (void)monthPickerDidChangeDate:(GZMonthPicker *)monthPicker
{
    // All this GCD stuff is here so that the label change on -[self monthPickerWillChangeDate] will be visible
    dispatch_queue_t delayQueue = dispatch_queue_create("com.simonrice.SRMonthPickerExample.DelayQueue", 0);
    
    dispatch_async(delayQueue, ^{
        // Wait 1 second
        sleep(1);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.label.text = [NSString stringWithFormat:@"Selected: %@", [self formatDate:self.monthPicker.date]];
        });
    });
}


#pragma mark - private method

- (NSString*)formatDate:(NSDate *)date
{
    // A convenience method that formats the date in Month-Year format
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM y";
    return [formatter stringFromDate:date];
}

- (void)setToThisMonth:(UIButton *)sender {
    self.monthPicker.date = [NSDate date];
    self.label.text = [NSString stringWithFormat:@"Selected: %@", [self formatDate:self.monthPicker.date]];
}

- (void)setToOct2009:(UIButton *)sender {
    NSDateComponents* dateParts = [[NSDateComponents alloc] init];
    
    dateParts.month = 10;
    dateParts.year = 2009;
    
    self.monthPicker.date = [[NSCalendar currentCalendar] dateFromComponents:dateParts];
    self.label.text = [NSString stringWithFormat:@"Selected: %@", [self formatDate:self.monthPicker.date]];
}


@end
