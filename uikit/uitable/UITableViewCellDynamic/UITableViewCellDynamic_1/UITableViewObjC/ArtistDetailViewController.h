//
//  ArtistDetailViewController.h
//  UITableViewCellDynamic_1
//
//  Created by gongzhen on 12/6/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artist.h"

@interface ArtistDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)Artist *selectedArtist;

@end
