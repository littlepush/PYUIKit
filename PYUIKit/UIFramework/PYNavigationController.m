//
//  PYNavigationController.m
//  PYUIKit
//
//  Created by Push Chen on 11/25/13.
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

#import "PYNavigationController.h"
#import "PYApperance.h"
#import "UIView+PYUIKit.h"
#import "UIViewController+PopUp.h"


@interface PYNavigationController ()

- (void)_resetMaskView;

@end

@interface PYApperance (__navigation_controller)

- (void)_keyViewController:(PYNavigationController *)nav changedTransform:(CGAffineTransform)transform;

@end

@implementation PYApperance (__navigation_controller)

- (void)_keyViewController:(PYNavigationController *)nav changedTransform:(CGAffineTransform)transform
{
    for ( PYNavigationController *_nav in _mainViewControllers ) {
        if ( _nav == nav ) continue;
        _nav.view.transform = transform;
        [_nav _resetMaskView];
    }
}

@end

@implementation PYNavigationController

- (void)_resetMaskView
{
    [_maskView setAlpha:0.f];
}
@synthesize viewControllerType = _viewControllerType;
- (void)setViewControllerType:(UINavigationControllerType)type
{
    _viewControllerType = type;
    if ( type == UINavigationControllerTypeMainView ) {
        // Add Pan gesture...
        if ( _panGesture == nil ) {
            _panGesture = [[UIPanGestureRecognizer alloc]
                           initWithTarget:self
                           action:@selector(_gesturePanHandler:)];
            _panGesture.delegate = self;
        }
        [self.view addGestureRecognizer:_panGesture];
    } else {
        if ( _panGesture != nil ) {
            [self.view removeGestureRecognizer:_panGesture];
        }
    }
}
@synthesize mainNavController;
@synthesize maxToLeftMovingSpace = _maxToLeftMovingSpace;
@synthesize maxToRightMovingSpace = _maxToRightMovingSpace;
@dynamic isMainViewController;
- (BOOL)isMainViewController
{
    return _viewControllerType == UINavigationControllerTypeMainView;
}

@dynamic stuckWhenMainViewMoveToLeft;
- (BOOL)stuckWhenMainViewMoveToLeft
{
    return _maxToLeftMovingSpace == 0;
}
@dynamic stuckWhenMainViewMoveToRight;
- (BOOL)stuckWhenMainViewMoveToRight
{
    return _maxToRightMovingSpace == 0;
}

// Gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ( gestureRecognizer != _panGesture ) return NO;
    if ( [self.childViewControllers count] > 1 ) return NO;
    if ( [[PYApperance sharedApperance].leftMenus count] == 0 &&
        [[PYApperance sharedApperance].rightMenus count] == 0 ) return NO;
    return YES;
}

// Pop statue.
@synthesize isPoppedUp = _isPoppedUp;

- (void)mainViewIsMovingToLeftWithPercentage:(CGFloat)percentage
{
    if ( _maxToLeftMovingSpace == 0.f ) return;
    CGFloat _movingDistance = _maxToLeftMovingSpace * percentage;
    self.view.transform = CGAffineTransformMakeTranslation(-_movingDistance, 0);
    if ( percentage == 0 ) {
        [_maskView removeFromSuperview];
        [_maskView setAlpha:0.f];
    } else {
        if ( _maskView.superview == nil ) {
            [self.view addSubview:_maskView];
        }
    }
}

- (void)mainViewIsMovingToRightWithPercentage:(CGFloat)percentage
{
    if ( _maxToRightMovingSpace == 0.f ) return;
    CGFloat _movingDistance = _maxToRightMovingSpace * percentage;
    self.view.transform = CGAffineTransformMakeTranslation(_movingDistance, 0);
    if ( percentage == 0 ) {
        [_maskView removeFromSuperview];
        [_maskView setAlpha:0.f];
    } else {
        if ( _maskView.superview == nil ) {
            [self.view addSubview:_maskView];
        }
    }
}

- (void)moveToLeftWithDistance:(CGFloat)distance animated:(BOOL)animated
{
    if ( animated ) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.175];
    }
    
    CGFloat _currentTransform = self.view.transform.tx;
    _currentTransform -= PYABSF(distance);
    if ( _currentTransform < -_maxToLeftMovingSpace ) {
        _currentTransform = -_maxToLeftMovingSpace;
    }
    CGAffineTransform _t = CGAffineTransformMakeTranslation(_currentTransform, 0);
    self.view.transform = _t;
    [[PYApperance sharedApperance] _keyViewController:self changedTransform:_t];
    if ( _currentTransform == 0.f ) {
        [_maskView removeFromSuperview];
        [_maskView setAlpha:0.f];
    } else {
        if ( _maskView.superview == nil ) {
            [self.view addSubview:_maskView];
        }
        CGFloat _percentage = 0.f;
        if ( _currentTransform > 0 ) {
            // Not return to zero point, calculate with right space
            _percentage = _currentTransform / _maxToRightMovingSpace;
        } else {
            _percentage = PYABSF(_currentTransform) / _maxToLeftMovingSpace;
        }
        CGFloat _alpha = _percentage * self.maxMaskAlphaRate;
        [_maskView setAlpha:_alpha];
    }

    if ( animated ) {
        [UIView commitAnimations];
    }
}

- (void)moveToRightWithDistance:(CGFloat)distance animated:(BOOL)animated
{
    if ( animated ) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.175];
    }
    
    CGFloat _currentTransform = self.view.transform.tx;
    _currentTransform += PYABSF(distance);
    if ( _currentTransform > _maxToRightMovingSpace ) {
        _currentTransform = _maxToRightMovingSpace;
    }
    CGAffineTransform _t = CGAffineTransformMakeTranslation(_currentTransform, 0);
    self.view.transform = _t;
    [[PYApperance sharedApperance] _keyViewController:self changedTransform:_t];
    if ( _currentTransform == 0.f ) {
        [_maskView removeFromSuperview];
        [_maskView setAlpha:0.f];
    } else {
        if ( _maskView.superview == nil ) {
            [self.view addSubview:_maskView];
        }
        CGFloat _percentage = 0;
        if ( _currentTransform < 0 ) {
            // Not return zeor point
            _percentage = PYABSF(_currentTransform) / _maxToLeftMovingSpace;
        } else {
            _percentage = _currentTransform / _maxToRightMovingSpace;
        }
        CGFloat _alpha = _percentage * self.maxMaskAlphaRate;
        [_maskView setAlpha:_alpha];
    }

    if ( animated ) {
        [UIView commitAnimations];
    }
}

- (void)resetViewPosition:(PYActionDone)done
{
    if ( self.view.transform.tx == 0.f && _maskView.alpha == 0.f ) return;
    [UIView animateWithDuration:.175 animations:^{
        self.view.transform = CGAffineTransformIdentity;
        [[PYApperance sharedApperance]
         _keyViewController:self
         changedTransform:CGAffineTransformIdentity];
        [_maskView setAlpha:0.f];
    } completion:^(BOOL finished) {
        [_maskView removeFromSuperview];
        if ( done ) done();
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.maxMaskAlphaRate = 0.6;
    }
    return self;
}

#pragma mark --
#pragma mark Content Size
@dynamic contentFrame;
- (CGRect)contentFrame
{
    return _containerView.frame;
}
@dynamic contentSize;
- (CGSize)contentSize
{
    return _containerView.frame.size;
}

#pragma mark --
#pragma mark top bar
@synthesize topBarHidden = _isTopBarHidden;
- (void)setTopBarHidden:(BOOL)topBarHidden
{
    [self setTopBarHidden:topBarHidden animated:YES];
}
@synthesize topBar = _topBarView;
@synthesize topBarHeight = _topBarHeight;
- (void)__notifyChildrenForContentSizeChangedCausedByBars
{
    // Tell all child viewcontrollers
    for ( UIViewController *_vc in self.viewControllers ) {
        CGRect _vcFrame = _vc.view.frame;
        _vcFrame.size.height = (_containerView.bounds.size.height -
                                _vc.view.frame.origin.y);
        [_vc.view setFrame:_vcFrame];
        [_vc contentSizeDidChanged];
    }
}

- (void)setTopBarHeight:(CGFloat)height
{
    CGFloat _oldHeight = _topBarHeight;
    _topBarHeight = height;
    // Not show, return.
    if ( _isTopBarHidden ) return;
    
    // Change the container frame.
    CGRect _containerFrame = _containerView.frame;
    _containerFrame.size.height += (_oldHeight - height);
    _containerFrame.origin.y = _topBarHeight;
    [_containerView setFrame:_containerFrame];
    
    // Change the bottom view frame.
    CGRect _topFrame = _topBarView.frame;
    _topFrame.size.height = height;
    [_topBarView setFrame:_topFrame];
    [self __notifyChildrenForContentSizeChangedCausedByBars];
}

- (void)__changeTopBarHidden:(BOOL)hidden
{
    // Change container frame.
    CGRect _containerFrame = _containerView.frame;
    if ( hidden == NO ) {
        _containerFrame.size.height -= _topBarHeight;
        _containerFrame.origin.y += _topBarHeight;
        
        // Check if bottom bar height has been changed since last show
        if ( _topBarView.frame.size.height != _topBarHeight ) {
            // chagne the frame
            CGRect _topFrame = self.view.bounds;
            _topFrame.origin.y = 0;
            _topFrame.size.height = _topBarHeight;
            [_topBarView setFrame:_topFrame];
        }
    } else {
        _containerFrame.size.height += _topBarHeight;
        _containerFrame.origin.y -= _topBarHeight;
    }
    [_containerView setFrame:_containerFrame];
    [_topBarView setAlpha:(hidden ? 0.f : 1.f)];
}

- (void)setTopBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if ( _isTopBarHidden == hidden ) return;
    _isTopBarHidden = hidden;
    
    if ( animated ) {
        [UIView animateWithDuration:.175 animations:^{
            [self __changeTopBarHidden:hidden];
        } completion:^(BOOL finished) {
            [self __notifyChildrenForContentSizeChangedCausedByBars];
        }];
    } else {
        [self __changeTopBarHidden:hidden];
        [self __notifyChildrenForContentSizeChangedCausedByBars];
    }
}

#pragma mark --
#pragma mark Bottom Bar
@synthesize bottomBarHidden = _isBottomBarHidden;
- (void)setBottomBarHidden:(BOOL)bottomBarHidden
{
    [self setBottomBarHidden:bottomBarHidden animated:YES];
}
@synthesize bottomBar = _bottomBarView;
@synthesize bottomBarHeight = _bottomBarHeight;
- (void)__notifyChildrenForContentSizeChangedCausedByBottomBar __deprecated
{
    // Tell all child viewcontrollers
    for ( UIViewController *_vc in self.viewControllers ) {
        CGRect _vcFrame = _vc.view.frame;
        _vcFrame.size.height = (_containerView.bounds.size.height -
                                _vc.view.frame.origin.y);
        [_vc.view setFrame:_vcFrame];
        [_vc contentSizeDidChanged];
    }
}
- (void)setBottomBarHeight:(CGFloat)height
{
    CGFloat _oldHeight = _bottomBarHeight;
    _bottomBarHeight = height;
    // Not show, return.
    if ( _isBottomBarHidden ) return;
    
    // Change the container frame.
    CGRect _containerFrame = _containerView.frame;
    _containerFrame.size.height += (_oldHeight - height);
    [_containerView setFrame:_containerFrame];
    
    // Change the bottom view frame.
    CGRect _bottomFrame = _bottomBarView.frame;
    _bottomFrame.size.height = height;
    _bottomFrame.origin.y -= (_oldHeight - height);
    [_bottomBarView setFrame:_bottomFrame];
    [self __notifyChildrenForContentSizeChangedCausedByBars];
}

- (void)__changeBottomBarHidden:(BOOL)hidden
{
    // Change container frame.
    CGRect _containerFrame = _containerView.frame;
    if ( hidden == NO ) {
        _containerFrame.size.height -= _bottomBarHeight;
        
        // Check if bottom bar height has been changed since last show
        if ( _bottomBarView.frame.size.height != _bottomBarHeight ) {
            // chagne the frame
            CGRect _bottomFrame = self.view.bounds;
            _bottomFrame.origin.y = _containerFrame.size.height;
            _bottomFrame.size.height = _bottomBarHeight;
            [_bottomBarView setFrame:_bottomFrame];
        }
    } else {
        _containerFrame.size.height += _bottomBarHeight;
    }
    [_containerView setFrame:_containerFrame];
    [_bottomBarView setAlpha:(hidden ? 0.f : 1.f)];
}

- (void)setBottomBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if ( _isBottomBarHidden == hidden ) return;
    _isBottomBarHidden = hidden;
    
    if ( animated ) {
        [UIView animateWithDuration:.175 animations:^{
            [self __changeBottomBarHidden:hidden];
        } completion:^(BOOL finished) {
            [self __notifyChildrenForContentSizeChangedCausedByBars];
        }];
    } else {
        [self __changeBottomBarHidden:hidden];
        [self __notifyChildrenForContentSizeChangedCausedByBars];
    }
}

// Override the [loadView] to initialize the bottom bar.
- (void)loadView
{
    // Copy the old container.
    [super loadView];
    _containerView = self.view;
    self.view = [[UIView alloc] init];
    [self.view setFrame:_containerView.frame];
    
    _topBarHeight = 44.f;
    _topBarView = [[UIView alloc] init];
    [_topBarView setAlpha:0.f];
    [_topBarView
     setFrame:CGRectMake(0, 0, _containerView.frame.size.width, _topBarHeight)];
    
    _bottomBarHeight = 44.f;
    _bottomBarView = [[UIView alloc] init];
    [_bottomBarView setAlpha:0.f];
    [_bottomBarView
     setFrame:CGRectMake(0, _containerView.frame.size.height - _bottomBarHeight - _topBarHeight,
                         _containerView.frame.size.width, _bottomBarHeight)];
    // [_bottomBarView setTransform:CGAffineTransformMakeTranslation(0, _bottomBarHeight)];
    [self.view addSubview:_containerView];
    [self.view addSubview:_topBarView];
    [self.view addSubview:_bottomBarView];
    _isBottomBarHidden = YES;
    
    _maskView = [[UIView alloc] initWithFrame:_containerView.frame];
    [_maskView setBackgroundColor:[UIColor blackColor]];
    [_maskView setAlpha:0];
    UIPanGestureRecognizer *_maskPG = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(_actionMaskViewPanHandler:)];
    [_maskView addGestureRecognizer:_maskPG];
    
    UITapGestureRecognizer *_maskTG = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(_actionMaskViewTapHandler:)];
    [_maskView addGestureRecognizer:_maskTG];
}

- (void)_actionMaskViewTapHandler:(id)sender
{
    [self resetViewPosition:nil];
}

- (void)_actionMaskViewPanHandler:(id)sender
{
    [self _gesturePanHandler:sender];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark Pan Action.

- (void)_gesturePanHandler:(id)sender
{
    UIPanGestureRecognizer *_pg = (UIPanGestureRecognizer *)sender;
    CGPoint _touchPoint = [_pg locationInView:[UIApplication sharedApplication].keyWindow];
    
    if ( _pg.state == UIGestureRecognizerStateBegan ) {
        // Store the first point.
        _lastTouchPoint = _touchPoint;
        [[self.visibleViewController.view findFirstResponsder] resignFirstResponder];
    } else if ( _pg.state == UIGestureRecognizerStateChanged ) {
        CGFloat _deltaHor = _touchPoint.x - _lastTouchPoint.x;
        if ( _deltaHor > 0 ) {
            [self moveToRightWithDistance:_deltaHor animated:NO];
        } else {
            [self moveToLeftWithDistance:-_deltaHor animated:NO];
        }
        _lastTouchPoint = _touchPoint;
        _lastDelta = _deltaHor;
    } else if ( _pg.state == UIGestureRecognizerStateRecognized ) {
        // Release current object...
        if ( _lastDelta > 0 ) {
            // Move to right stage if current transform is zero.
            if ( self.view.transform.tx < 0.f ) {
                [self moveToRightWithDistance:self.view.transform.tx animated:YES];
            } else {
                [self moveToRightWithDistance:_maxToRightMovingSpace animated:YES];
            }
        } else {
            if ( self.view.transform.tx > 0.f ) {
                [self moveToLeftWithDistance:self.view.transform.tx animated:YES];
            } else {
                [self moveToLeftWithDistance:_maxToLeftMovingSpace animated:YES];
            }
        }
    }
}

#pragma mark --
#pragma mark Override

// When push viewcontroller, reset view position first.
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self resetViewPosition:nil];
    [super pushViewController:viewController animated:animated];
}

- (void)willBeSwitchedToFront
{
    [self.visibleViewController willBeSwitchedToFront];
}

- (void)didBeSwitchedToFront
{
    [self.visibleViewController didBeSwitchedToFront];
}

- (void)willBeSwitchedToBackground
{
    [self.visibleViewController willBeSwitchedToBackground];
}
- (void)didBeSwitchedToBackground
{
    [self.visibleViewController didBeSwitchedToBackground];
}

- (void)willPopViewController:(UIViewController *)controller
{
    [self.visibleViewController willPopViewController:controller];
}
- (void)didPoppedViewController:(UIViewController *)controller
{
    [self.visibleViewController didPoppedViewController:controller];
}
- (void)willDismissPopViewController:(UIViewController *)controller
{
    [self.visibleViewController willDismissPopViewController:controller];
}
- (void)didDismissedPopViewController:(UIViewController *)controller
{
    [self.visibleViewController didDismissedPopViewController:controller];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.view setFrame:CGRectMake(0, 0, size.width, size.height)];
    CGFloat _th = (_topBarView.alpha > 0) ? _topBarHeight : 0;
    CGFloat _bh = (_bottomBarView.alpha > 0) ? _bottomBarHeight : 0;
    [_containerView setFrame:CGRectMake(0, _th, size.width, size.height - _th - _bh)];
    
    self.view.transform = CGAffineTransformIdentity;
    [_maskView removeFromSuperview];
    [_maskView setAlpha:0.f];
    [_maskView setFrame:_containerView.frame];
}

@end

@implementation UIViewController (PYNavigationController)

- (void)contentSizeDidChanged
{
    // When the bottom bar show/hide, this method will be invoked.
}

- (void)willBeSwitchedToFront
{
    // Override if need
}

- (void)didBeSwitchedToFront
{
    // Override if need
}

- (void)willBeSwitchedToBackground
{
    // Override if need
}

- (void)didBeSwitchedToBackground
{
    // Override if need
}


@end

// @littlepush
// littlepush@gmail.com
// PYLab
