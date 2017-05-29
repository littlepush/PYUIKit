//
//  PYApperance.m
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

#import "PYApperance.h"

@interface PYNavigationController (Apperance)
// Poped state.
- (void)setPoppedUpState:(BOOL)poppedUp;
@end
@implementation PYNavigationController (Apperance)
- (void)setPoppedUpState:(BOOL)poppedUp
{
    _isPoppedUp = poppedUp;
}
@end

static PYApperance *_gPYApperance = nil;

@interface PYApperance ()
{
    NSUInteger              _topNavIndex;
}
@end

// KVO Extend
@interface PYApperance (KVOExtend)
// Observer the [popState] of _rootContainer.
PYKVO_CHANGED_RESPONSE(_rootContainer, popState);
@end

@implementation PYApperance

@synthesize rootContainer = _rootContainer;

+ (PYApperance *)sharedApperance
{
    PYSingletonLock
    if ( _gPYApperance == nil ) {
        _gPYApperance = [PYApperance object];
    }
    return _gPYApperance;
    PYSingletonUnLock
}
PYSingletonAllocWithZone(_gPYApperance);
PYSingletonDefaultImplementation;

@synthesize leftMenus = _leftViewControllers;
@synthesize rightMenus = _rightViewControllers;
@synthesize mainViews = _mainViewControllers;

- (id)init
{
    self = [super init];
    if ( self ) {
        _leftViewControllers = [NSMutableArray array];
        _rightViewControllers = [NSMutableArray array];
        _mainViewControllers = [NSMutableArray array];
        
        _leftMenuDisplayWidth = 0.f;
        _rightMenuDisplayWidth = 0.f;
        _maxMaskAlphaRate = 0.6;
        
        _topNavIndex = 0;
    }
    return self;
}

- (void)_didSwitchedMainViewToIndex:(NSUInteger)index
{
    PYNavigationController *_nav = [_mainViewControllers safeObjectAtIndex:index];
    for ( PYNavigationController *_mv in _mainViewControllers ) {
        if ( _mv == _nav ) {
            [_mv didBeSwitchedToFront];
        } else {
            [_mv didBeSwitchedToBackground];
        }
    }
}
- (void)switchMainViewAtIndex:(NSUInteger)index
{
    __weak PYNavigationController *_nav = [_mainViewControllers safeObjectAtIndex:index];
    if ( _nav == nil ) return;
    
    // Already the top one
    if ( [_rootContainer.view.subviews lastObject] == _nav.view ) return;
    for ( PYNavigationController *_mv in _mainViewControllers ) {
        if ( _mv == _nav ) {
            [_mv willBeSwitchedToFront];
        } else {
            [_mv willBeSwitchedToBackground];
        }
    }
    [_rootContainer.view bringSubviewToFront:_nav.view];
    [[_nav topViewController] viewWillAppear:NO];
    //[_nav viewWillAppear:NO];
    [_nav resetViewPosition:^{
        //[_nav didBeSwitchedToFront];
        [[PYApperance sharedApperance] _didSwitchedMainViewToIndex:index];
    }];
    _topNavIndex = index;
}

@synthesize leftMenuDisplayWidth = _leftMenuDisplayWidth;
- (void)setLeftMenuDisplayWidth:(CGFloat)width
{
    @synchronized( self ) {
        for ( PYNavigationController *_mv in _mainViewControllers ) {
            [_mv setMaxToRightMovingSpace:width];
        }
        for ( PYNavigationController *_rv in _rightViewControllers ) {
            [_rv setMaxToRightMovingSpace:width];
        }
        _leftMenuDisplayWidth = width;
    }
}
@synthesize rightMenuDisplayWidth = _rightMenuDisplayWidth;
- (void)setRightMenuDisplayWidth:(CGFloat)width
{
    @synchronized( self ) {
        for ( PYNavigationController *_mv in _mainViewControllers ) {
            [_mv setMaxToLeftMovingSpace:width];
        }
        for ( PYNavigationController *_lv in _leftViewControllers ) {
            [_lv setMaxToLeftMovingSpace:width];
        }
        _rightMenuDisplayWidth = width;
    }
}
@synthesize maxMaskAlphaRate = _maxMaskAlphaRate;
- (void)setMaxMaskAlphaRate:(CGFloat)maxMaskAlphaRate
{
    @synchronized( self ) {
        for ( PYNavigationController *_mv in _mainViewControllers ) {
            [_mv setMaxMaskAlphaRate:maxMaskAlphaRate];
        }
        _maxMaskAlphaRate = maxMaskAlphaRate;
    }
}

// The global loading method
- (void)loadUIFrameworkWithMainView:(NSArray *)mainViews
                           leftMenu:(NSArray *)leftMenus
                          rightMenu:(NSArray *)rightMenus
                      rootContainer:(UIViewController __unsafe_unretained*)rootContainer
{
    @synchronized( self ) {
        PYASSERT(rootContainer != nil, @"root container cannot be nil");
        _rootContainer = rootContainer;
        for ( UIViewController *_uc in leftMenus ) {
            Class _navClass = [rootContainer navigationControllerClassForLeftViewController:_uc];
            PYNavigationController *_nc = [[_navClass alloc] initWithRootViewController:_uc];
            PYASSERT([_nc isKindOfClass:[PYNavigationController class]],
                     @"The navigation class for left view is not a PYNavigationController.");
            [_leftViewControllers addObject:_nc];
            [_nc setViewControllerType:UINavigationControllerTypeLeftMenu];
            [_nc setMaxToLeftMovingSpace:_rightMenuDisplayWidth];
            [_nc setMaxToRightMovingSpace:0.f];
            
            [_rootContainer addChildViewController:_nc];
            [_rootContainer.view addSubview:_nc.view];
        }
        for ( UIViewController *_uc in rightMenus ) {
            Class _navClass = [rootContainer navigationControllerClassForRightViewController:_uc];
            PYNavigationController *_nc = [[_navClass alloc] initWithRootViewController:_uc];
            PYASSERT([_nc isKindOfClass:[PYNavigationController class]],
                     @"The navigation class for right view is not a PYNavigationController.");
            [_rightViewControllers addObject:_nc];
            [_nc setViewControllerType:UINavigationControllerTypeRightMenu];
            [_nc setMaxToRightMovingSpace:_leftMenuDisplayWidth];
            [_nc setMaxToLeftMovingSpace:0.f];

            [_rootContainer addChildViewController:_nc];
            [_rootContainer.view addSubview:_nc.view];
        }
        for ( UIViewController *_uc in mainViews ) {
            Class _navClass = [rootContainer navigationControllerClassForMainViewController:_uc];
            PYNavigationController *_nc = [[_navClass alloc] initWithRootViewController:_uc];
            PYASSERT([_nc isKindOfClass:[PYNavigationController class]],
                     @"The navigation class for main view is not a PYNavigationController.");
            [_mainViewControllers addObject:_nc];
            [_nc setViewControllerType:UINavigationControllerTypeMainView];
            [_nc setMaxToLeftMovingSpace:_rightMenuDisplayWidth];
            [_nc setMaxToRightMovingSpace:_leftMenuDisplayWidth];
            [_nc setMaxMaskAlphaRate:_maxMaskAlphaRate];
            
            [_nc.view.layer setShadowRadius:2.f];
            [_nc.view.layer setShadowOffset:CGSizeMake(0, 0)];
            [_nc.view.layer setShadowColor:[UIColor blackColor].CGColor];
            [_nc.view.layer setShadowOpacity:.75];
            [_nc.view.layer setShadowPath:[UIBezierPath bezierPathWithRect:_nc.view.bounds].CGPath];
        
            [_rootContainer addChildViewController:_nc];
            [_rootContainer.view addSubview:_nc.view];
        }
        
        PYNavigationController *_lastMainView = [_mainViewControllers lastObject];
        if ( _lastMainView == nil ) return;
        for ( PYNavigationController *_nc in _leftViewControllers ) {
            _nc.mainNavController = _lastMainView;
        }
        for ( PYNavigationController *_nc in _rightViewControllers ) {
            _nc.mainNavController = _lastMainView;
        }
        for ( UIViewController *_vc in _mainViewControllers ) {
            if ( [_vc isKindOfClass:[PYNavigationController class]] ) {
                PYNavigationController *_nc = (PYNavigationController *)_vc;
                _nc.mainNavController = _lastMainView;
            }
        }
    }
}

- (void)loadUIFrameworkWithMainView:(UIViewController *)mainView
                      rootContainer:(UIViewController __unsafe_unretained*)rootContainer
{
    if ( mainView == nil ) return;
    [self loadUIFrameworkWithMainView:@[mainView]
                             leftMenu:nil
                            rightMenu:nil
                        rootContainer:rootContainer];
}
- (void)loadUIFrameworkWithMainView:(UIViewController *)mainView
                           leftMenu:(UIViewController *)leftMenu
                      rootContainer:(UIViewController *__unsafe_unretained)rootContainer
{
    if ( mainView == nil || leftMenu == nil ) return;
    [self loadUIFrameworkWithMainView:@[mainView]
                             leftMenu:@[leftMenu]
                            rightMenu:nil
                        rootContainer:rootContainer];
}

- (UIViewController *)visiableController
{
    @synchronized( self ) {
        PYNavigationController *_topPoppedVC = (PYNavigationController *)_rootContainer.poppedViewController;
        if ( _topPoppedVC != nil ) {
            return [_topPoppedVC visibleViewController];
        }
        if ( [_mainViewControllers count] == 0 ) return nil;
        PYNavigationController *_mainNC = [_mainViewControllers safeObjectAtIndex:_topNavIndex];
        return _mainNC.visibleViewController;
    }
}

// Reload all loaded view controllers' content
- (void)reloadAllContent
{
    SEL _loadSel = NSSelectorFromString(@"loadContentInViewController");
    for ( PYNavigationController *_nv in _mainViewControllers ) {
        for ( UIViewController *_vc in _nv.viewControllers ) {
            [_vc tryPerformSelector:_loadSel];
        }
    }
    for ( PYNavigationController *_nv in _leftViewControllers ) {
        for ( UIViewController *_vc in _nv.viewControllers ) {
            [_vc tryPerformSelector:_loadSel];
        }
    }
    for ( PYNavigationController *_nv in _rightViewControllers ) {
        for ( UIViewController *_vc in _nv.viewControllers ) {
            [_vc tryPerformSelector:_loadSel];
        }
    }
    for ( PYNavigationController *_nv in _rootContainer.poppedChildViewControllers ) {
        for ( UIViewController *_vc in _nv.viewControllers ) {
            [_vc tryPerformSelector:_loadSel];
        }
    }
}

// Present pop view controller.
- (void)presentPopViewController:(UIViewController *)viewController
                         options:(NSDictionary *)options
                        complete:(PYActionDone)complete
{
    Class _navClass = [_rootContainer navigationControllerClassForPopViewController:viewController];
    PYNavigationController *_nc = [[_navClass alloc] initWithRootViewController:viewController];
    if ( [_nc isKindOfClass:[PYNavigationController class]] == NO ) {
        ALog(@"The navigation controller for pop is not a PYNavigationController.");
        return;
    }
    [_nc.view setBounds:viewController.view.bounds];
    [_rootContainer presentPopViewController:_nc wihtOptions:options complete:^{
        [_nc setPoppedUpState:YES];
        if ( complete ) complete();
    }];
}
- (void)presentPopViewController:(UIViewController *)viewController
                        duration:(float)duration
                       animation:(NSString *)type
                          center:(CGPoint)center
                        complete:(PYActionDone)complete
{
    [self presentPopViewController:viewController
                           options:@{
                                     kViewControllerPopUpOptionAnimationType:type,
                                     kViewControllerPopUpOptionDuration:@(duration),
                                     kViewControllerPopUpOptionCenterPoint:[NSValue valueWithCGPoint:center]
                                     }
                          complete:complete];
}
- (void)presentPopViewController:(UIViewController *)viewController
                       animation:(NSString *)type
                        duration:(float)duration
{
    [self presentPopViewController:viewController
                           options:@{
                                     kViewControllerPopUpOptionAnimationType:type,
                                     kViewControllerPopUpOptionDuration:@(duration)
                                     }
                          complete:nil];
}
- (void)presentPopViewController:(UIViewController *)viewController
                       animation:(NSString *)type
{
    [self presentPopViewController:viewController
                           options:@{kViewControllerPopUpOptionAnimationType:type}
                          complete:nil];
}

// Dismiss the poped view controller.
- (void)dismissPoppedViewControllerWithAnimationType:(NSString *)type
                                            duration:(float)duration
                                            complete:(PYActionDone)complete
{
    PYNavigationController *_nc = (PYNavigationController *)_rootContainer.poppedViewController;
    if ( _nc == nil ) return;
    [_nc dismissSelfWithAnimation:type duration:duration complete:complete];
}
- (void)dismissPoppedViewControllerWithAnimationType:(NSString *)type
                                            complete:(PYActionDone)complete
{
    [self dismissPoppedViewControllerWithAnimationType:type duration:0 complete:complete];
}
- (void)dismissPoppedViewControllerWithAnimationType:(NSString *)type
{
    [self dismissPoppedViewControllerWithAnimationType:type duration:0 complete:nil];
}
- (void)dismissLastPoppedViewController
{
    [self dismissPoppedViewControllerWithAnimationType:nil duration:0 complete:nil];
}
- (void)dismissAllPoppedViewControllers
{
    [_rootContainer dismissAllPoppedViewControllers];
}

@end

@implementation UIViewController (PYApperance)

- (UIViewController *)childViewControllerForStatusBarStyle
{
    UIViewController *_vc = [[PYApperance sharedApperance] visiableController];
    if ( [_vc isKindOfClass:[UITabBarController class]] ) {
        UITabBarController *_tbC = (UITabBarController *)_vc;
        _vc = _tbC.selectedViewController;
    }
    if ( _vc == self ) return nil;
    return _vc;
}

// Navigation Controller Class for Specified Main View.
// The class must be PYNavigationController or its subclass.
- (Class)navigationControllerClassForMainViewController:(UIViewController *)viewController
{
    return [PYNavigationController class];
}
// Navigation Controller Class for Specified Left View.
// The class must be PYNavigationController or its subclass.
- (Class)navigationControllerClassForLeftViewController:(UIViewController *)viewController
{
    return [PYNavigationController class];
}
// Navigation Controller Class for Specified Right View.
// The class must be PYNavigationController or its subclass.
- (Class)navigationControllerClassForRightViewController:(UIViewController *)viewController
{
    return [PYNavigationController class];
}
// Navigation Controller Class for Specified Pop View.
// The class must be PYNavigationController or its subclass.
- (Class)navigationControllerClassForPopViewController:(UIViewController *)viewController
{
    return [PYNavigationController class];
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
