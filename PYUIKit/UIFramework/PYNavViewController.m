//
//  PYNavViewController.m
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

#import "PYNavViewController.h"
#import "PYCore.h"
#import "UIColor+PYUIKit.h"
#import "UIView+PYUIKit.h"

@interface PYNavViewController ()
{
    BOOL            _forceDebugMode;
}

@end

@implementation PYNavViewController

// Debug method
- (void)__debugForView:(UIView *)debugView {
    for ( UIView *_v in debugView.subviews ) {
        [_v.layer setBorderWidth:.5];
        [_v.layer setBorderColor:[UIColor randomColor].CGColor];
        [self __debugForView:_v];
    }
}

// Visiable Frame
@dynamic visiableFrame;
- (CGRect)visiableFrame
{
    CGRect _vf = [UIScreen mainScreen].bounds;
    UINavigationController *_nvc = self.navigationController;
    if ( self.tabBarController && [[UITabBar appearance] isTranslucent] == NO ) {
        _vf.size.height -= self.tabBarController.tabBar.frame.size.height;
        _nvc = self.tabBarController.navigationController;
    }
    if ( _nvc && (_nvc.navigationBarHidden == NO) && (_nvc.navigationBar.translucent == NO) ) {
        CGFloat _sth = ([UIApplication sharedApplication].statusBarHidden ? 0 :
                        [UIApplication sharedApplication].statusBarFrame.size.height);
        _vf.size.height -= (_nvc.navigationBar.frame.size.height + _sth);
    }
    if ( [_nvc isKindOfClass:[PYNavigationController class]] ) {
        PYNavigationController *_pnvc = (PYNavigationController *)_nvc;
        //if ( _pnvc.topBarHidden == NO ) _vf.size.height -= _pnvc.topBarHeight;
        if ( _pnvc.bottomBarHidden == NO ) _vf.size.height -= _pnvc.bottomBarHeight;
    }
    return _vf;
}

@dynamic navigationController;
- (PYNavigationController *)navigationController
{
    if ( self.tabBarController ) return (PYNavigationController *)self.tabBarController.navigationController;
    return (PYNavigationController *)[super navigationController];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)userLoginStatueChanged
{
    // Refresh the UI if needed.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navigationController pushViewController:viewController animated:animated];
}

- (void)popViewControllerAnimated:(BOOL)animated
{
    [self.navigationController popViewControllerAnimated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    if ( parent == nil ) {
        // Unload
        [[self.view findFirstResponsder] resignFirstResponder];
        
        [NF_CENTER
         removeObserver:self
         name:UIApplicationDidChangeStatusBarFrameNotification
         object:nil];
        
        [self viewControllerWillUnload];
    } else {
        [NF_CENTER
         addObserver:self
         selector:@selector(_actionStatusBarHeightChanged)
         name:UIApplicationDidChangeStatusBarFrameNotification
         object:nil];
        
        [self viewControllerWillLoad];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutSubviewsInRect:self.visiableFrame];
}

- (void)forceDebugOn
{
    _forceDebugMode = YES;
    [self __debugForView:self.view];
}

- (void)viewControllerWillLoad
{
    PYLog(@"Will Load view controller: %@", NSStringFromClass([self class]));
}

- (void)viewControllerWillUnload
{
    PYLog(@"Will Unload view controller: %@", NSStringFromClass([self class]));
}

- (void)_actionStatusBarHeightChanged
{
    // Need to reload
    [self layoutSubviewsInRect:self.visiableFrame];
}

- (void)layoutSubviewsInRect:(CGRect)visiableRect
{
    // Nothing
}

- (void)contentSizeDidChanged
{
    [self layoutSubviewsInRect:self.visiableFrame];
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
