//
//  UIView+PYUIKit.m
//  PYUIKit
//
//  Created by Push Chen on 7/30/13.
//  Copyright (c) 2013 Push Lab. All rights reserved.
//

/*
 LGPL V3 Lisence
 This file is part of cleandns.
 
 PYUIKit is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 PYData is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with cleandns.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 LISENCE FOR IPY
 COPYRIGHT (c) 2013, Push Chen.
 ALL RIGHTS RESERVED.
 
 REDISTRIBUTION AND USE IN SOURCE AND BINARY
 FORMS, WITH OR WITHOUT MODIFICATION, ARE
 PERMITTED PROVIDED THAT THE FOLLOWING CONDITIONS
 ARE MET:
 
 YOU USE IT, AND YOU JUST USE IT!.
 WHY NOT USE THIS LIBRARY IN YOUR CODE TO MAKE
 THE DEVELOPMENT HAPPIER!
 ENJOY YOUR LIFE AND BE FAR AWAY FROM BUGS.
 */

#import "UIView+PYUIKit.h"
#import <PYCore/PYCore.h>

@implementation UIView (PYUIKit)

- (UIView *)findFirstResponsder
{
    if ( [self isFirstResponder] ) return self;
	for ( UIView *_subView in self.subviews )
	{
		UIView *_first = [_subView findFirstResponsder];
		if ( _first != nil ) return _first;
	}
	return nil;
}

- (CGPoint)originInSuperview:(UIView *)specifiedSuperview
{
    if ( self.superview == specifiedSuperview ) return self.frame.origin;
	CGPoint origin = self.frame.origin;
	CGPoint superOrigin = [self.superview originInSuperview:specifiedSuperview];
	origin.x += superOrigin.x;
	origin.y += superOrigin.y;
	return origin;
}

+ (UIImage *)captureScreen
{
    CGSize _windowSize = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(_windowSize, NO, [UIScreen mainScreen].scale);
    if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view
         drawViewHierarchyInRect:[UIScreen mainScreen].bounds
         afterScreenUpdates:YES];
    } else {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view.layer
         renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *_screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return _screenImage;
}

// Add sub layer or sub view.
- (void)addChild:(id)child
{
    if ( [child isKindOfClass:[CALayer class]] ) {
        [self.layer addSublayer:child];
    } else if ( [child isKindOfClass:[UIView class]] ) {
        [self addSubview:child];
    }
}

// Properties
@dynamic cornerRadius;
- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}
- (void)setCornerRadius:(CGFloat)radius
{
    //[self setClipsToBounds:(radius > 0.f)];
    [self.layer setCornerRadius:radius];
}

@dynamic borderWidth;
- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}
- (void)setBorderWidth:(CGFloat)width
{
    [self.layer setBorderWidth:width];
}
@dynamic borderColor;
- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
- (void)setBorderColor:(UIColor *)aColor
{
    [self.layer setBorderColor:aColor.CGColor];
}

// Drop Shadow
@dynamic dropShadowColor;
- (void)setDropShadowColor:(UIColor *)shadowColor
{
    self.layer.shadowColor = shadowColor.CGColor;
}
- (UIColor *)dropShadowColor
{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}
@dynamic dropShadowRadius;
- (void)setDropShadowRadius:(CGFloat)radius
{
    self.layer.shadowRadius = radius;
}
- (CGFloat)dropShadowRadius
{
    return self.layer.shadowRadius;
}
@dynamic dropShadowOpacity;
- (void)setDropShadowOpacity:(CGFloat)opacity
{
    self.layer.shadowOpacity = opacity;
}
- (CGFloat)dropShadowOpacity
{
    return self.layer.shadowOpacity;
}
@dynamic dropShadowOffset;
- (void)setDropShadowOffset:(CGSize)offset
{
    self.layer.shadowOffset = offset;
}
- (CGSize)dropShadowOffset
{
    return self.layer.shadowOffset;
}
@dynamic dropShadowPath;
- (UIBezierPath *)dropShadowPath
{
    return [UIBezierPath bezierPathWithCGPath:self.layer.shadowPath];
}
- (void)setDropShadowPath:(UIBezierPath *)shadowPath
{
    [self.layer setShadowPath:shadowPath.CGPath];
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
