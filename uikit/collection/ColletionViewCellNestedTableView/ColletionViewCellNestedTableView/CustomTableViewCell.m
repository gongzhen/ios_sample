//
//  CustomTableViewCell.m
//  ColletionViewCellNestedTableView
//
//  Created by zhen gong on 7/12/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "Constant.h"
#import "MSCustomElements.h"

@interface CustomTableViewCell () {
    BOOL optionsDisplayed;
}

@property (strong, nonatomic) NSMutableSet *selectedVibes;

@end

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _selectedVibes = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)updateWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image options:(NSArray *)options andIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        self.options = [NSArray arrayWithArray:options];
        if (self.backgroundImageView == nil) {
            self.backgroundImageView = [[UIImageView alloc] init];
            [self.contentView addSubview:_backgroundImageView];
        }
        if (self.titleField == nil) {
            self.titleField = [[UILabel alloc] init];
            self.titleField.backgroundColor = K_COLOR_CLEAR;
            [self.backgroundImageView addSubview:_titleField];
        }
        self.backgroundImageView.frame = frame;
        [self.backgroundImageView setImage:image];
        NSTextAlignment ta = NSTextAlignmentCenter;
        CGFloat offset = frame.size.width < 350 ? 70 : 90;
        if (indexPath.section % 2 == 0) {
            // title on left
            self.titleField.frame = CGRectMake(frame.size.width - offset, 20, offset, 60);
        } else {
            // title on right
            self.titleField.frame = CGRectMake(0, 20, offset, 60);
        }
        
        CGFloat fSize = frame.size.width < 350 ? K_FONT_SIZE_REGULAR : K_FONT_SIZE_SERVICES;
        
        self.titleField.attributedText = [[MSCustomElements sharedManager] attributedYellowStringWithFontSize:fSize fontStyle:1 string:title alignment:ta adjustLineHeight:NO andKerning:K_KERNING_MIN];
    }
}

- (void)doShowOptions {
    if (optionsDisplayed == YES) {
        return;
    }
    @autoreleasepool {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __block NSUInteger acc = 1;
            [self.options enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.backgroundColor = K_COLOR_CLEAR;
                btn.layer.borderColor = [K_COLOR_WHITE CGColor];
                btn.layer.borderWidth = 1.0f;
                btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                [btn setAttributedTitle:[[MSCustomElements sharedManager] attributedStringWithFontSize:K_FONT_SIZE_REGULAR fontStyle:1 string:obj alignment:NSTextAlignmentCenter adjustLineHeight:NO andKerning:K_KERNING_MIN] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(selectVibe:) forControlEvents:UIControlEventTouchUpInside];
                CGRect btnRect;
                CGFloat padding = 10.0f;
                CGFloat yOffset = 128.0f * acc + padding;
                if (idx % 2 == 0) {
                    // left, first
                    if (idx == self.options.count - 1) {
                        btnRect = CGRectMake(self.contentView.bounds.size.width/2 - (102/2), yOffset, 102, 108);
                    } else {
                        btnRect = CGRectMake(self.contentView.bounds.size.width/2 - 122, yOffset, 102, 108);
                    }
                    
                } else {
                    // right, second
                    btnRect = CGRectMake(self.contentView.bounds.size.width/2 + 20, yOffset, 102, 108);
                    acc++;
                }
                
                if ([obj isEqualToString:@"COMING SOON"]) {
                    /** PRE EVENTS V1, add back events from ServicesListViewController.m and remove check for "COMING SOON" */
                    btnRect = CGRectMake(60, yOffset + 20, self.contentView.bounds.size.width - 120, 108 - 40);
                    btn.enabled = NO;
                }
                
                btn.frame = btnRect;
                [self.contentView addSubview:btn];
            }];
            optionsDisplayed = YES;
        });
    }
}

- (void)doRemoveOptions {
    @autoreleasepool {
        [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isMemberOfClass:[UIButton class]]) {
                [UIView animateWithDuration:0.2f animations:^{
                    obj.alpha = 0;
                } completion:^(BOOL finished) {
                    [obj removeFromSuperview];
                }];
            }
        }];
        optionsDisplayed = NO;
    }
}

- (void)selectVibe:(UIButton *)sender {
    NSString* s = sender.titleLabel.text;
    if ([self.selectedVibes containsObject: s]) {
        // white label white text
        sender.layer.borderColor = [K_COLOR_WHITE CGColor];
        [sender setAttributedTitle:[[MSCustomElements sharedManager] attributedStringWithFontSize:K_FONT_SIZE_REGULAR fontStyle:1 string:s alignment:NSTextAlignmentCenter adjustLineHeight:NO andKerning:K_KERNING_MIN] forState:UIControlStateNormal];
        [self.selectedVibes removeObject:s];
        [self.delegate didRemoveOption:s];
    } else {
        // yellow label yellow text

        sender.layer.borderColor = [K_COLOR_YELLOW CGColor];
        [sender setAttributedTitle:[[MSCustomElements sharedManager] attributedYellowStringWithFontSize:K_FONT_SIZE_REGULAR fontStyle:1 string:s alignment:NSTextAlignmentCenter adjustLineHeight:NO andKerning:K_KERNING_MIN] forState:UIControlStateNormal];
        [self.selectedVibes addObject:s];
        [self.delegate didSelectOption:s];
    }

//    @autoreleasepool {
//        [self.delegate didSelectOption: sender.titleLabel.text];
//    }
}
@end
