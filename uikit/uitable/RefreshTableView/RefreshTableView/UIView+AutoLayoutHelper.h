//
//  UIView+AutoLayoutHelper.h
//  CKCaknow
//
//  Created by gongzhen on 12/30/16.
//  Copyright © 2016 CAKNOW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayoutHelper)

#pragma mark - Fill

- (nonnull NSArray *)fillSuperView:(UIEdgeInsets)edges;

#pragma mark - top

- (nonnull NSLayoutConstraint *)addTopConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

- (nonnull NSLayoutConstraint *)addTopConstraintToView:(nullable id)toView attribute:(NSLayoutAttribute)toAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

#pragma mark - left

- (nonnull NSLayoutConstraint *)addLeftConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

- (nonnull NSLayoutConstraint *)addLeftConstraintToView:(nullable id)toView attribute:(NSLayoutAttribute)toAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

#pragma mark - right

- (nonnull NSLayoutConstraint *)addRightConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

- (nonnull NSLayoutConstraint *)addRightConstraintToView:(nullable id)toView attribute:(NSLayoutAttribute)toAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

#pragma mark - bottom

- (nonnull NSLayoutConstraint *)addBottomConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

- (nonnull NSLayoutConstraint *)addBottomConstraintToView:(nullable id)toView attribute:(NSLayoutAttribute)toAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

#pragma mark - leading

- (nonnull NSLayoutConstraint *)addLeadingConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

- (nonnull NSLayoutConstraint *)addLeadingConstraintToView:(nullable id)toView attribute:(NSLayoutAttribute)toAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

#pragma mark - trailing

- (nonnull NSLayoutConstraint *)addTrailingConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

- (nonnull NSLayoutConstraint *)addTrailingConstraintToView:(nullable id)toView attribute:(NSLayoutAttribute)toAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

#pragma mark - CenterX

- (nonnull NSLayoutConstraint *)addCenterXConstraintToView:(nullable id)toView;

- (nonnull NSLayoutConstraint *)addCenterXConstraintToView:(nullable id)toView constant:(CGFloat)constant;

- (nonnull NSLayoutConstraint *)addCenterXConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

#pragma mark - CenterY

- (nonnull NSLayoutConstraint *)addCenterYConstraintToView:(nullable id)toView;

- (nonnull NSLayoutConstraint *)addCenterYConstraintToView:(nullable id)toView constant:(CGFloat)constant;

- (nonnull NSLayoutConstraint *)addCenterYConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

#pragma mark - width

- (nonnull NSLayoutConstraint *)addWidthConstraintWithRelation:(NSLayoutRelation)relation constant:(CGFloat)constant;

- (nonnull NSLayoutConstraint *)addWidthConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

#pragma mark - height

- (nonnull NSLayoutConstraint *)addHeightConstraintWithRelation:(NSLayoutRelation)relation constant:(CGFloat)constant;

- (nonnull NSLayoutConstraint *)addHeightConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant;

@end
