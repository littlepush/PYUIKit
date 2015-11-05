//
//  UIScrollView+PYUIKit.m
//  PYUIKit
//
//  Created by Push Chen on 12/26/14.
//  Copyright (c) 2014 Push Lab. All rights reserved.
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

#import "UIScrollView+PYUIKit.h"
#import "UIView+PYUIKit.h"
#import "PYUIKitMacro.h"
#import <PYCore/PYCore.h>

@implementation UIScrollView (PYUIKit)

@dynamic keyboardTriggerMode;
- (UIScrollViewKeyboardTriggerMode)keyboardTriggerMode
{
    NSNumber *__kbTriggerMode = [self.layer valueForKey:@"__k__keyboard_trigger_mode"];
    if ( __kbTriggerMode == nil ) return UIScrollViewKeyboardTriggerContentScale;
    return (UIScrollViewKeyboardTriggerMode)[__kbTriggerMode integerValue];
}

- (void)setKeyboardTriggerMode:(UIScrollViewKeyboardTriggerMode)mode
{
    [self.layer setValue:@(mode) forKey:@"__k__keyboard_trigger_mode"];
}

- (void)setTriggerKeyboardEvent:(BOOL)enable
{
    NSNumber *__keyboardTrigger = [self.layer valueForKey:@"__k__keyboard_trigger"];
    BOOL _enable = NO;
    if ( __keyboardTrigger != nil && [__keyboardTrigger boolValue] ) {
        _enable = YES;
    }
    if ( _enable == enable ) return;
    [self.layer setValue:@(enable) forKey:@"__k__keyboard_trigger"];
    
    if ( enable ) {
        [NF_CENTER addObserver:self
                      selector:@selector(_actionKeyboardChangedHandler:)
                          name:UIKeyboardWillChangeFrameNotification
                        object:nil];
    } else {
        [NF_CENTER removeObserver:self
                             name:UIKeyboardWillChangeFrameNotification
                           object:nil];
    }
}

- (void)_actionKeyboardChangedHandler:(NSNotification *)notify
{
    NSValue *_keyboardToFrame = [notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect _kbEndFrame;
    [_keyboardToFrame getValue:&_kbEndFrame];
    
    NSValue *_lastKeyboardToFrame = [self.layer valueForKey:@"__k__keyboard_lastframe"];
    CGRect _kbLastFrame;
    if ( _lastKeyboardToFrame == NULL ) {
        _kbLastFrame = CGRectZero;
    } else {
        [_lastKeyboardToFrame getValue:&_kbLastFrame];
    }
    
    CGRect _scf = self.frame;
    CGRect _applicationFrame = [UIScreen mainScreen].bounds;
    
    CGFloat _deltaY = _kbLastFrame.origin.y - _kbEndFrame.origin.y;
    CGFloat _deltaHeight = _kbLastFrame.size.height - _kbEndFrame.size.height;
    
    UIScrollViewKeyboardTriggerMode _kbTriggerMode = self.keyboardTriggerMode;
    if ( _kbEndFrame.origin.y >= _applicationFrame.size.height ) {
        if ( CGRectEqualToRect(CGRectZero, _kbLastFrame) ) {
            return;
        }
        // Disappear
        if ( _kbTriggerMode == UIScrollViewKeyboardTriggerContentScale ) {
            [self setFrame:CGRectMake(_scf.origin.x, _scf.origin.y,
                                      _scf.size.width,
                                      _scf.size.height - _deltaY)];
        } else {
            [self setFrame:CGRectMake(_scf.origin.x, _scf.origin.y - _deltaY,
                                      _scf.size.width,
                                      _scf.size.height)];
        }
        
        //[self scrollRectToVisible:self.bounds animated:YES];
        NSValue *_resetKbFrame = [NSValue valueWithCGRect:CGRectZero];
        [self.layer setValue:_resetKbFrame forKey:@"__k__keyboard_lastframe"];
        return;
    } else if ( _kbEndFrame.origin.y == (_scf.origin.y + _scf.size.height) ) {
        // do nothing
    } else {
        // Show
        if ( _kbTriggerMode == UIScrollViewKeyboardTriggerContentScale ) {
            [self setFrame:
             CGRectMake(_scf.origin.x, _scf.origin.y,
                        _scf.size.width,
                        _scf.size.height + _deltaHeight)];
        } else {
            [self setFrame:
             CGRectMake(_scf.origin.x, _scf.origin.y + _deltaHeight,
                        _scf.size.width,
                        _scf.size.height)];
        }
    }
    CGSize _displaySize = self.frame.size;
    UIView *_ = [self findFirstResponsder];
    if ( _ != nil && _kbTriggerMode == UIScrollViewKeyboardTriggerContentScale ) {
        CGRect __f = _.frame;
        __f.origin = [_ originInSuperview:self];
        // Check left space height
        // Make the first responder in the middle
        CGFloat _halfEmptySpace = (_displaySize.height - __f.size.height) / 2;
        if ( __f.origin.y >= _halfEmptySpace &&
            (self.contentSize.height - (__f.origin.y + __f.size.height)) >= _halfEmptySpace ) {
            [self scrollRectToVisible:CGRectMake(0, (__f.origin.y - _halfEmptySpace),
                                                 _scf.size.width,
                                                 _displaySize.height)
                             animated:YES];
        } else if ( __f.origin.y < _halfEmptySpace ) {
            [self scrollRectToVisible:CGRectMake(0, 0, _scf.size.width, _displaySize.height)
                             animated:YES];
        } else {
            [self scrollRectToVisible:CGRectMake(0, self.contentSize.height - _displaySize.height,
                                                 _scf.size.width,
                                                 _displaySize.height)
                             animated:YES];
        }
    } else if ( [self isKindOfClass:[UITableView class]] && _ == nil ) {
        // Scroll to bottom
        [self scrollRectToVisible:CGRectMake(0, self.contentSize.height - _displaySize.height,
                                             _displaySize.width, _displaySize.height)
                         animated:YES];
    }
    // Store
    [self.layer setValue:_keyboardToFrame forKey:@"__k__keyboard_lastframe"];
}

@end
