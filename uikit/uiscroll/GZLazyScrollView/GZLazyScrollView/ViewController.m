//
//  ViewController.m
//  GZLazyScrollView
//
//  Created by zhen gong on 9/10/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ViewController.h"
#import "GZLazyScrollView.h"

@interface LazyScrollViewCustomView : UILabel <GZLazyScrollViewCellProtocol>

@end

@implementation LazyScrollViewCustomView

- (void)mui_prepareForReuse
{
    NSLog(@"%@", [NSString stringWithFormat:@"%@ - Prepare For Reuse",self.text]);
}

- (void)mui_didEnterWithTimes:(NSUInteger)times
{
    NSLog(@"%@", [NSString stringWithFormat:@"%@ - Did Enter With Times - %lu",self.text,(unsigned long)times]);
}

- (void)mui_afterGetView
{
    NSLog(@"%@", [NSString stringWithFormat:@"%@ - AfterGetView",self.text]);
}

@end

@interface ViewController () <GZLazyScrollViewDataSource>
{
    NSMutableArray * rectArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GZLazyScrollView *scrollview = [[GZLazyScrollView alloc] init];
    scrollview.frame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height);
    
    scrollview.dataSource = self;
    [self.view addSubview:scrollview];
    
    //Here is frame array for test.
    //LazyScrollView must know every rect before rending.
    rectArray  = [[NSMutableArray alloc] init];
    
    //Create a single column layout with 5 elements;
    for (int i = 0; i < 5 ; i++) {
        [rectArray addObject:[NSValue valueWithCGRect:CGRectMake(10, i *80 + 2 , self.view.bounds.size.width-20, 80-2)]];
    }
    //Create a double column layout with 10 elements;
    for (int i = 0; i < 10 ; i++) {
        [rectArray addObject:[NSValue valueWithCGRect:CGRectMake((i%2)*self.view.bounds.size.width/2 + 3, 410 + i/2 *80 + 2 , self.view.bounds.size.width/2 -3, 80 - 2)]];
    }
    //Create a trible column layout with 15 elements;
    for (int i = 0; i < 15 ; i++) {
        [rectArray addObject:[NSValue valueWithCGRect:CGRectMake((i%3)*self.view.bounds.size.width/3 + 1, 820 + i/3 *80 + 2 , self.view.bounds.size.width/3 -3, 80 - 2)]];
    }
    scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 1230);
    //STEP 3 reload LazyScrollView
    [scrollview reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GZLazyScrollViewDataSource

- (NSUInteger)numberOfItemInScrollView:(nonnull GZLazyScrollView *)scrollView
{
    return rectArray.count;
}

// Return the view model by spcial index.
- (nonnull GZRectModel *)scrollView:(nonnull GZLazyScrollView *)scrollView rectModelAtIndex:(NSUInteger)index
{
    CGRect rect = [(NSValue *)[rectArray objectAtIndex:index]CGRectValue];
    GZRectModel *rectModel = [[GZRectModel alloc]init];
    rectModel.absoluteRect = rect;
    rectModel.muiID = [NSString stringWithFormat:@"%ld",index];
    return rectModel;
}

- (nullable UIView *)scrollView:(nonnull GZLazyScrollView *)scrollView itemByMuiID:(nonnull NSString *)muiID
{
    //Find view that is reuseable first.
    LazyScrollViewCustomView *label = (LazyScrollViewCustomView *)[scrollView dequeueReusableItemWithIdentifier:@"testView"];
    NSInteger index = [muiID integerValue];
    if (!label)
    {
        label = [[LazyScrollViewCustomView alloc]initWithFrame:[(NSValue *)[rectArray objectAtIndex:index]CGRectValue]];
        label.textAlignment = NSTextAlignmentCenter;
        label.reuseIdentifier = @"testView";
    }
    label.frame = [(NSValue *)[rectArray objectAtIndex:index]CGRectValue];
    label.text = [NSString stringWithFormat:@"%lu",(unsigned long)index];
    label.backgroundColor = [self randomColor];
    [scrollView addSubview:label];
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)]];
    return label;
}

#pragma mark - Private

- (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
}

- (void)click:(UIGestureRecognizer *)recognizer
{
    LazyScrollViewCustomView *label = (LazyScrollViewCustomView *)recognizer.view;
    
    NSLog(@"Click - %@",label.muiID);
}

@end
