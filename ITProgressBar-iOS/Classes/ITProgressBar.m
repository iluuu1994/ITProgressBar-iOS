//
//  ITProgressBar.m
//  ITProgressIndicator-iOS
//
//  Created by Ilija Tovilo on 08/11/13.
//  Copyright (c) 2013 Ilija Tovilo. All rights reserved.
//

#import "ITProgressBar.h"
#import "UIImage+BBlock.h"

#define kStripesAnimationKey @"x"
#define kOpacityAnimationKey @"opacity"
#define kPatternOpacity 0.4

#pragma mark - Interface Extension

@interface ITProgressBar ()
@property BOOL it_isHidden;
@property (nonatomic, strong) CALayer *clipLayer;
@property (nonatomic, strong) CAGradientLayer *backgroundLayer;
@property (nonatomic, strong) CALayer *fillClipLayer;
@property (nonatomic, strong) CALayer *patternLayer;
@end


#pragma mark - Implementation

@implementation ITProgressBar


#pragma mark - Initialisation

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self initLayers];
    _animationDuration = 0.3;
    _progress = 1.0;
    _patternImage = [self stripesImageWithSize:CGSizeMake(30, 20)];
    [self resizeLayers];
    
    self.animates = YES;
    
    [self addObserver:self forKeyPath:@"bounds" options:0 context:nil];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"bounds"];
}

- (void)initLayers {
    [self.layer addSublayer:self.clipLayer];
    [self.clipLayer addSublayer:self.patternLayer];
    
    [self.clipLayer addSublayer:self.backgroundLayer];
    [self.clipLayer addSublayer:self.fillClipLayer];
    
    [self.fillClipLayer addSublayer:self.patternLayer];
    [self.patternLayer setDelegate:self];
    [self.patternLayer setNeedsDisplayOnBoundsChange:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"bounds"]) {
        [self resizeLayers];
    }
}


#pragma mark - Helpers

- (void)resizeLayers {
    self.layer.frame = self.bounds;
    
    self.clipLayer.frame = self.bounds;
    self.backgroundLayer.frame = self.bounds;
    
    [self resizeInnerLayers];
    
    CGRect frame = self.bounds;
    frame.origin.x = -self.patternImage.size.width;
    frame.size.width += self.patternImage.size.width;
    self.patternLayer.frame = frame;
    
    self.clipLayer.cornerRadius = self.bounds.size.height / 2.0;
    self.fillClipLayer.cornerRadius = self.bounds.size.height / 2.0;
    
    self.fillClipLayer.backgroundColor = self.tintColor.CGColor;
    self.patternLayer.backgroundColor = [UIColor colorWithPatternImage:self.patternImage].CGColor;
}

- (void)resizeInnerLayers {
    self.fillClipLayer.frame = (CGRect){ CGPointZero, CGSizeMake(self.bounds.size.width / 1.0 * self.progress, self.bounds.size.height) };
}


#pragma mark - Setters & Getters

- (void)setAnimates:(BOOL)animates {
    if (_animates != animates) {
        _animates = animates;
        
        if (_animates) {
            [CATransaction begin]; {
                if (![self.patternLayer animationForKey:kStripesAnimationKey] && self.animates && !self.it_isHidden) {
                    [self.patternLayer addAnimation:[self stripesAnimation] forKey:kStripesAnimationKey];
                }
                
                [self.patternLayer addAnimation:[self opacityAnimationToVisible:YES] forKey:kOpacityAnimationKey];
                self.patternLayer.opacity = kPatternOpacity;
            } [CATransaction commit];
        } else {
            [CATransaction begin]; {
                [CATransaction setCompletionBlock:^{
                    if ([self.patternLayer animationForKey:kStripesAnimationKey] && !self.animates) {
                        [self.patternLayer removeAnimationForKey:kStripesAnimationKey];
                    }
                }];
                
                [self.patternLayer addAnimation:[self opacityAnimationToVisible:NO] forKey:kOpacityAnimationKey];
                self.patternLayer.opacity = 0.0;
            } [CATransaction commit];
        }
    }
}

- (CALayer *)clipLayer {
    if (!_clipLayer) {
        _clipLayer = [CALayer layer];
        _clipLayer.masksToBounds = YES;
    }
    return _clipLayer;
}

- (CAGradientLayer *)backgroundLayer {
    if (!_backgroundLayer) {
        _backgroundLayer = [CAGradientLayer layer];
        _backgroundLayer.colors = @[ (id)[UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:0.60f].CGColor,
                                     (id)[UIColor colorWithRed:0.71f green:0.71f blue:0.71f alpha:0.60f].CGColor ];
    }
    return _backgroundLayer;
}


- (CALayer *)patternLayer {
    if (!_patternLayer) {
        _patternLayer = [CALayer layer];
        _patternLayer.anchorPoint = CGPointMake(0, 0.5);
        _patternLayer.opacity = kPatternOpacity;
    }
    return _patternLayer;
}

- (CALayer *)fillClipLayer {
    if (!_fillClipLayer) {
        _fillClipLayer = [CALayer layer];
        _fillClipLayer.masksToBounds = YES;
    }
    return _fillClipLayer;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self resizeInnerLayers];
}

- (CABasicAnimation *)stripesAnimation {
    CABasicAnimation *moveAnim;
    moveAnim                     = [CABasicAnimation animationWithKeyPath:@"position.x"];
    moveAnim.fromValue           = @( -self.patternImage.size.width );
    moveAnim.byValue             = @( self.patternImage.size.width );
    moveAnim.duration            = self.animationDuration;
    moveAnim.removedOnCompletion = NO;
    moveAnim.repeatCount         = HUGE_VAL;
    moveAnim.autoreverses        = NO;
    
    return moveAnim;
}

- (CABasicAnimation *)opacityAnimationToVisible:(BOOL)visible {
    CABasicAnimation *moveAnim;
    moveAnim                     = [CABasicAnimation animationWithKeyPath:@"opacity"];
    moveAnim.fromValue           = @( [self.patternLayer.presentationLayer opacity] );
    moveAnim.toValue             = @( visible * kPatternOpacity );
    moveAnim.duration            = 0.2;
    moveAnim.removedOnCompletion = NO;
    moveAnim.autoreverses        = NO;
    
    return moveAnim;
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    [self resizeLayers];
}


#pragma mark - Drawing

- (UIImage *)stripesImageWithSize:(CGSize)size {
	return [UIImage imageForSize:size withDrawingBlock:^{
        UIColor* color = [UIColor whiteColor];
        
        //// Frames
        CGRect frame = (CGRect){ CGPointZero, size };
        
        //// LargeStripe Drawing
        UIBezierPath* largeStripePath = [UIBezierPath bezierPath];
        [largeStripePath moveToPoint: CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame))];
        [largeStripePath addLineToPoint: CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame) + 0.50000 * CGRectGetHeight(frame))];
        [largeStripePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), CGRectGetMinY(frame))];
        [largeStripePath addLineToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame))];
        [largeStripePath addLineToPoint: CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame))];
        [largeStripePath closePath];
        [color setFill];
        [largeStripePath fill];
        
        
        //// SmallTripe Drawing
        UIBezierPath* smallTripePath = [UIBezierPath bezierPath];
        [smallTripePath moveToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
        [smallTripePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), CGRectGetMaxY(frame))];
        [smallTripePath addLineToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + 0.50000 * CGRectGetHeight(frame))];
        [smallTripePath addLineToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
        [smallTripePath closePath];
        [color setFill];
        [smallTripePath fill];

    }];
}

@end
