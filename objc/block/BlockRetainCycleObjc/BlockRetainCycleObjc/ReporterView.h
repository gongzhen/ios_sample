//
//  ReporterView.h
//  BlockRetainCycleObjc
//
//  Created by zhen gong on 6/12/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReporterView : UIView

// block method which accepting a block type parameter
-(void)block:(void(^)(void))completionBlock;
-(void)foo;

// strong type block perperty
 @property(strong)void (^doBlock)(void);
//@property(weak)void (^doBlock)(void);

@end
