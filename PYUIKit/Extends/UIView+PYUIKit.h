//
//  UIView+PYUIKit.h
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

#import <UIKit/UIKit.h>

@interface UIView (PYUIKit)

/* Search for all sub views to find the first responsder */
- (UIView *)findFirstResponsder;

/* From the subview, to get the frame in specified superview */
- (CGPoint)originInSuperview:(UIView *)specifiedSuperview;

/* Capture the screen */
+ (UIImage *)captureScreen;

// Corner Radius
@property (nonatomic, assign)   CGFloat             cornerRadius;

// Border
@property (nonatomic, assign)   CGFloat             borderWidth;
@property (nonatomic, strong)   UIColor             *borderColor;

// Drop Shadow
@property (nonatomic, strong)   UIColor             *dropShadowColor;
@property (nonatomic, assign)   CGFloat             dropShadowRadius;
@property (nonatomic, assign)   CGFloat             dropShadowOpacity;
@property (nonatomic, assign)   CGSize              dropShadowOffset;
@property (nonatomic, assign)   UIBezierPath        *dropShadowPath;

// Add sub layer or sub view.
- (void)addChild:(id)child;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
