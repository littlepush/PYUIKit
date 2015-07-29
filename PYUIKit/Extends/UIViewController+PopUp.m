//
//  UIViewController+PopUp.m
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

#import "UIViewController+PopUp.h"

#define UIVIEW_POP_MASK_VIEW_TAG            10240
#define UIVIEW_POP_CHILD_VIEW_TAG           20480

#define UIVIEW_POP_VCLIST           @"kPYPopUpViewControllerList"
#define UIVIEW_POP_MASK_VIEW        @"kPYPopUpViewControllerMaskView"

NSString *kPopUpAnimationTypeNone = @"kPopUpAnimationTypeNone";
NSString *kPopUpAnimationTypeJelly = @"kPopUpAnimationTypeJelly";
NSString *kPopUpAnimationTypeSmooth = @"kPopUpAnimationTypeSmooth";
NSString *kPopUpAnimationTypeFade = @"kPopUpAnimationTypeFade";
NSString *kPopUpAnimationTypeSlideFromLeft = @"kPopUpAnimationTypeSlideFromLeft";
NSString *kPopUpAnimationTypeSlideFromRight = @"kPopUpAnimationTypeSlideFromRight";
NSString *kPopUpAnimationTypeSlideFromBottom = @"kPopUpAnimationTypeSlideFromBottom";
NSString *kPopUpAnimationTypeSlideFromTop = @"kPopUpAnimationTypeSlideFromTop";

NSString *kViewControllerPopUpOptionDuration = @"kViewControllerPopUpOptionDuration";
NSString *kViewControllerPopUpOptionAnimationType = @"kViewControllerPopUpOptionAnimationType";
NSString *kViewControllerPopUpOptionCenterPoint = @"kViewControllerPopUpOptionCenterPoint";
NSString *kViewControllerPopUpOptionMaskColor = @"kViewControllerPopUpOptionMaskColor";
NSString *kViewControllerPopUpOptionMaskAlpha = @"kViewControllerPopUpOptionMaskAlpha";

@interface __PYPopUpAnimation : NSObject
{
    NSMutableDictionary             *_animationMethods;
}

+ (instancetype)shared;

- (void)registerAnimationType:(NSString *)type
                  popUpMethod:(PYPopUpAnimationMethod)pmethod
                dismissMethod:(PYPopUpAnimationMethod)dmethod;

- (void)performPopUpAnimation:(NSString *)type
                      forView:(UIView *)view duration:(float)duration
                     complete:(PYActionDone)complete;
- (void)performDismissAnimation:(NSString *)type
                        forView:(UIView *)view
                       duration:(float)duration
                       complete:(PYActionDone)complete;


// Animations
- (void)animationPopUpJelly:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;
- (void)animationPopUpSmooth:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;
- (void)animationPopUpFade:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;
- (void)animationPopUpNone:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;
- (void)animationPopUpSlideFromLeft:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;
- (void)animationPopUpSlideFromRight:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;
- (void)animationPopUpSlideFromBottom:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;
- (void)animationPopUpSlideFromTop:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;

- (void)animationDismissJelly:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;
- (void)animationDismissSmooth:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;
- (void)animationDismissFade:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;
- (void)animationDismissNone:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;
- (void)animationDismissSlideFromLeft:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;
- (void)animationDismissSlideFromRight:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;
- (void)animationDismissSlideFromBottom:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;
- (void)animationDismissSlideFromTop:(UIView *)view duration:(float)duration complete:(PYActionDone)complete;

@end

static __PYPopUpAnimation *_gAnimation = nil;

@implementation __PYPopUpAnimation

+ (instancetype)shared {
    PYSingletonLock
    if ( _gAnimation == nil ) {
        _gAnimation = [__PYPopUpAnimation object];
    }
    return _gAnimation;
    PYSingletonUnLock
}
PYSingletonAllocWithZone(_gAnimation);
PYSingletonDefaultImplementation

#define __PYANIMATION_REGISTER(type)                                                                \
[self                                                                                               \
 registerAnimationType:kPopUpAnimationType##type                                                    \
 popUpMethod:^(UIView *view, float duration, PYActionDone complete) {                               \
    [[__PYPopUpAnimation shared] animationPopUp##type:view duration:duration complete:complete];    \
 }                                                                                                  \
 dismissMethod:^(UIView *view, float duration, PYActionDone complete) {                             \
    [[__PYPopUpAnimation shared] animationDismiss##type:view duration:duration complete:complete];  \
 }]

- (id)init {
    self = [super init];
    if ( self ) {
        _animationMethods = [NSMutableDictionary dictionary];
        
        // Registe all supported animation
        __PYANIMATION_REGISTER(None);
        __PYANIMATION_REGISTER(Jelly);
        __PYANIMATION_REGISTER(Smooth);
        __PYANIMATION_REGISTER(Fade);
        __PYANIMATION_REGISTER(SlideFromLeft);
        __PYANIMATION_REGISTER(SlideFromRight);
        __PYANIMATION_REGISTER(SlideFromTop);
        __PYANIMATION_REGISTER(SlideFromBottom);
    }
    return self;
}

- (void)registerAnimationType:(NSString *)type
                  popUpMethod:(PYPopUpAnimationMethod)pmethod
                dismissMethod:(PYPopUpAnimationMethod)dmethod
{
    PYSingletonLock
    NSDictionary *_animationData = @{
                                     @"pop": pmethod,
                                     @"dismiss": dmethod
                                     };
    [_animationMethods setObject:_animationData forKey:type];
    PYSingletonUnLock
}

- (void)performPopUpAnimation:(NSString *)type
                      forView:(UIView *)view
                     duration:(float)duration
                     complete:(PYActionDone)complete
{
    PYSingletonLock
    NSDictionary *_animationData = [_animationMethods objectForKey:type];
    if ( _animationData != nil ) {
        PYPopUpAnimationMethod _m = [_animationData objectForKey:@"pop"];
        if ( _m != nil ) _m(view, duration, complete);
    } else {
        if ( complete ) complete();
    }
    PYSingletonUnLock
}

- (void)performDismissAnimation:(NSString *)type
                        forView:(UIView *)view
                       duration:(float)duration
                       complete:(PYActionDone)complete
{
    PYSingletonLock
    NSDictionary *_animationData = [_animationMethods objectForKey:type];
    if ( _animationData != nil ) {
        PYPopUpAnimationMethod _m = [_animationData objectForKey:@"dismiss"];
        if ( _m != nil ) _m(view, duration, complete);
    } else {
        if ( complete ) complete();
    }
    PYSingletonUnLock
}

// Animations
- (void)animationPopUpJelly:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    view.transform = CGAffineTransformMakeScale(.01, .01);
    [UIView animateWithDuration:duration / 1.5 animations:^{
        view.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration / 2 animations:^{
            view.transform = CGAffineTransformMakeScale(.9, .9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration / 2 animations:^{
                view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if ( complete ) complete( );
            }];
        }];
    }];
}
- (void)animationDismissJelly:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    [UIView animateWithDuration:.3 / 1.5 animations:^{
        view.transform = CGAffineTransformMakeScale(.01, .01);
    } completion:^(BOOL finished) {
        if ( complete ) complete( );
        view.transform = CGAffineTransformIdentity;
    }];
}

- (void)animationPopUpSmooth:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    // Scale to a point first.
    view.transform = CGAffineTransformMakeScale(.01, .01);
    [UIView animateWithDuration:duration / 2 animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ( complete ) complete( );
    }];
}
- (void)animationDismissSmooth:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    [UIView animateWithDuration:.3 / 1.5 animations:^{
        view.transform = CGAffineTransformMakeScale(.01, .01);
    } completion:^(BOOL finished) {
        if ( complete ) complete( );
        view.transform = CGAffineTransformIdentity;
    }];
}

- (void)animationPopUpFade:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    view.alpha = 0.f;
    [UIView animateWithDuration:duration / 2 animations:^{
        view.alpha = 1.f;
    } completion:^(BOOL finished) {
        if ( complete ) complete();
    }];
}
- (void)animationDismissFade:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    [UIView animateWithDuration:.3 / 2 animations:^{
        view.alpha = 0.f;
    } completion:^(BOOL finished) {
        if ( complete ) complete();
        view.transform = CGAffineTransformIdentity;
    }];
}

- (void)animationPopUpNone:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    if (complete) complete();
}
- (void)animationDismissNone:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    if (complete) complete();
}

- (void)animationPopUpSlideFromLeft:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    view.transform = CGAffineTransformMakeTranslation(view.superview.bounds.size.width, 0);
    [UIView animateWithDuration:duration / 2 animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ( complete ) complete();
    }];
}
- (void)animationDismissSlideFromLeft:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    [UIView animateWithDuration:.3 / 2 animations:^{
        view.transform =
        CGAffineTransformMakeTranslation(view.superview.bounds.size.width, 0);;
    } completion:^(BOOL finished) {
        if ( complete ) complete();
        view.transform = CGAffineTransformIdentity;
    }];
}

- (void)animationPopUpSlideFromRight:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    view.transform = CGAffineTransformMakeTranslation(-view.superview.bounds.size.width, 0);
    [UIView animateWithDuration:duration / 2 animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ( complete ) complete();
    }];
}
- (void)animationDismissSlideFromRight:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    [UIView animateWithDuration:.3 / 2 animations:^{
        view.transform =
        CGAffineTransformMakeTranslation(-view.superview.bounds.size.width, 0);;
    } completion:^(BOOL finished) {
        if ( complete ) complete();
        view.transform = CGAffineTransformIdentity;
    }];
}

- (void)animationPopUpSlideFromBottom:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    view.transform = CGAffineTransformMakeTranslation(0, view.superview.bounds.size.height);
    [UIView animateWithDuration:duration / 2 animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ( complete ) complete();
    }];
}
- (void)animationDismissSlideFromBottom:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    [UIView animateWithDuration:.3 / 2 animations:^{
        view.transform =
        CGAffineTransformMakeTranslation(0, view.superview.bounds.size.height);;
    } completion:^(BOOL finished) {
        if ( complete ) complete();
        view.transform = CGAffineTransformIdentity;
    }];
}

- (void)animationPopUpSlideFromTop:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    view.transform = CGAffineTransformMakeTranslation(0, -view.superview.bounds.size.height);
    [UIView animateWithDuration:duration / 2 animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ( complete ) complete();
    }];
}
- (void)animationDismissSlideFromTop:(UIView *)view duration:(float)duration complete:(PYActionDone)complete
{
    [UIView animateWithDuration:.3 / 2 animations:^{
        view.transform =
        CGAffineTransformMakeTranslation(0, -view.superview.bounds.size.height);;
    } completion:^(BOOL finished) {
        if ( complete ) complete();
        view.transform = CGAffineTransformIdentity;
    }];
}

@end

/*!
 @brief Internal Mask View
 */
@interface __PYMaskView : UIView
@property (nonatomic, assign)   UIViewController            *container;
@property (nonatomic, assign)   UIViewController            *customController;
@property (nonatomic, copy)     NSString *                  animationType;
@property (nonatomic, assign)   float                       duration;
@property (nonatomic, assign)   CGPoint                     centerPoint;
@property (nonatomic, assign)   float                       visiableAlpha;

+ (instancetype)maskViewWithContainer:(UIViewController *)container
                    popViewController:(UIViewController *)popViewController
                              options:(NSDictionary *)options;
// Display self in container
- (void)showSelf;
- (void)hideSelf;

@end

@implementation __PYMaskView
- (void)_actionMaskViewTapHandler:(id)sender
{
    @synchronized( self ) {
        if ( self.container == nil ) return;
        if ( self.customController == nil ) return;
        if ( self.customController.parentViewController != self.container ) return;
        // Use the new api to dismiss the vc
        [self.customController dismissSelf];
    }
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.animationType = kPopUpAnimationTypeJelly;
        self.duration = .3;
        self.centerPoint = self.center;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.f;
        self.visiableAlpha = .3f;
        UITapGestureRecognizer *_tapGesture =
        [[UITapGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(_actionMaskViewTapHandler:)];
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}
+ (instancetype)maskViewWithContainer:(UIViewController *)container
                    popViewController:(UIViewController *)popViewController
                              options:(NSDictionary *)options
{
    __PYMaskView *_mv = [[__PYMaskView alloc] initWithFrame:container.view.bounds];
    _mv.container = container;
    _mv.customController = popViewController;
    
    if ( [options objectForKey:kViewControllerPopUpOptionDuration] ) {
        _mv.duration = [options doubleObjectForKey:kViewControllerPopUpOptionDuration];
    }
    
    if ( [options objectForKey:kViewControllerPopUpOptionAnimationType] ) {
        _mv.animationType = [options stringObjectForKey:kViewControllerPopUpOptionAnimationType];
    }
    
    if ( [options objectForKey:kViewControllerPopUpOptionCenterPoint] ) {
        NSValue *_centerValue = [options objectForKey:kViewControllerPopUpOptionCenterPoint];
        _mv.centerPoint = [_centerValue CGPointValue];
    }
    
    if ( [options objectForKey:kViewControllerPopUpOptionMaskColor] ) {
        [_mv setBackgroundColor:[options objectForKey:kViewControllerPopUpOptionMaskColor]];
    }
    
    if ( [options objectForKey:kViewControllerPopUpOptionMaskAlpha] ) {
        [_mv setVisiableAlpha:[options doubleObjectForKey:kViewControllerPopUpOptionMaskAlpha]];
    }
    
    return _mv;
}

- (void)showSelf
{
    BOOL _animated = [self.animationType isEqualToString:kPopUpAnimationTypeNone] == NO;
    if ( _animated ) {
        [UIView animateWithDuration:self.duration animations:^{
            [self setAlpha:self.visiableAlpha];
        }];
    } else {
        [self setAlpha:self.visiableAlpha];
    }
}

- (void)hideSelf
{
    BOOL _animated = [self.animationType isEqualToString:kPopUpAnimationTypeNone] == NO;
    if ( _animated ) {
        [UIView animateWithDuration:self.duration animations:^{
            [self setAlpha:0];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [self setAlpha:0];
        [self removeFromSuperview];
    }
}

@end

@implementation UIViewController (PopUp)

@dynamic poppedChildViewControllers;
- (NSArray *)poppedChildViewControllers
{
    @synchronized( self ) {
        NSMutableArray *_pcv = [self.view.layer valueForKey:UIVIEW_POP_VCLIST];
        if ( _pcv == nil ) {
            _pcv = [NSMutableArray array];
            [self.view.layer setValue:_pcv forKey:UIVIEW_POP_VCLIST];
        }
        NSMutableArray *_controllers = [NSMutableArray array];
        for ( __PYMaskView *_mv in _pcv ) {
            [_controllers addObject:_mv.customController];
        }
        return _controllers;
    }
}

@dynamic poppedViewController;
- (UIViewController *)poppedViewController
{
    return [self.poppedChildViewControllers lastObject];
}

// Message Callback
- (void)willPopViewController:(UIViewController *)controller {}
- (void)didPoppedViewController:(UIViewController *)controller {}
- (void)willDismissPopViewController:(UIViewController *)controller {}
- (void)didDismissedPopViewController:(UIViewController *)controller {}

// Message Callback For popped view controller
- (void)willBePoppedByParentViewController:(UIViewController *)parent {}
- (void)didBePoppedByParentViewController:(UIViewController *)parent {}
- (void)willDismisseFromParentViewController:(UIViewController *)parent {}
- (void)didDismissFromParentViewController:(UIViewController *)parent {}

/*!
 @brief Register The Pop Up animation method
 @param type The animation type, should be unique id
 @param popMethod The method block for pop animation
 @param dismissMethod The method block for dismiss animation
 */
+ (void)registerAnimationMethodForType:(NSString *)type
                           popUpMethod:(PYPopUpAnimationMethod)popMethod
                         dismissMethod:(PYPopUpAnimationMethod)dismissMethod
{
    [[__PYPopUpAnimation shared] registerAnimationType:type popUpMethod:popMethod dismissMethod:dismissMethod];
}

/*!
 @brief Pop up a view controller with default animation type and duration
 @param controller The controller to be popped.
 */
- (void)presentPopViewController:(UIViewController *)controller
{
    [self presentPopViewController:controller
                       wihtOptions:nil
                          complete:nil];
}

/*!
 @brief Pop up a view controller with default animation type
 @param controller The controller to be popped.
 @param duration Animation duration
 */
- (void)presentPopViewController:(UIViewController *)controller
                        duration:(float)duration
{
    [self presentPopViewController:controller
                       wihtOptions:@{
                                     kViewControllerPopUpOptionDuration:@(duration)
                                     }
                          complete:nil];
}

/*!
 @brief Pop up a view controller with default animation type
 and default duration, but has a callback on complete.
 @param controller The controller to be popped.
 @param complete Compelete callback block
 */
- (void)presentPopViewController:(UIViewController *)controller
                        complete:(PYActionDone)complete
{
    [self presentPopViewController:controller
                       wihtOptions:nil
                          complete:complete];
}

/*!
 @brief Pop up a view controller with default animation type
 and a complete callback block
 @param controller The controller to be popped.
 @param duration Animation duration
 @param complete Compelete callback block
 */
- (void)presentPopViewController:(UIViewController *)controller
                        duration:(float)duration
                        complete:(PYActionDone)complete
{
    [self presentPopViewController:controller
                       wihtOptions:@{
                                     kViewControllerPopUpOptionDuration:@(duration)
                                     }
                          complete:complete];

}
/*!
 @brief Pop up a view controller with default duration
 @param controller The controller to be popped.
 @param animation The animation type
 @param complete Compelete callback block
 */
- (void)presentPopViewController:(UIViewController *)controller
                       animation:(NSString *)type
                        complete:(PYActionDone)complete
{
    [self presentPopViewController:controller
                       wihtOptions:@{
                                     kViewControllerPopUpOptionAnimationType:type
                                     }
                          complete:complete];
}
/*!
 @brief Pop up a view controller
 @param controller The controller to be popped.
 @param duration Animation duration
 @param animation The animation type
 @param complete Compelete callback block
 */
- (void)presentPopViewController:(UIViewController *)controller
                        duration:(float)duration
                       animation:(NSString *)type
                        complete:(PYActionDone)complete
{
    [self presentPopViewController:controller
                       wihtOptions:@{
                                     kViewControllerPopUpOptionDuration:@(duration),
                                     kViewControllerPopUpOptionAnimationType:type
                                     }
                          complete:complete];

}
/*!
 @brief Pop up a view controller with default duration
 @param controller The controller to be popped.
 @param animation The animation type
 @param center the center point of current viewcontroller to present the pop view controller
 @param complete Compelete callback block
 */
- (void)presentPopViewController:(UIViewController *)controller
                       animation:(NSString *)type
                          center:(CGPoint)center
                        complete:(PYActionDone)complete
{
    [self presentPopViewController:controller
                       wihtOptions:@{
                                     kViewControllerPopUpOptionAnimationType:type,
                                     kViewControllerPopUpOptionCenterPoint:[NSValue valueWithCGPoint:center]
                                     }
                          complete:complete];
}
/*!
 @brief Pop up a view controller
 @param controller The controller to be popped.
 @param duration Animation duration
 @param animation The animation type
 @param center the center point of current viewcontroller to present the pop view controller
 @param complete Compelete callback block
 */
- (void)presentPopViewController:(UIViewController *)controller
                        duration:(float)duration
                       animation:(NSString *)type
                          center:(CGPoint)center
                        complete:(PYActionDone)complete
{
    [self presentPopViewController:controller
                       wihtOptions:@{
                                     kViewControllerPopUpOptionDuration:@(duration),
                                     kViewControllerPopUpOptionAnimationType:type,
                                     kViewControllerPopUpOptionCenterPoint:[NSValue valueWithCGPoint:center]
                                     }
                          complete:complete];
}

/*!
 @brief Pop up a view controller with all supported options
 @param controller The controller to be popped.
 @param options See kViewControllerPopUpOptions for more details
 @param complete Compelete callback block
 */
- (void)presentPopViewController:(UIViewController *)controller
                     wihtOptions:(NSDictionary *)options
                        complete:(PYActionDone)complete
{
    // Final Method
    if ( controller == nil ) return;
    PYSingletonLock
    
    // Invoke the callbakc
    [self willPopViewController:controller];
    [controller willBePoppedByParentViewController:self];
    
    // Add as child controller
    [self addChildViewController:controller];
    
    // Create the mask view and parse all options
    __PYMaskView *_maskView = [__PYMaskView maskViewWithContainer:self popViewController:controller options:options];
    [controller.view setCenter:_maskView.centerPoint];
    
    // Add to container
    [self.view addSubview:_maskView];
    [self.view addSubview:controller.view];
    
    // add the mask view to the list
    NSMutableArray *_pcv = [self.view.layer valueForKey:UIVIEW_POP_VCLIST];
    if ( _pcv == nil ) {
        _pcv = [NSMutableArray array];
        [self.view.layer setValue:_pcv forKey:UIVIEW_POP_VCLIST];
    }
    [_pcv addObject:_maskView];
    [controller.view.layer setValue:_maskView forKey:UIVIEW_POP_MASK_VIEW];
    
    [_maskView showSelf];
    // Do animation
    [[__PYPopUpAnimation shared]
     performPopUpAnimation:_maskView.animationType
     forView:controller.view
     duration:_maskView.duration
     complete:^{
         [self didPoppedViewController:controller];
         [controller didBePoppedByParentViewController:self];
         if ( complete ) complete();
    }];
    
    PYSingletonUnLock
}

/*!
 @brief Dismiss self with the param popped.
 */
- (void)dismissSelf
{
    [self dismissSelfWithAnimation:nil duration:0 complete:nil];
}
/*!
 @brief Dismiss self with the param popped.
 @param complete Complete callback block
 */
- (void)dismissSelfComplete:(PYActionDone)complete
{
    [self dismissSelfWithAnimation:nil duration:0 complete:complete];
}

/*!
 @brief Dismiss self with the duration popped and specified animation type
 @param type dismiss animation type
 @param complete Complete callback block
 */
- (void)dismissSelfWithAnimation:(NSString *)type
                        complete:(PYActionDone)complete
{
    [self dismissSelfWithAnimation:type duration:0 complete:complete];
}

/*!
 @brief Dismiss self.
 @param type dismiss animation type
 @param duration dismiss animation duration
 @param complete Complete callback block
 */
- (void)dismissSelfWithAnimation:(NSString *)type
                        duration:(float)duration
                        complete:(PYActionDone)complete
{
    __PYMaskView *_maskView = (__PYMaskView *)[self.view.layer valueForKey:UIVIEW_POP_MASK_VIEW];
    if ( _maskView == nil ) return;
    
    NSString *_animationType = _maskView.animationType;
    if ( [type length] > 0 ) {
        _animationType = type;
    }
    
    float _d = _maskView.duration;
    if ( duration > 0.f ) {
        _d = duration;
    }
    
    [_maskView.container willDismissPopViewController:self];
    [self willDismisseFromParentViewController:_maskView.container];
    
    // Hide the mask view
    [_maskView hideSelf];
    
    [[__PYPopUpAnimation shared]
     performDismissAnimation:_animationType
     forView:self.view
     duration:_d
     complete:^{
         // Remove mask view from self
         [self.view.layer setValue:nil forKey:UIVIEW_POP_MASK_VIEW];
         // Remove mask view from the container's list
         NSMutableArray *_pcv = [_maskView.container.view.layer valueForKey:UIVIEW_POP_VCLIST];
         [_pcv removeObject:_maskView];
         
         // Remove self from parent
         [self.view removeFromSuperview];
         [self removeFromParentViewController];
         
         [_maskView.container didDismissedPopViewController:self];
         [self didDismissFromParentViewController:_maskView.container];
         
         if ( complete ) complete();
     }];
}
/*!
 @brief dismiss the top popped view controller
 */
- (void)dismissTopPoppedViewController
{
    UIViewController *_tpvc = self.poppedViewController;
    if ( _tpvc != nil ) {
        [_tpvc dismissSelf];
    }
}

/*!
 @brief loop to dismiss all view controllers
 */
- (void)dismissAllPoppedViewControllers
{
    NSArray *_popVcList = self.poppedChildViewControllers;
    if ( [_popVcList count] == 0 ) return;
    __weak UIViewController *_wself = self;
    UIViewController *_tpvc = [_popVcList lastObject];
    [_tpvc dismissSelfComplete:^{
        [_wself dismissAllPoppedViewControllers];
    }];
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
