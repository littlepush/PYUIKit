//
//  UIImage+UIKit.h
//  PYUIKit
//
//  Created by Push Chen on 7/29/13.
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

@interface UIImage (UIKit)

// Remain the canvas size and fill the cut part with transplant data.
- (UIImage *)cropToSizeRemainCanvasSize:(CGSize)size __deprecated;

// Crop the image to a fit size
- (UIImage *)cropToSize:(CGSize)size;

// Crop the image in rect.
- (UIImage *)cropInRect:(CGRect)cropRect;

// Scale canvas to specifed rect
- (UIImage *)scalCanvasFitRect:(CGRect)fitRect __deprecated_msg("Spell error, now use [scaleCanvasFitRect:]");
- (UIImage *)scaleCanvasFitRect:(CGRect)fitRect;

// Crop the middle of current image and scaled to fit the specified size.
- (UIImage *)middleImageScaledToFitSize:(CGSize)fitSize;

// Resize the image to fit size.
- (UIImage *)scaledToSize:(CGSize)size;

// Consider the data is a gif image, try to parse the data and fetch
// each frame in the file.
+ (UIImage *)PYImageWithData:(NSData *)theData;

// The string is in the following format:
// Single color: #COLOR
// Gradient two colors: #COLOR1:#COLOR2
// More gradient colors: #COLOR1(L1):#COLOR2(L2):...
// Gradient direction:  v(40)$#COLOR1/L1:#COLOR2/L1... // from top to bottom
//                      h(80)$#COLOR1:#COLOR2... // from left to right
// Must specified the flag to use gradient color.
// the number after flag is the size of the gradient range.
// The location is optional
// This method will create a gradient image with specified color.
+ (UIImage *)imageWithOptionString:(NSString *)optionString;

// Draw a check icon(√) within specified size,
// default background color is clear, icon color is black, line width is 1.f
+ (UIImage *)checkIconWithSize:(CGSize)imgSize;
+ (UIImage *)checkIconWithSize:(CGSize)imgSize
               backgroundColor:(UIColor *)bkgClr
                     iconColor:(UIColor *)icnClr
                     lineWidth:(CGFloat)lineWidth
                       padding:(CGFloat)padding;

// Draw a menu icon(三) within specified size
+ (UIImage *)menuIconWithSize:(CGSize)imgSize;
+ (UIImage *)menuIconWithSize:(CGSize)imgSize
              backgroundColor:(UIColor *)bkgClr
                    iconColor:(UIColor *)icnClr
                    lineWidth:(CGFloat)lineWidth
                      padding:(CGFloat)padding;

// Draw a cross(X) within specified size
+ (UIImage *)crossIconWithSize:(CGSize)imgSize;
+ (UIImage *)crossIconWithSize:(CGSize)imgSize
               backgroundColor:(UIColor *)bkgClr
                     iconColor:(UIColor *)icnClr
                     lineWidth:(CGFloat)lineWidth
                       padding:(CGFloat)padding;

// Draw an add(+) within specified size
+ (UIImage *)addIconWithSize:(CGSize)imgSize;
+ (UIImage *)addIconWithSize:(CGSize)imgSize
             backgroundColor:(UIColor *)bkgClr
                   iconColor:(UIColor *)icnClr
                   lineWidth:(CGFloat)lineWidth
                     padding:(CGFloat)padding;

- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
