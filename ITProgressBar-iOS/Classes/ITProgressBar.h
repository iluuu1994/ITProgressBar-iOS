//
//  ITProgressBar.h
//  ITProgressIndicator-iOS
//
//  Created by Ilija Tovilo on 08/11/13.
//  Copyright (c) 2013 Ilija Tovilo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  ITProgressBar is a simple iOS 7 style progress bar control.
 */
@interface ITProgressBar : UIView

/// @property animates - Indicates of the pattern layer is shown and animates
@property (nonatomic) BOOL animates;

/// @property progress - A value from 0.0 to 1.0 that indicates the progress of the operation
@property (nonatomic) CGFloat progress;

/// @property patternImage - The image that should be drawn over the fill
@property (nonatomic, strong) UIImage *patternImage;

/// @property animationDuration - The duration of
@property (nonatomic) CGFloat animationDuration;

@end
