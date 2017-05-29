//
//  PYNavViewController.h
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

@interface PYNavViewController : UIViewController

// Override the navigation controller's type.
@property (nonatomic, readonly) PYNavigationController      *navigationController;

// The visiable content frame
@property (nonatomic, readonly) CGRect      visiableFrame;

// Callback for user status changed.
- (void)userLoginStatueChanged;

// According to [willMoveToParentViewController], this two
// methods will be invoked.
- (void)viewControllerWillLoad;
- (void)viewControllerDidLoad;
- (void)viewControllerWillUnload;
- (void)viewControllerDidUnload;

// Force to trun debug mode
- (void)forceDebugOn;

// When the view is ready to display the content or system config has been
// changed, or [PYApperance reloadAllContent] has been invoked
- (void)loadContentInViewController;

// After load the view or visiable frame has been changed,
// will invoke this method.
- (void)layoutSubviewsInRect:(CGRect)visiableRect;

// Check if contains tab controller.
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
