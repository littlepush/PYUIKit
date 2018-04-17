//
//  UIColor+PYUIKit.m
//  PYUIKit
//
//  Created by Chen Push on 3/11/13.
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

#import "UIColor+PYUIKit.h"
#include <stdlib.h>
#include <time.h>
#import <PYCore/PYCore.h>

@implementation UIColor (PYUIKit)

+ (void)initialize
{
    // Set the random sand
    srandom((unsigned)time(NULL));
}

+ (UIColor *)randomColor
{
    CGFloat _red = (CGFloat)(random() % 255) / 255.f;
    CGFloat _green = (CGFloat)(random() % 255) / 255.f;
    CGFloat _blue = (CGFloat)(random() % 255) / 255.f;
    
    UIColor *_randomColor = [UIColor colorWithRed:_red green:_green blue:_blue alpha:1.f];
    return _randomColor;
}

+ (UIColor *)colorWithString:(NSString *)clrString
{
    return [UIColor colorWithString:clrString alpha:1.f];
}

+ (UIColor *)colorWithString:(NSString *)clrString alpha:(CGFloat)alpha
{
    if ( [[clrString substringToIndex:3] isEqualToString:@"rgb"] ) {
        PYColorInfo _ci = (PYColorInfo){0, 0, 0, alpha};
        if ( [[clrString substringToIndex:4] isEqualToString:@"rgba"] ) {
            // rgba(r,g,b,a)
            NSString *_clrs = [clrString substringWithRange:NSMakeRange(5, clrString.length - 6)];
            NSArray *_cp = [_clrs componentsSeparatedByString:@","];
            _ci.red = [_cp[0] floatValue] / 255.f;
            _ci.green = [_cp[1] floatValue] / 255.f;
            _ci.blue = [_cp[2] floatValue] / 255.f;
            _ci.alpha = [_cp[3] floatValue];
        } else {
            // rgb(r,g,b)
            NSString *_clrs = [clrString substringWithRange:NSMakeRange(4, clrString.length - 5)];
            NSArray *_cp = [_clrs componentsSeparatedByString:@","];
            _ci.red = [_cp[0] floatValue] / 255.f;
            _ci.green = [_cp[1] floatValue] / 255.f;
            _ci.blue = [_cp[2] floatValue] / 255.f;
        }
        return [UIColor colorWithRed:_ci.red green:_ci.green blue:_ci.blue alpha:_ci.alpha];
    } else {
        NSArray *_components = [clrString componentsSeparatedByString:@"^"];
        NSString *_c = clrString;
        if ( [_components count] == 2 ) {
            _c = [_components objectAtIndex:0];
            NSString *_alphaString = [_components lastObject];
            if ( [_alphaString rangeOfString:@"."].location == 0 ) {
                _alphaString = [@"0" stringByAppendingString:_alphaString];
            }
            alpha = [_alphaString floatValue];
        }
        if ( [_c length] == 7 ) {
            _c = [_c substringFromIndex:1];
        }
        if ( [_c length] != 6 ) {
            return [UIColor clearColor];
        }
        
        int r, g, b;
        sscanf(_c.UTF8String, "%02x%02x%02x", &r, &g, &b);
        return RGBACOLOR(r, g, b, alpha);
    }
}
+ (UIColor *)colorWithColorInfo:(PYColorInfo)clrInfo
{
    return [UIColor colorWithRed:clrInfo.red green:clrInfo.green blue:clrInfo.blue alpha:clrInfo.alpha];
}
@dynamic colorInfo;
- (PYColorInfo)colorInfo
{
    PYColorInfo _colorInfo = {0.f, 0.f, 0.f, 0.f};
    
    // This is a non-RGB color
    if( CGColorGetNumberOfComponents(self.CGColor) == 2 ) {
        CGFloat _white = 0.f;
        [self getWhite:&_white alpha:&_colorInfo.alpha];
        _colorInfo.red = _white;
        _colorInfo.green = _white;
        _colorInfo.blue = _white;
    } else {
        // iOS 5
        if ( [self respondsToSelector:@selector(getRed:green:blue:alpha:)] ) {
            [self getRed:&_colorInfo.red
                   green:&_colorInfo.green
                    blue:&_colorInfo.blue
                   alpha:&_colorInfo.alpha];
        } else {
            // < iOS 5
            const CGFloat *components = CGColorGetComponents(self.CGColor);
            _colorInfo.red = components[0];
            _colorInfo.green = components[1];
            _colorInfo.blue = components[2];
            _colorInfo.alpha = components[3];
        }
    }
    return _colorInfo;
}

- (NSString *)clrDescription
{
    PYColorInfo _ci = self.colorInfo;
    return [NSString stringWithFormat:@"UIColor<%p>, r: %u(%f), g: %u(%f), b: %u(%f), a: %f, #%02x%02x%02x",
            self,
            (unsigned)(_ci.red * 255.f), _ci.red,
            (unsigned)(_ci.green * 255.f), _ci.green,
            (unsigned)(_ci.blue * 255.f), _ci.blue,
            _ci.alpha,
            (unsigned)(_ci.red * 255.f),
            (unsigned)(_ci.green * 255.f),
            (unsigned)(_ci.blue * 255.f)];
}

+ (UIColor *)colorWithGradientPatternFrom:(NSString *)fromString to:(NSString *)toString fillHeight:(CGFloat)height
{
    CGFloat _width = 2.f;
    
    // Create a new bitmap image context and make it to be the current context
    UIGraphicsBeginImageContext(CGSizeMake(_width, height));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    
    // Get from string
    NSString *_c = fromString;
    if ( [fromString length] == 7 ) {
        _c = [fromString substringFromIndex:1];
    }
    if ( [_c length] != 6 ) {
        return [UIColor clearColor];
    }
    
    int fr, fg, fb;
    sscanf(_c.UTF8String, "%02x%02x%02x", &fr, &fg, &fb);
    
    // Get to string
    _c = toString;
    if ( [toString length] == 7 ) {
        _c = [toString substringFromIndex:1];
    }
    if ( [_c length] != 6 ) {
        return [UIColor clearColor];
    }
    int tr, tg, tb;
    sscanf(_c.UTF8String, "%02x%02x%02x", &tr, &tg, &tb);
        
    // Draw gradient
    size_t _locationsCount = 2;
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {
        __COLOR_D(fr), __COLOR_D(fg), __COLOR_D(fb), 1.f,
        __COLOR_D(tr), __COLOR_D(tg), __COLOR_D(tb), 1.f
    };
    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef glossGradient =
        CGGradientCreateWithColorComponents
            (rgbColorspace, components, locations, _locationsCount);
    CGPoint topCenter = CGPointMake(0, 0);
    CGPoint bottomCenter = CGPointMake(0, height);
    CGContextDrawLinearGradient(ctx, glossGradient, topCenter, bottomCenter, 0);
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    // pop context
    UIGraphicsPopContext();
    
    // Get the image
    UIImage *_gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up drawing environment
    UIGraphicsEndImageContext();
    
    // Get the image color
    return [UIColor colorWithPatternImage:_gradientImage];
}

+ (UIColor *)colorWithGradientColors:(NSArray *)colors fillHeight:(CGFloat)height
{
    return [UIColor colorWithGradientColors:colors locations:nil fillHeight:height];
}

+ (UIColor *)colorWithGradientColors:(NSArray *)colors fillWidth:(CGFloat)width
{
    return [UIColor colorWithGradientColors:colors locations:nil fillWidth:width];
}

+ (UIColor *)colorWithGradientColors:(NSArray *)colors
                           locations:(NSArray *)locations
                          fillHeight:(CGFloat)height
{
    CGFloat _width = 1.f;
    if ( [locations count] == 0 ) {
        locations = [NSArray arrayWithObjects:PYDoubleToObject(0.f), PYDoubleToObject(1.f), nil];
    }
    
    // Create a new bitmap image context and make it to be the current context
    UIGraphicsBeginImageContext(CGSizeMake(_width, height));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    
    // Get from string
    CGFloat *_components = (CGFloat *)(malloc(sizeof(CGFloat) * 4 * [colors count]));
    
    for ( int l = 0; l < [colors count]; ++l ){
        UIColor *_color = [colors objectAtIndex:l];
        PYColorInfo _colorInfo = _color.colorInfo;
        *(_components + l * 4 + 0) = _colorInfo.red;
        *(_components + l * 4 + 1) = _colorInfo.green;
        *(_components + l * 4 + 2) = _colorInfo.blue;
        *(_components + l * 4 + 3) = _colorInfo.alpha;
    }
    size_t _locationsCount = (size_t)[locations count];
    CGFloat *_locations = (CGFloat*)malloc(sizeof(CGFloat) * _locationsCount);
    for ( NSUInteger i = 0; i < [locations count]; ++i ) {
        _locations[i] = [[locations objectAtIndex:i] floatValue];
    }
    
    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef glossGradient =
    CGGradientCreateWithColorComponents
    (rgbColorspace, _components, _locations, _locationsCount);
    CGPoint topCenter = CGPointMake(0, 0);
    CGPoint bottomCenter = CGPointMake(0, height);
    CGContextDrawLinearGradient(ctx, glossGradient, topCenter, bottomCenter, 0);
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    free(_components);
    free(_locations);
    
    // pop context
    UIGraphicsPopContext();
    
    // Get the image
    UIImage *_gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up drawing environment
    UIGraphicsEndImageContext();
    
    // Get the image color
    return [UIColor colorWithPatternImage:_gradientImage];
}

+ (UIColor *)colorWithGradientColors:(NSArray *)colors
                           locations:(NSArray *)locations
                           fillWidth:(CGFloat)width
{
    CGFloat _height = 1.f;
    if ( [locations count] == 0 ) {
        locations = [NSArray arrayWithObjects:PYDoubleToObject(0.f), PYDoubleToObject(1.f), nil];
    }

    // Create a new bitmap image context and make it to be the current context
    UIGraphicsBeginImageContext(CGSizeMake(width, _height));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    
    // Get from string
    CGFloat *_components = (CGFloat *)(malloc(sizeof(CGFloat) * 4 * [colors count]));
    
    for ( int l = 0; l < [colors count]; ++l ){
        UIColor *_color = [colors objectAtIndex:l];
        PYColorInfo _colorInfo = _color.colorInfo;
        *(_components + l * 4 + 0) = _colorInfo.red;
        *(_components + l * 4 + 1) = _colorInfo.green;
        *(_components + l * 4 + 2) = _colorInfo.blue;
        *(_components + l * 4 + 3) = _colorInfo.alpha;
    }
    size_t _locationsCount = (size_t)[locations count];
    CGFloat *_locations = (CGFloat*)malloc(sizeof(CGFloat) * _locationsCount);
    for ( NSUInteger i = 0; i < [locations count]; ++i ) {
        _locations[i] = [[locations objectAtIndex:i] floatValue];
    }
    
    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef glossGradient =
    CGGradientCreateWithColorComponents
    (rgbColorspace, _components, _locations, _locationsCount);
    CGPoint topCenter = CGPointMake(0, 0);
    CGPoint bottomCenter = CGPointMake(width, 0);
    CGContextDrawLinearGradient(ctx, glossGradient, topCenter, bottomCenter, 0);
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    free(_components);
    free(_locations);
    
    // pop context
    UIGraphicsPopContext();
    
    // Get the image
    UIImage *_gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up drawing environment
    UIGraphicsEndImageContext();
    
    // Get the image color
    return [UIColor colorWithPatternImage:_gradientImage];
}

+ (UIColor *)colorWithOptionString:(NSString *)colorString
{
    return [UIColor colorWithOptionString:colorString reverseOnVerticalis:NO];
}
+ (UIColor *)colorWithOptionString:(NSString *)colorString reverseOnVerticalis:(BOOL)reversed
{
    NSArray *_gradientInfo = [colorString componentsSeparatedByString:@"$"];
    UIColor *_color = nil;
    if ( [_gradientInfo count] > 1 ) {
        NSString *_gradientFlag = [_gradientInfo safeObjectAtIndex:0];
        float _gradientSize = 0.f;
        char _direction = 0;
        sscanf(_gradientFlag.UTF8String, "%c(%f)", &_direction, &_gradientSize);

        NSString *_colorGroup = [_gradientInfo safeObjectAtIndex:1];
        NSArray *_colors = [_colorGroup componentsSeparatedByString:@":"];
        
        NSMutableArray *_clrs = [NSMutableArray array];
        NSMutableArray *_locs = [NSMutableArray array];
        for ( NSString *_clrString in _colors ) {
            NSArray *_com = [_clrString componentsSeparatedByString:@"/"];
            if ( [_com count] == 2 ) {
                CGFloat _loc = [[_com lastObject] floatValue];
                if ( !isnan(_loc) ) {
                    if ( reversed && _direction == 'v' ) {
                        [_locs insertObject:PYDoubleToObject(1 - _loc) atIndex:0];
                    } else {
                        [_locs addObject:PYDoubleToObject(_loc)];
                    }
                }
            }
            if ( reversed && _direction == 'v' ) {
                [_clrs insertObject:[UIColor colorWithString:[_com objectAtIndex:0]] atIndex:0];
            } else {
                [_clrs addObject:[UIColor colorWithString:[_com objectAtIndex:0]]];
            }
        }
        
        if ( _direction == 'v' ) {
            _color = [UIColor colorWithGradientColors:_clrs locations:_locs fillHeight:_gradientSize];
        } else {
            _color = [UIColor colorWithGradientColors:_clrs locations:_locs fillWidth:_gradientSize];
        }
    } else {
        _color = [UIColor colorWithString:colorString];
    }
    return _color;
}
@end

// @littlepush
// littlepush@gmail.com
// PYLab
