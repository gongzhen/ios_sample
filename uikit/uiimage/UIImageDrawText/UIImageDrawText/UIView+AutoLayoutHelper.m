//
//  UIView+AutoLayoutHelper.m
//  CKCaknow
//
//  Created by gongzhen on 12/30/16.
//  Copyright © 2016 CAKNOW. All rights reserved.
//

#import "UIView+AutoLayoutHelper.h"

@implementation UIView (AutoLayoutHelper)

#pragma mark - Fill

- (nonnull NSArray *)fillSuperView:(UIEdgeInsets)edges {
    NSArray *constraints = @[];
    UIView *superView = self.superview;
    
    if (superView) {
        NSLayoutConstraint *topConstraint = [self addTopConstraintToView:superView relation:NSLayoutRelationEqual constant:edges.top];
        NSLayoutConstraint *bottomConstraint = [self addTopConstraintToView:superView relation:NSLayoutRelationEqual constant:edges.bottom];
        NSLayoutConstraint *leftConstraint = [self addLeftConstraintToView:superView relation:NSLayoutRelationEqual constant:edges.left];
        NSLayoutConstraint *rightConstraint = [self addRightConstraintToView:superView relation:NSLayoutRelationEqual constant:edges.right];
        constraints = @[topConstraint, leftConstraint, bottomConstraint, rightConstraint];
    }
    return constraints;
}

#pragma mark - Top

- (nonnull NSLayoutConstraint *)addTopConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    return [self addTopConstraintToView:toView attribute:NSLayoutAttributeTop relation:relation constant:constant];
}

- (nonnull NSLayoutConstraint *)addTopConstraintToView:(nullable id)toView attribute:(NSLayoutAttribute)toAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [self createConstraintWithAttribute:NSLayoutAttributeTop
                                                                  toView:toView
                                                             toAttribute:toAttribute
                                                                relation:relation
                                                                constant:constant];
    [self.superview addConstraint:constraint];
    return constraint;
}

#pragma mark - Left

- (nonnull NSLayoutConstraint *)addLeftConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    return [self addLeftConstraintToView:toView attribute:NSLayoutAttributeLeft relation:NSLayoutRelationEqual constant:constant];
}

- (nonnull NSLayoutConstraint *)addLeftConstraintToView:(nullable id)toView attribute:(NSLayoutAttribute)toAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [self createConstraintWithAttribute:NSLayoutAttributeLeft
                                                                  toView:toView
                                                             toAttribute:toAttribute
                                                                relation:relation
                                                                constant:constant];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
}

#pragma mark - right

- (nonnull NSLayoutConstraint *)addRightConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    return [self addRightConstraintToView:toView attribute: NSLayoutAttributeRight relation:relation constant:constant];
}

- (nonnull NSLayoutConstraint *)addRightConstraintToView:(nullable id)toView attribute:(NSLayoutAttribute)toAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [self createConstraintWithAttribute:NSLayoutAttributeRight
                                        toView:toView
                                   toAttribute:toAttribute
                                      relation:relation
                                      constant:constant];
    
    [self.superview addConstraint:constraint];
    return constraint;
}

#pragma mark - bottom

- (nonnull NSLayoutConstraint *)addBottomConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    return [self addBottomConstraintToView:toView attribute:NSLayoutAttributeBottom relation:relation constant:constant];
}

- (nonnull NSLayoutConstraint *)addBottomConstraintToView:(nullable id)toView attribute:(NSLayoutAttribute)toAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [self createConstraintWithAttribute:NSLayoutAttributeBottom
                                                                  toView:toView
                                                             toAttribute:toAttribute
                                                                relation:relation
                                                                constant:constant];
    [self.superview addConstraint:constraint];
    return constraint;
}

#pragma mark - leading

- (nonnull NSLayoutConstraint *)addLeadingConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    return [self addLeadingConstraintToView:toView attribute:NSLayoutAttributeLeading relation:relation constant:constant];
}

- (nonnull NSLayoutConstraint *)addLeadingConstraintToView:(nullable id)toView attribute:(NSLayoutAttribute)toAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [self createConstraintWithAttribute:NSLayoutAttributeLeading
                                                                  toView:toView
                                                             toAttribute:toAttribute
                                                                relation:relation
                                                                constant:constant];
    [self.superview addConstraint:constraint];
    return constraint;
}

#pragma mark - trailing

- (nonnull NSLayoutConstraint *)addTrailingConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    return [self addTrailingConstraintToView:toView attribute:NSLayoutAttributeTrailing relation:relation constant:constant];
}

- (nonnull NSLayoutConstraint *)addTrailingConstraintToView:(nullable id)toView attribute:(NSLayoutAttribute)toAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [self createConstraintWithAttribute:NSLayoutAttributeTrailing
                                                                  toView:toView
                                                             toAttribute:toAttribute
                                                                relation:relation
                                                                constant:constant];
    [self.superview addConstraint:constraint];
    return constraint;
}

#pragma mark - CenterX

- (nonnull NSLayoutConstraint *)addCenterXConstraintToView:(UIView *)toView {
    return [self addCenterXConstraintToView:toView constant:0.f];
}

- (nonnull NSLayoutConstraint *)addCenterXConstraintToView:(UIView *)toView constant:(CGFloat)constant {
    return [self addCenterXConstraintToView:toView relation:NSLayoutRelationEqual constant:constant];
}

- (nonnull NSLayoutConstraint *)addCenterXConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [self createConstraintWithAttribute:NSLayoutAttributeCenterX
                                                                  toView:toView
                                                             toAttribute:NSLayoutAttributeCenterX
                                                                relation:relation
                                                                constant:constant];
    [self.superview addConstraint:constraint];
    return constraint;
}

#pragma mark - CenterY

- (nonnull NSLayoutConstraint *)addCenterYConstraintToView:(nullable id)toView {
    return [self addCenterYConstraintToView:toView constant:0.f];
}

- (nonnull NSLayoutConstraint *)addCenterYConstraintToView:(nullable id)toView constant:(CGFloat)constant {
    return [self addCenterYConstraintToView:toView relation:NSLayoutRelationEqual constant:constant];
}

- (nonnull NSLayoutConstraint *)addCenterYConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [self createConstraintWithAttribute:NSLayoutAttributeCenterY
                                                                  toView:toView
                                                             toAttribute:NSLayoutAttributeCenterY
                                                                relation:relation
                                                                constant:constant];
    [self.superview addConstraint:constraint];
    return constraint;
}

#pragma mark - width

- (nonnull NSLayoutConstraint *)addWidthConstraintWithRelation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    return [self addWidthConstraintToView:nil relation:relation constant:constant];
}

- (nonnull NSLayoutConstraint *)addWidthConstraintToView:(UIView *)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [self createConstraintWithAttribute:NSLayoutAttributeWidth
                                                                  toView:toView
                                                             toAttribute:NSLayoutAttributeWidth
                                                                relation:relation
                                                                constant:constant];
    
    [self.superview addConstraint:constraint];
    return constraint;
}

#pragma mark - height

- (nonnull NSLayoutConstraint *)addHeightConstraintWithRelation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    return [self addHeightConstraintToView:nil relation:relation constant:constant];
}

- (nonnull NSLayoutConstraint *)addHeightConstraintToView:(nullable id)toView relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [self createConstraintWithAttribute:NSLayoutAttributeHeight
                                                                  toView:toView
                                                             toAttribute:NSLayoutAttributeHeight
                                                                relation:relation
                                                                constant:constant];
    [self.superview addConstraint:constraint];
    return constraint;
}

                                      
#pragma mark - private

- (nonnull NSLayoutConstraint *)createConstraintWithAttribute: (NSLayoutAttribute)attribute toView:(nullable id)toView toAttribute:(NSLayoutAttribute)toAttribute relation:(NSLayoutRelation)relation constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:attribute
                                                                  relatedBy:relation
                                                                     toItem:toView
                                                                  attribute:toAttribute
                                                                 multiplier:1.0
                                                                   constant:constant];
    return constraint;
}

@end
