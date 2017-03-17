//
//  GarageCell.m
//  CaknowGZ
//
//  Created by gongzhen on 3/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "GarageCell.h"
#import "CKUIKit.h"
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"

@implementation GarageCell

- (UIImageView *)brandImageView {
    if (_brandImageView == nil) {
        _brandImageView = [CKUIKit generateImageViewWithBackgroundColor:[UIColor clearColor]];
        _brandImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _brandImageView;
}
- (UILabel *)modelLabel {
    if (_modelLabel == nil) {
        _modelLabel = [CKUIKit labelWithBackgroundColor:[UIColor whiteColor]
                                                   textColor:[UIColor grayColor]
                                               textAlighment:NSTextAlignmentLeft
                                               numberOfLines:0
                                                        text:nil
                                                    fontSize:14];
        _modelLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _modelLabel.textAlignment = NSTextAlignmentCenter;
        [_modelLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _modelLabel;
}

- (UILabel *)quoteCountLabel {
    if (_quoteCountLabel == nil) {
        _quoteCountLabel = [CKUIKit labelWithBackgroundColor:[UIColor whiteColor]
                                               textColor:[UIColor whiteColor]
                                           textAlighment:NSTextAlignmentCenter
                                           numberOfLines:0
                                                    text:nil
                                                fontSize:10];
        _quoteCountLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_quoteCountLabel setBackgroundColor:[UIColor redColor]];
    }
    return _quoteCountLabel;
}

- (UIView *)brandBackgroundView {
    if (_brandBackgroundView == nil) {
        _brandBackgroundView = [CKUIKit viewWithBackgroundColor:[UIColor colorWithHex:0xF1F1F1]];
    }
    return _brandBackgroundView;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayoutConstraint];
    }
    return self;
}

// Not sure if it is useful.
//- (void)prepareForReuse {
//    [super prepareForReuse];
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    _brandBackgroundView.layer.cornerRadius = _brandBackgroundView.frame.size.height / 2.0f;
    _brandBackgroundView.layer.masksToBounds = YES;
    
    _brandImageView.layer.cornerRadius = _brandImageView.frame.size.height / 2.0f;
    _brandImageView.layer.masksToBounds = YES;
}

- (void)setupLayoutConstraint {
    [self.contentView addSubview:self.brandBackgroundView];
    [self.contentView addSubview:self.modelLabel];
    [self.contentView addSubview:self.quoteCountLabel];
    [self.brandBackgroundView addSubview:self.brandImageView];
    
    __weak typeof(self) weakSelf = self;
    [self.brandBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).with.offset(10.f);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(10.f);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-10.f);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).with.offset(-10.f);
    }];
    
    [self.brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([self imageHeightConstraintConstant]);
        make.height.mas_equalTo([self imageHeightConstraintConstant]);
        make.center.equalTo(weakSelf.brandBackgroundView);
    }];

    [self.quoteCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12.f);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(10.f);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-10.f);
        make.top.equalTo(weakSelf.brandImageView.mas_bottom).with.offset(10.f);
    }];
    
    [self.modelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20.f);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(10.f);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-10.f);
        make.top.equalTo(weakSelf.quoteCountLabel.mas_bottom).with.offset(0.f);
    }];
}

- (void)setVehicleEntity:(GetConsumerVehiclesVehiclesEntity *)vehicleEntity {
    _vehicleEntity = vehicleEntity;
    [_brandImageView processImageDataWithURLString:_vehicleEntity.logo completionBlock:^(NSData *imageData, BOOL successed) {
        UIImage *image = [UIImage imageWithData:imageData];
        if (successed == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _brandImageView.image = image;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _brandImageView.image = nil;
            });
        }
    }];
    if (_vehicleEntity.quoteCount > 0) {
        _quoteCountLabel.hidden = NO;
        _quoteCountLabel.text = [NSString stringWithFormat:@"%ld %@", (long)_vehicleEntity.quoteCount, _vehicleEntity.quoteCount > 1 ? @"Quotes" : @"Quote"];
    } else {
        _quoteCountLabel.hidden = YES;
    }
    
    _modelLabel.text = _vehicleEntity.model;
}

- (CGFloat)imageHeightConstraintConstant {
    CGFloat height = 0.f;
    switch ([self screenHeight]) {
        case 480:
            height = 60.f;
        case 568:
            height = 70.f;
            break;
        case 667:
            height = 80.f;
            break;
        case 736:
            height = 85.f;
            break;
        default:
            height = 0.f;
            break;
    }
    return height;
}

-(NSUInteger)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

@end
     ;
