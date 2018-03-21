//
//  ViewController.m
//  Meow Fest
//
//  Created by ULS on 3/19/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"
#import "CustomSpinnerTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSInteger _currentPage;
    NSString *_urlString;
}

@property(nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 0;
    [self urlStringWithPage:_currentPage];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_urlString]];
    NSMutableArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    DLog(@"%@", _urlString);
    DLog(@"%@", jsonObjects);
    _dataSource = [NSMutableArray arrayWithArray:jsonObjects];
    [self.tableVIew registerClass:[CustomTableViewCell class] forCellReuseIdentifier:@"kCustomTableViewCellIdentifier"];
    [self.tableVIew registerClass:[CustomSpinnerTableViewCell class] forCellReuseIdentifier:@"kCustomSpinnerTableViewCellIdentifier"];
    self.tableVIew.delegate = self;
    self.tableVIew.dataSource = self;
    [self.tableVIew reloadData];
}

- (void)urlStringWithPage:(NSInteger)currentPage {
    _urlString = [NSString stringWithFormat:@"https://chex-triplebyte.herokuapp.com/api/cats?page=%ld", currentPage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count + 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == _dataSource.count) {
        return [self spinnerCell:tableView cellForRowAtIndexPath:indexPath];
    }
    return [self imageTableCell:tableView cellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)imageTableCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCustomTableViewCellIdentifier" forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kCustomTableViewCellIdentifier"];
    }
    cell.tag = indexPath.row;
    NSDictionary *catObj = [_dataSource objectAtIndex:indexPath.row];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[catObj objectForKey:@"image_url"]]];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if(image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(cell.tag == indexPath.row) {
                    cell.imageView.image = image;
                    [cell configure:catObj];
                }
                [cell setNeedsLayout];
            });
        }
        
    });
    return cell;
}

- (UITableViewCell *)spinnerCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomSpinnerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCustomSpinnerTableViewCellIdentifier" forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[CustomSpinnerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kCustomTableViewCellIdentifier"];
    }
    [cell startAnimating];
//     [cell stopAnimating];
    [self loadMorePage];
    return cell;
}

- (void)loadMorePage {
    NSString *currentPageString = [_urlString substringFromIndex:_urlString.length - 1];
    _currentPage = [currentPageString integerValue] + 1;
    [self urlStringWithPage:_currentPage];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_urlString]];
    NSMutableArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    DLog(@"%@", _urlString);
    DLog(@"%@", jsonObjects);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == _dataSource.count) {
        return 44;
    }
    return 320;
}



@end
