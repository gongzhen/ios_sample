//
//  FirstViewController.m
//  MasonryTutorial
//
//  Created by Zhen Gong on 6/2/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "FirstViewController.h"
#import "Masonry.h"

@interface FirstViewController ()

@property(assign)CGFloat screenSize;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if(window.frame.size.height < (480 + 1)){/*4s*/
        self.screenSize = .7;
    }else if(window.frame.size.height < 568 +1){/*5s*/
        self.screenSize = .8;
    }else{
        self.screenSize = 1.0;
    }
    
    UIView *redView = [[UIView alloc]init];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    UIView *blueView = [[UIView alloc]init];
    blueView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blueView];
    
    UIView *yellow = [[UIView alloc]init];
    yellow.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:yellow];
    
    UIView *green = [[UIView alloc]init];
    green.backgroundColor = [UIColor greenColor];
    [self.view addSubview:green];
    
    UIView *grayView1 = [[UIView alloc]init];
    grayView1.backgroundColor = [UIColor grayColor];
    [redView addSubview:grayView1];

    UIView *blueView1 = [[UIView alloc]init];
    blueView1.backgroundColor = [UIColor blueColor];
    [redView addSubview:blueView1];

    UIView *grayView2 = [[UIView alloc]init];
    grayView2.backgroundColor = [UIColor grayColor];
    [redView addSubview:grayView2];
    
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);//使左边等于self.view的左边，间距为0
        make.top.equalTo(self.view.mas_top).offset(0);//使顶部与self.view的间距为0
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5);//设置宽度为self.view的一半，multipliedBy是倍数的意思，也就是，使宽度等于self.view宽度的0.5倍
        make.height.equalTo(self.view.mas_height).multipliedBy(0.5);//设置高度为self.view高度的一半
    }];
    [yellow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(redView);//与redView左对齐
        make.top.equalTo(redView.mas_bottom);//与redView底部间距为0
        make.width.and.height.equalTo(redView);//与redView宽高相等
    }];
    [green mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yellow.mas_right);//与yellow右边间距为0
        make.top.equalTo(self.view.mas_top);//与blueView底部间距为0
        make.width.and.height.equalTo(redView);//与redView等宽高
    }];
    
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(redView);//使宽高等于redView
        make.top.equalTo(green.bottom);//与redView顶部对齐
        make.left.equalTo(yellow.right).offset(0);//与redView的间距为0
    }];
    
    [grayView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.leading.equalTo(redView.mas_leading).offset(0);
        make.bottom.equalTo(blueView1.bottom);
    }];

    [blueView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(redView.width).multipliedBy(0.25);
        make.height.mas_equalTo(50);
        make.left.equalTo(grayView1.mas_right);
        make.bottom.equalTo(redView.mas_bottom).offset(-50);
    }];

    [grayView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(grayView1);
        make.left.equalTo(blueView1.mas_right);
        make.right.equalTo(redView.right).offset(0);
        make.bottom.equalTo(blueView1.mas_bottom);
    }];
    
    UIView *gray1 = [[UIView alloc]init];
    gray1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:gray1];
    
    UIView *red1 = [[UIView alloc]init];
    red1.backgroundColor = [UIColor redColor];
    [self.view addSubview:red1];
    
    UIView *gray2 = [[UIView alloc]init];
    gray2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:gray2];
    
    UIView *red2 = [[UIView alloc]init];
    red2.backgroundColor = [UIColor redColor];
    [self.view addSubview:red2];
    
    UIView *gray3 = [[UIView alloc]init];
    gray3.backgroundColor = [UIColor grayColor];
    [self.view addSubview:gray3];
    
    [gray1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.leading.equalTo(self.view.mas_leading).offset(0);
        make.bottom.equalTo(red1.mas_bottom);
    }];
    
    //红1，宽高、左间距、底间距是确定的，添加约束
    [red1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
        make.left.equalTo(gray1.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
    }];
    //灰2，左间距、高度、垂直位置是确定的，宽度要与灰1一致，是为了能均匀填充，添加约束
    [gray2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(gray1);
        make.left.equalTo(red1.mas_right);
        make.bottom.equalTo(red1.mas_bottom);
    }];
    //红2，宽高、左间距、底间距是确定的，添加约束
    [red2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(red1);
        make.left.equalTo(gray2.mas_right);
        make.bottom.equalTo(red1.mas_bottom);
    }];
    //灰3，左间距、右间距、高度、垂直位置是确定的，添加约束
    [gray3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(gray1);
        make.left.equalTo(red2.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(red1.mas_bottom);
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
