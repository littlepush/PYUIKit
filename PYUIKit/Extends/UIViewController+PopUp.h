//
//  UIViewController+PopUp.h
//  PYUIKit
//
//  Created by Push Chen on 8/26/13.
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
#import <PYCore/PYCore.h>

// Pop Animation Type
extern NSString *kPopUpAnimationTypeNone;
extern NSString *kPopUpAnimationTypeJelly;
extern NSString *kPopUpAnimationTypeSmooth;
extern NSString *kPopUpAnimationTypeFade;
extern NSString *kPopUpAnimationTypeSlideFromLeft;
extern NSString *kPopUpAnimationTypeSlideFromRight;
extern NSString *kPopUpAnimationTypeSlideFromBottom;
extern NSString *kPopUpAnimationTypeSlideFromTop;

// Pop Animation Option Keys
extern NSString *kViewControllerPopUpOptionDuration;
extern NSString *kViewControllerPopUpOptionAnimationType;
extern NSString *kViewControllerPopUpOptionCenterPoint;
extern NSString *kViewControllerPopUpOptionMaskColor;
extern NSString *kViewControllerPopUpOptionMaskAlpha;

/*!
 @brief the customized pop up animation method
 */
typedef void (^PYPopUpAnimationMethod)(UIView *view, float duration, PYActionDone complete);

@interface UIViewController (PopUp)

/*!
 @brief Register The Pop Up animation method
 @param type The animation type, should be unique id
 @param popMethod The method block for pop animation
 @param dismissMethod The method block for dismiss animation
 */
+ (void)registerAnimationMethodForType:(NSString *)type
                           popUpMethod:(PYPopUpAnimationMethod)popMethod
                         dismissMethod:(PYPopUpAnimationMethod)dismissMethod;

/*!
 @brief Top popped child view controller
 */
@property (nonatomic, readonly) UIViewController                *poppedViewController;

/*!
 @brief All popped child view controllers
 */
@property (nonatomic, readonly) NSArray                         *poppedChildViewControllers;

// Pop up the view controller with specified animation type.
// Default animation type is Jelly.
// Default duration is .3
/*!
 @brief Pop up a view controller with default animation type and duration
 @param controller The controller to be popped.
 */
- (void)presentPopViewController:(UIViewController *)controller;

/*!
 @brief Pop up a view controller with default animation type
 @param controller The controller to be popped.
 @param duration Animation duration
 */
- (void)presentPopViewController:(UIViewController *)controller
                        duration:(float)duration;

/*!
 @brief Pop up a view controller with default animation type
        and default duration, but has a callback on complete.
 @param controller The controller to be popped.
 @param complete Compelete callback block
 */
- (void)presentPopViewController:(UIViewController *)controller
                        complete:(PYActionDone)complete;

/*!
 @brief Pop up a view controller with default animation type
        and a complete callback block
 @param controller The controller to be popped.
 @param duration Animation duration
 @param complete Compelete callback block
 */
- (void)presentPopViewController:(UIViewController *)controller
                        duration:(float)duration
                        complete:(PYActionDone)complete;
/*!
 @brief Pop up a view controller with default duration
 @param controller The controller to be popped.
 @param type The animation type
 @param complete Compelete callback block
 */
- (void)presentPopViewController:(UIViewController *)controller
                       animation:(NSString *)type
                        complete:(PYActionDone)complete;
/*!
 @brief Pop up a view controller
 @param controller The controller to be popped.
 @param duration Animation duration
 @param type The animation type
 @param complete Compelete callback block
 */
- (void)presentPopViewController:(UIViewController *)controller
                        duration:(float)duration
                       animation:(NSString *)type
                        complete:(PYActionDone)complete;
/*!
 @brief Pop up a view controller with default duration
 @param controller The controller to be popped.
 @param type The animation type
 @param center the center point of current viewcontroller to present the pop view controller
 @param complete Compelete callback block
 */
- (void)presentPopViewController:(UIViewController *)controller
                       animation:(NSString *)type
                          center:(CGPoint)center
                        complete:(PYActionDone)complete;
/*!
 @brief Pop up a view controller
 @param controller The controller to be popped.
 @param duration Animation duration
 @param type The animation type
 @param center the center point of current viewcontroller to present the pop view controller
 @param complete Compelete callback block
 */
- (void)presentPopViewController:(UIViewController *)controller
                        duration:(float)duration
                       animation:(NSString *)type
                          center:(CGPoint)center
                        complete:(PYActionDone)complete;

/*!
 @brief Pop up a view controller with all supported options
 @param controller The controller to be popped.
 @param options See kViewControllerPopUpOptions for more details
 @param complete Compelete callback block
 */
- (void)presentPopViewController:(UIViewController *)controller
                     wihtOptions:(NSDictionary *)options
                        complete:(PYActionDone)complete;

/*!
 @brief Dismiss self with the param popped.
 */
- (void)dismissSelf;
/*!
 @brief Dismiss self with the param popped.
 @param complete Complete callback block
 */
- (void)dismissSelfComplete:(PYActionDone)complete;

/*!
 @brief Dismiss self with the duration popped and specified animation type
 @param type dismiss animation type
 @param complete Complete callback block
 */
- (void)dismissSelfWithAnimation:(NSString *)type
                        complete:(PYActionDone)complete;

/*!
 @brief Dismiss self.
 @param type dismiss animation type
 @param duration dismiss animation duration
 @param complete Complete callback block
 */
- (void)dismissSelfWithAnimation:(NSString *)type
                        duration:(float)duration
                        complete:(PYActionDone)complete;
/*!
 @brief dismiss the top popped view controller
 */
- (void)dismissTopPoppedViewController;

/*!
 @brief loop to dismiss all view controllers
 */
- (void)dismissAllPoppedViewControllers;

// Message Callback For Container
- (void)willPopViewController:(UIViewController *)controller;
- (void)didPoppedViewController:(UIViewController *)controller;
- (void)willDismissPopViewController:(UIViewController *)controller;
- (void)didDismissedPopViewController:(UIViewController *)controller;

// Message Callback For popped view controller
- (void)willBePoppedByParentViewController:(UIViewController *)parent;
- (void)didBePoppedByParentViewController:(UIViewController *)parent;
- (void)willDismisseFromParentViewController:(UIViewController *)parent;
- (void)didDismissFromParentViewController:(UIViewController *)parent;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
